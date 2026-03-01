<?php

namespace App\Http\Controllers\Auth;

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
        Clinic::create([
            'name' => $data['name'],
            'license_number' => $data['license_number'],
            'address' => $data['address'],
            'phone' => $data['phone'],
            'governorate' => $data['governorate'],
            'is_verified' => false,
        ]);

        return redirect()
            ->route('home')
            ->with('success', 'Clinic registered successfully');
    }
}
