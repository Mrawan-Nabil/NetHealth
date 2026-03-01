<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Patient\StorePatientRequest;
use App\Models\Patient;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PatientController extends Controller
{
    public function create()
    {
        return Inertia::render('RegisterPatient');
    }

    public function store(StorePatientRequest $request)
    {

        $data = $request->validated();

        $user = User::create([
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'gender' => $data['gender'],
            'birth_date' => $data['date_of_birth'],
            'governorate' => $data['governorate'],
            'national_id' => $data['national_id'],
            'role' => UserRole::Patient->value,
            'password' => Hash::make($data['password']),
        ]);
        Patient::create([
            'user_id' => $user->id,
            'blood_type' => $data['blood_type'],
            'allergies' => $data['allergies'] ?? null,
            'chronic_conditions' => $data['chronic_conditions'] ?? null,
            'emergency_contact_name' => $data['emergency_contact_name'] ?? null,
            'emergency_contact_phone' => $data['emergency_contact_phone'] ?? null,
        ]);

        Auth::login($user);

        return redirect()->route('home')->with('success', 'Registration Successful!');
    }
}
