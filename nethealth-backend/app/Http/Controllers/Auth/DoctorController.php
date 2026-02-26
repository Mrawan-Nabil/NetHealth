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
    public function create(){
//        return Inertia::render('Login');
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
            'birth_date' => $data['birth_date'],
            'governorate' => $data['governorate'],
            'role' => UserRole::Doctor->value,
        ]);
        Doctor::create([
            'user_id' => $user->id,
            'medical_license' => $data['medical_license'],
            'specialty' => $data['specialty'],
            'experience' => $data['experience'],
            'qualifications' => $data['qualifications'] ?? null,
        ]);

        Auth::login($user);

        return redirect()->route('/')->with('success', 'Registration Successful!');
    }
}
