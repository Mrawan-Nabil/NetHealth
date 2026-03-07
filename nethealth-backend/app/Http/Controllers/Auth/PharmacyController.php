<?php

namespace App\Http\Controllers\Auth;

use App\Enums\AccountStatus;
use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Pharmacy\StorePharmacyRequest;
use App\Models\Pharmacy;
use App\Traits\RegistersUsers;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class PharmacyController extends Controller
{
    use RegistersUsers;

    public function create()
    {
        return Inertia::render('RegisterPharmacy');
    }

    public function store(StorePharmacyRequest $request)
    {
        $data = $request->validated();
        $user = $this->createBaseUser($data, UserRole::Pharmacy->value);

        $documentPaths = [];
        if ($request->hasFile('verification_documents')) {
            foreach ($request->file('verification_documents') as $file) {
                $documentPaths[] = $file->store('verification_documents/pharmacies', 'public');
            }
        }

        Pharmacy::create([
            'user_id' => $user->id,
            'pharmacy_name' => $data['pharmacy_name'],
            'license_number' => $data['license_number'],
            'pharmacy_phone' => $data['pharmacy_phone'],
            'pharmacy_address' => $data['pharmacy_address'],
            'pharmacy_governorate' => $data['pharmacy_governorate'],
            'commercial_registration_number' => $data['commercial_registration_number'],
            'verification_documents' => $documentPaths,
            'tax_id' => $data['tax_id'],
        ]);

        Auth::login($user);

        if ($user->account_status !== AccountStatus::Active) {
            return redirect()->route('waiting.approval');
        }

        return redirect()->route('dashboard', ['role' => Auth::user()->role])
            ->with('success', 'Welcome to your dashboard!');

    }
}
