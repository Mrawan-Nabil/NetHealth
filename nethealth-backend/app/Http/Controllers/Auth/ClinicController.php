<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Clinic\StoreClinicRequest;
use App\Models\Clinic;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
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
            'clinic_type' => $data['clinic_type'],
            'clinic_phone' => $data['clinic_phone'],
            'clinic_address' => $data['clinic_address'],
            'clinic_governorate' => $data['clinic_governorate'],
            'license_number' => $data['license_number'],
            'commercial_registration_number' => $data['commercial_registration_number'],
            'tax_id' => $data['tax_id'],
            'verification_documents' => $data['verification_documents'],
            'is_verified' => false,
        ]);

        return redirect()
            ->route('home')
            ->with('success', 'Clinic registered successfully');
    }
}
