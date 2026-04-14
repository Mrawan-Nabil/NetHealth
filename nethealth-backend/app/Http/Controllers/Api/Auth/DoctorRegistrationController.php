<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Api\ApiController;
use App\Http\Resources\Api\UserResource;
use App\Models\Doctor;
use App\Models\User;
use App\Traits\RegistersUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DoctorRegistrationController extends ApiController
{
    use RegistersUsers;

    public function store(Request $request)
    {
        $validated = $request->validate(array_merge($this->baseUserRules(), [
            // Doctor Specific Fields
            'medical_license' => 'required|string|unique:doctors',
            'specialty' => 'required|string',
            'professional_title' => 'required|string',
            'syndicate_id' => 'required|string|unique:doctors',
            'consultation_fee' => 'required|numeric|min:0',
            'experience' => 'required|integer|min:0',
            'qualifications' => 'required|string',
        ]));

        $user = DB::transaction(function () use ($validated) {

            // 1. Create Base User
            $user = $this->createBaseUser($validated, 'doctor');

            // 2. Create Doctor Profile
            Doctor::create([
                'user_id' => $user->id,
                'medical_license' => $validated['medical_license'],
                'specialty' => $validated['specialty'],
                'professional_title' => $validated['professional_title'],
                'syndicate_id' => $validated['syndicate_id'],
                'consultation_fee' => $validated['consultation_fee'],
                'experience' => $validated['experience'],
                'qualifications' => $validated['qualifications'],
            ]);

            return $user;
        });

        $token = $user->createToken('flutter-app')->plainTextToken;

        return $this->successResponse([
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => new UserResource($user),
        ], 'Doctor account created successfully. Awaiting admin approval.', 201);
    }
}
