<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Api\ApiController;
use App\Http\Resources\Api\UserResource;
use App\Models\Clinic;
use App\Traits\RegistersUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ClinicRegistrationController extends ApiController
{
    use RegistersUsers;

    public function store(Request $request)
    {
        $validated = $request->validate(array_merge($this->baseUserRules(), [
            'clinic_name' => 'required|string',
            'license_number' => 'required|string|unique:clinics',
            'clinic_address' => 'required|string',
            'clinic_governorate' => 'required|string',
            'clinic_phone' => 'required|string',
            'clinic_type' => 'required|string',
            'commercial_registration_number' => 'required|string|unique:clinics',
            'tax_id' => 'required|string|unique:clinics',
        ]));

        $user = DB::transaction(function () use ($validated) {

            $user = $this->createBaseUser($validated, 'clinic');

            Clinic::create([
                'user_id' => $user->id,
                'clinic_name' => $validated['clinic_name'],
                'license_number' => $validated['license_number'],
                'clinic_address' => $validated['clinic_address'],
                'clinic_governorate' => $validated['clinic_governorate'],
                'clinic_phone' => $validated['clinic_phone'],
                'clinic_type' => $validated['clinic_type'],
                'commercial_registration_number' => $validated['commercial_registration_number'],
                'tax_id' => $validated['tax_id'],
            ]);

            return $user;
        });

        $token = $user->createToken('flutter-app')->plainTextToken;

        return $this->successResponse([
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => new UserResource($user),
        ], 'Clinic account created successfully. Awaiting admin approval.', 201);
    }
}
