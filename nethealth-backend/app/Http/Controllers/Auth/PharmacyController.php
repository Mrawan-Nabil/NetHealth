<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Pharmacy\StorePharmacyRequest;
use App\Models\Pharmacy;

class PharmacyController extends Controller
{
    public function create() {}

    public function store(StorePharmacyRequest $request)
    {
        $data = $request->validated();
        Pharmacy::create([
            'name' => $data['name'],
            'license_number' => $data['license_number'],
            'phone' => $data['phone'],
            'address' => $data['address'],
            'governorate' => $data['governorate'],
            'is_verified' => false,
        ]);

        return redirect()
            ->route('home')
            ->with('success', 'Pharmacy registered successfully');
    }
}
