<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Clinic\StoreClinicRequest;
use App\Models\Clinic;
use Inertia\Inertia;

class ClinicController extends Controller
{
    public function create()
    {
        return Inertia::render('RegisterClinic');
    }

    public function store(StoreClinicRequest $request)
    {
        $data = $request->validated();
        $user =
            user::create([
                'full_name' => $data['full_name'],
                'email' => $data['email'],
                'phone' => $data['phone'],
                'gender' => $data['gender'],
                'birth_date' => $data['date_of_birth'],
                'governorate' => $data['governorate'],
                'national_id' => $data['national_id'],
                'role' => UserRole::Clinic->value,
                'password' => Hash::make($data['password']),

            ]);
        Clinic::create([
            'user_id' => $user->id,
            'clinic_name' => $data['clinic_name'],
            'license_number' => $data['license_number'],
            'clinic_address' => $data['clinic_address'],
            'clinic_phone' => $data['clinic_phone'],
            'clinic_governorate' => $data['clinic_governorate'],
            'is_verified' => false,
        ]);

        return redirect()
            ->route('home')
            ->with('success', 'Clinic registered successfully');
    }
}
