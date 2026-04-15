<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Api\ApiController;
use App\Http\Resources\Api\UserResource;
use App\Models\Pharmacy;
use App\Traits\RegistersUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PharmacyRegistrationController extends ApiController
{
    use RegistersUsers;

    public function store(Request $request)
    {
        $validated = $request->validate(array_merge($this->baseUserRules(), [
            'pharmacy_name' => 'required|string',
            'license_number' => 'required|string|unique:pharmacies',
            'pharmacy_address' => 'required|string',
            'commercial_registration_number' => 'required|string|unique:pharmacies',
            'tax_id' => 'required|string|unique:pharmacies',
        ]));

        $user = DB::transaction(function () use ($validated) {

            $user = $this->createBaseUser($validated, 'pharmacy');

            Pharmacy::create([
                'user_id' => $user->id,
                'pharmacy_name' => $validated['pharmacy_name'],
                'license_number' => $validated['license_number'],
                'pharmacy_address' => $validated['address'],
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
        ], 'Pharmacy account created successfully. Awaiting admin approval.', 201);
    }
}
