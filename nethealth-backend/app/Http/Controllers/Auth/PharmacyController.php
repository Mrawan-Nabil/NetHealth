<?php

namespace App\Http\Controllers\Auth;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Pharmacy\StorePharmacyRequest;
use App\Models\Pharmacy;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;

class PharmacyController extends Controller
{
    public function create()
    {
        return Inertia::render('RegisterPharmacy');
    }

    public function store(StorePharmacyRequest $request)
    {
        $data = $request->validated();
//        dd($request->all());
        $user =
            user::create([
                'full_name' => $data['full_name'],
                'email' => $data['email'],
                'phone' => $data['phone'],
                'gender' => $data['gender'],
                'birth_date' => $data['date_of_birth'],
                'governorate' => $data['governorate'],
                'role' => UserRole::Pharmacy->value,
                'password' => Hash::make($data['password']),

            ]);
        Pharmacy::create([
            'user_id' => $user->id,
            'pharmacy_name' => $data['pharmacy_name'],
            'license_number' => $data['license_number'],
            'pharmacy_phone' => $data['pharmacy_phone'],
            'pharmacy_address' => $data['pharmacy_address'],
            'pharmacy_governorate' => $data['pharmacy_governorate'],
            'commercial_registration_number' => $data['commercial_registration_number'],
            'tax_id' => $data['tax_id'],
        ]);

        Auth::login($user);

        return redirect()
            ->route('home')
            ->with('success', 'Pharmacy registered successfully');
    }
}
