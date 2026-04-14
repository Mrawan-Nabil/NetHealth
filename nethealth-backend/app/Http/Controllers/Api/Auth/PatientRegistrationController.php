<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Api\ApiController;
use App\Http\Resources\Api\UserResource;
use App\Models\Patient;
use App\Models\User;
use App\Traits\RegistersUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class PatientRegistrationController extends ApiController
{
    use RegistersUsers;

    public function store(Request $request)
    {
        $validated = $request->validate(array_merge($this->baseUserRules(), [
            'blood_type' => 'required|in:A+,A-,B+,B-,AB+,AB-,O+,O-',
            'allergies' => 'nullable|array',
            'chronic_conditions' => 'nullable|string',
            'emergency_contact_name' => 'nullable|string',
            'emergency_contact_phone' => 'nullable|string',
            'emergency_contact_relationship' => 'nullable|string',
        ]));

        // Use a database transaction so if the Patient fails to create, the User isn't left orphaned
        $user = DB::transaction(function () use ($validated) {

            // 1. Create the base User
            $user = $this->createBaseUser($validated, 'patient');

            // 2. Create the Patient profile
            Patient::create([
                'user_id' => $user->id,
                'blood_type' => $validated['blood_type'],
                'allergies' => $validated['allergies'] ?? [],
                'chronic_conditions' => $validated['chronic_conditions'],
                'emergency_contact_name' => $validated['emergency_contact_name'],
                'emergency_contact_phone' => $validated['emergency_contact_phone'],
                'emergency_contact_relationship' => $validated['emergency_contact_relationship'],
            ]);

            return $user;
        });

        // 3. Issue the token
        $token = $user->createToken('flutter-app')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Account created successfully. Awaiting admin approval.',
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => new UserResource($user),
        ], 201);
    }
}
