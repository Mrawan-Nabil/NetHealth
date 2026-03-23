<?php

namespace App\Http\Controllers\Patient;

use App\Http\Controllers\Controller;
use App\Http\Requests\Patient\UpdateProfileRequest;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        $user = $request->user()->load('patient');

        // Safely split the full name for the two Vue inputs
        $nameParts = explode(' ', $user->full_name, 2);
        $firstName = $nameParts[0] ?? '';
        $lastName = $nameParts[1] ?? '';

        // Safely format the date to YYYY-MM-DD for the HTML input
        $formattedDate = $user->birth_date
            ? Carbon::parse($user->birth_date)->format('Y-m-d')
            : '';

        return Inertia::render('PatientDashboard/Profile', [
            // Send exactly what Vue expects
            'profileData' => [
                'first_name' => $firstName,
                'last_name' => $lastName,
                'email' => $user->email,
                'phone' => $user->phone,
                'national_id' => $user->national_id,
                'date_of_birth' => $formattedDate,
                'gender' => $user->gender,
                'governorate' => $user->governorate,
                'avatar' => $user->avatar,
                'id' => $user->id,
            ],
            'emergencyContact' => $user->patient ? [
                'name' => $user->patient->emergency_contact_name,
                'phone' => $user->patient->emergency_contact_phone,
                'relationship' => $user->patient->emergency_contact_relationship,
            ] : null,
        ]);
    }

    public function update(UpdateProfileRequest $request)
    {
        $user = $request->user();
        $patient = $user->patient;

        $data = $request->validated();

        // Recombine the first and last name for the database
        $fullName = trim(($data['first_name'] ?? '').' '.($data['last_name'] ?? ''));

        $user->update([
            'full_name' => $fullName,
            'email' => $data['email'],
            'phone' => $data['phone'],
            'national_id' => $data['national_id'],
            'date_of_birth' => $data['birth_date'],
            'gender' => $data['gender'],
            'governorate' => $data['governorate'],
        ]);
        if ($patient) {
            $patient->update([
                'emergency_contact_name' => $data['emergency_contact_name'],
                'emergency_contact_phone' => $data['emergency_contact_phone'],
                'emergency_contact_relationship' => $data['emergency_contact_relationship'] ?? null,
            ]);
        }

        if ($request->filled('current_password') && $request->filled('password')) {
            if (! Hash::check($request->current_password, $user->password)) {
                return back()->withErrors([
                    'current_password' => 'Current password is incorrect.',
                ]);
            }

            $user->update([
                'password' => Hash::make($request->new_password),
            ]);
        }

        return back()->with('success', 'Profile updated successfully.');
    }
    public function updateAvatar(Request $request)
    {
        $request->validate([
            'avatar' => ['required', 'image', 'mimes:jpeg,png,jpg,webp,gif', 'max:20480'], // Max 10MB
        ]);

        $user = $request->user();

        if ($request->hasFile('avatar')) {
            // 1. Delete the old avatar if it exists
            if ($user->avatar) {
                Storage::disk('public')->delete($user->avatar);
            }

            // 2. Store the new avatar in the 'avatars' folder
            $path = $request->file('avatar')->store('avatars', 'public');

            // 3. Update the user record
            $user->update([
                'avatar' => $path,
            ]);
        }

        return back()->with('success', 'Avatar updated successfully.');
    }

}

