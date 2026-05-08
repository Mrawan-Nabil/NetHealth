<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Traits\AvatarResolver;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class ProfileController extends Controller
{
    use AvatarResolver;

    /**
     * Display the Doctor Profile page
     */
    public function show(Request $request)
    {
        // Eager load the doctor details and read-only clinic
        $user = $request->user()->load(['doctor', 'clinic']);

        // Safely split the full name for the two Vue inputs
        $nameParts = explode(' ', $user->full_name, 2);
        $firstName = $nameParts[0] ?? '';
        $secondName = $nameParts[1] ?? '';

        // Safely format the date to YYYY-MM-DD for the HTML input
        $formattedDate = $user->birth_date
            ? Carbon::parse($user->birth_date)->format('Y-m-d')
            : '';

        // Build default schedule if one doesn't exist in the database
        $schedule = [
            'days' => [
                ['name' => 'Monday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
                ['name' => 'Tuesday',   'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
                ['name' => 'Wednesday', 'enabled' => false, 'from' => '',         'to' => ''],
                ['name' => 'Thursday',  'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
                ['name' => 'Friday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '02:00 PM'],
                ['name' => 'Saturday',  'enabled' => false, 'from' => '',         'to' => ''],
                ['name' => 'Sunday',    'enabled' => false, 'from' => '',         'to' => ''],
            ],
            'duration' => '30 min',
            'breakBetweenSlots' => '5 min',
            'selectedPreset' => null,
            'appointmentTypes' => ['inClinic' => true, 'followUp' => true, 'labReview' => true],
            'labReviewOptions' => ['acceptLabTests' => true, 'acceptXrayImages' => true],
        ];

        return Inertia::render('DoctorDashboard/Profile', [
            // Send exactly what the Doctor Vue Profile expects
            'doctor' => [
                'id' => $user->id,
                'name' => 'Dr. '.$firstName,
                'fullName' => $user->full_name,
                'handle' => '@'.($user->username ?? strtolower($firstName).$user->id),
                'avatar' => $this->resolveAvatarUrl($user->avatar, $user->full_name ?? 'Doctor', '14B8A6'),
                'firstName' => $firstName,
                'secondName' => $secondName,
                'email' => $user->email,
                'phone' => $user->phone,
                'nationalId' => $user->national_id,
                'dob' => $formattedDate,
                'gender' => $user->gender?->value ?? $user->gender ?? 'na',
                'address' => $user->governorate ?? $user->address ?? '', // Fallback depending on your DB column name

                // Doctor specific details
                'specialty' => $user->doctor->specialty ?? '',
                'experience' => (string) ($user->doctor->experience ?? ''),
                'consultationFee' => (string) ($user->doctor->consultation_fee ?? ''),
                'about' => $user->doctor->about ?? '',

                // Read-only clinic data
                'clinic' => $user->clinic ? [
                    'name' => $user->clinic->clinic_name ?? 'NetHealth Clinic',
                    'address' => $user->clinic->clinic_address ?? '',
                ] : null,
            ],
            // Pass schedule array
            'schedule' => $user->doctor->schedule ?? $schedule,
        ]);
    }

    /**
     * Update the Doctor's Profile information
     */
    public function update(Request $request)
    {
        $user = $request->user();
        $doctor = $user->doctor;

        // 1. Validate the exact JSON structure sent by the Vue useForm
        $data = $request->validate([
            'firstName' => 'required|string|max:255',
            'secondName' => 'required|string|max:255',
            'email' => ['required', 'email', Rule::unique('users')->ignore($user->id)],
            'countryCode' => 'nullable|string',
            'phone' => 'nullable|string',
            'nationalId' => 'nullable|string',
            'dob' => 'nullable|date',
            'gender' => 'nullable|in:male,female,na',
            'address' => 'nullable|string',
            'specialty' => 'nullable|string',
            'experience' => 'nullable|string',
            'consultationFee' => 'nullable|numeric',
            'about' => 'nullable|string',

            // Password logic
            'currentPassword' => 'nullable|string',
            'newPassword' => 'nullable|string|min:8',
            'confirmPassword' => 'nullable|string|same:newPassword',
        ]);

        // Recombine the first and second name
        $fullName = trim(($data['firstName'] ?? '').' '.($data['secondName'] ?? ''));

        // 2. Update the base User record
        $user->update([
            'full_name' => $fullName,
            'email' => $data['email'],
            'phone' => $data['phone'],
            'national_id' => $data['nationalId'],
            'birth_date' => $data['dob'],
            'gender' => $data['gender'],
            'governorate' => $data['address'], // Assuming address maps to governorate based on Patient ref
        ]);

        // 3. Update the specific Doctor record
        if ($doctor) {
            $doctor->update([
                'specialty' => $data['specialty'],
                'experience' => $data['experience'],
                'consultation_fee' => $data['consultationFee'],
            ]);
        }

        // 4. Handle Password Updates
        if ($request->filled('currentPassword') && $request->filled('newPassword')) {
            if (! Hash::check($request->currentPassword, $user->password)) {
                return back()->withErrors([
                    'currentPassword' => 'Current password is incorrect.',
                ]);
            }

            $user->update([
                'password' => Hash::make($request->newPassword),
            ]);
        }

        return back()->with('success', 'Profile updated successfully.');
    }

    /**
     * Update the Avatar Image
     */
    public function updateAvatar(Request $request)
    {
        $request->validate([
            'avatar' => ['required', 'image', 'mimes:jpeg,png,jpg,webp,gif', 'max:10240'], // Max 10MB
        ]);

        $user = $request->user();

        if ($request->hasFile('avatar')) {
            // Delete old avatar if it exists
            if ($user->avatar) {
                Storage::disk('public')->delete($user->avatar);
            }

            // Store new avatar in 'avatars' folder
            $path = $request->file('avatar')->store('avatars', 'public');

            $user->update([
                'avatar' => $path,
            ]);
        }

        return back()->with('success', 'Profile photo updated successfully.');
    }

    /**
     * Remove the Avatar Image
     */
    public function removeAvatar(Request $request)
    {
        $user = $request->user();

        if ($user->avatar) {
            Storage::disk('public')->delete($user->avatar);
            $user->update([
                'avatar' => null,
            ]);
        }

        return back()->with('success', 'Profile photo removed successfully.');
    }
}
