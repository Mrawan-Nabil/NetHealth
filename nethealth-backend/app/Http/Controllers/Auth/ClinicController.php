<?php

namespace App\Http\Controllers\Auth;

use App\Enums\AccountStatus;
use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Clinic\StoreClinicRequest;
use App\Models\Clinic;
use App\Traits\RegistersUsers;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class ClinicController extends Controller
{
    use RegistersUsers;

    public function create()
    {
        return Inertia::render('RegisterClinic');
    }

    public function store(StoreClinicRequest $request)
    {
        $data = $request->validated();

        $user = $this->createBaseUser($data, UserRole::Clinic->value);
        // Handle file uploads
        $documentPaths = [];
        if ($request->hasFile('verification_documents')) {
            foreach ($request->file('verification_documents') as $file) {
                $documentPaths[] = $file->store('verification_documents/clinics', 'public');
            }
        }

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
            'verification_documents' => $documentPaths,
            'is_verified' => false,
        ]);

        if ($user->account_status !== AccountStatus::Active) {
            return redirect()->route('waiting.approval');
        }

        return redirect()->route('dashboard', ['role' => Auth::user()->role])
            ->with('success', 'Welcome to your dashboard!');
    }
}
