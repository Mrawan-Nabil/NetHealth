<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Doctor\StoreDoctorRequest;
use App\Models\Doctor;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;

class DoctorController extends Controller
{
    public function create()
    {
        return Inertia::render('RegisterDoctor');
    }

    public function store(StoreDoctorRequest $request)
    {
        $data = $request->validated();

        $user = User::create([
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'password' => Hash::make($data['password']),
            'gender' => $data['gender'],
            'birth_date' => $data['date_of_birth'], // FIXED: Matches frontend & patient
            'governorate' => $data['governorate'],
            'role' => UserRole::Doctor->value,
        ]);

        Doctor::create([
            'user_id' => $user->id,
            'national_id' => $data['national_id'], // ADDED: National ID from frontend
            'medical_license' => $data['medical_license_number'], // FIXED: Matches frontend payload
            'specialty' => $data['specialty'],
            'experience' => $data['experience'] ?? null, // ADDED: Null fallback
            'qualifications' => $data['qualifications'] ?? null,
        ]);

        // TODO: Handle the 'verification_documents' file uploads here
        // if ($request->hasFile('verification_documents')) { ... }

        Auth::login($user);

        // FIXED: Changed route('/') to route('home') to match Patient controller
        return redirect()->route('home')->with('success', 'Registration Successful!');
    }
}
