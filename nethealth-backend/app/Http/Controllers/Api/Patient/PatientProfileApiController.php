<?php

namespace App\Http\Controllers\Api\Patient;

use App\Http\Controllers\Api\ApiController;
use App\Http\Resources\Api\PatientProfileResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules\Password;

class PatientProfileApiController extends ApiController
{
    public function show(Request $request)
    {
        $patient = $request->user()->patient;

        if (!$patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        return $this->successResponse(
            new PatientProfileResource($patient),
            'Patient profile loaded successfully.'
        );
    }

    public function update(Request $request)
    {
        $user = $request->user();
        $patient = $user->patient;

        if (!$patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $validated = $request->validate([
            'full_name' => 'nullable|string|max:255',
            'phone' => 'nullable|string|max:20',
            'gender' => 'nullable|string|in:male,female',
            'birth_date' => 'nullable|date',
            'governorate' => 'nullable|string|max:100',
            
            'blood_type' => 'nullable|string',
            'allergies' => 'nullable|array',
            'chronic_conditions' => 'nullable|string',
            'emergency_contact' => 'nullable|array',
            'emergency_contact.name' => 'nullable|string|max:255',
            'emergency_contact.phone' => 'nullable|string|max:20',
            'emergency_contact.relationship' => 'nullable|string|max:100',
        ]);

        // Update User
        $user->update([
            'full_name' => $request->input('full_name', $user->full_name),
            'phone' => $request->input('phone', $user->phone),
            'gender' => $request->input('gender', $user->gender),
            'birth_date' => $request->input('birth_date', $user->birth_date),
            'governorate' => $request->input('governorate', $user->governorate),
        ]);

        // Update Patient
        $patientData = [
            'blood_type' => $request->input('blood_type', $patient->blood_type),
            'allergies' => $request->input('allergies', $patient->allergies),
            'chronic_conditions' => $request->input('chronic_conditions', $patient->chronic_conditions),
        ];

        if ($request->has('emergency_contact')) {
            $patientData['emergency_contact_name'] = $request->input('emergency_contact.name');
            $patientData['emergency_contact_phone'] = $request->input('emergency_contact.phone');
            $patientData['emergency_contact_relationship'] = $request->input('emergency_contact.relationship');
        }

        $patient->update($patientData);

        return $this->successResponse(
            new PatientProfileResource($patient->fresh()),
            'Profile updated successfully.'
        );
    }

    public function updateAvatar(Request $request)
    {
        $request->validate([
            'avatar' => 'required|image|mimes:jpeg,png,jpg,gif|max:5120',
        ]);

        $user = $request->user();

        if ($request->hasFile('avatar')) {
            // Delete old avatar if it's not a generic UI avatar and exists
            if ($user->avatar && Storage::disk('public')->exists($user->avatar)) {
                Storage::disk('public')->delete($user->avatar);
            }

            $path = $request->file('avatar')->store('avatars', 'public');
            $user->update(['avatar' => $path]);
        }

        // Return just the new URL to update UI immediately if needed
        $avatarUrl = str_starts_with($user->avatar, 'http') 
            ? $user->avatar 
            : asset('storage/' . $user->avatar);

        return response()->json([
            'status' => 'success',
            'message' => 'Avatar updated successfully.',
            'data' => [
                'avatar_url' => $avatarUrl
            ]
        ]);
    }

    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required|current_password',
            'password' => ['required', 'confirmed', Password::min(8)],
        ]);

        $request->user()->update([
            'password' => Hash::make($request->password)
        ]);

        return $this->successResponse(null, 'Password updated successfully.');
    }
}
