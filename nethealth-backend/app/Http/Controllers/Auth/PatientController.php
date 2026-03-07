<?php

namespace App\Http\Controllers\Auth;

use App\Enums\AccountStatus;
use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Patient\StorePatientRequest;
use App\Models\Patient;
use App\Traits\RegistersUsers;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class PatientController extends Controller
{
    use RegistersUsers;

    public function create()
    {
        return Inertia::render('RegisterPatient');
    }

    public function store(StorePatientRequest $request)
    {

        $data = $request->validated();

        $user = $this->createBaseUser($data, UserRole::Patient->value);

        Patient::create([
            'user_id' => $user->id,
            'blood_type' => $data['blood_type'],
            'allergies' => $data['allergies'] ?? null,
            'chronic_conditions' => $data['chronic_conditions'] ?? null,
            'emergency_contact_name' => $data['emergency_contact_name'] ?? null,
            'emergency_contact_phone' => $data['emergency_contact_phone'] ?? null,
        ]);

        Auth::login($user);

        if (Auth::user()->account_status !== AccountStatus::Active) {
            return redirect()->route('waiting.approval');
        }

        // If they are active, send them to the intended protected route (or home)
        return redirect()->route('dashboard', ['role' => Auth::user()->role])
            ->with('success', 'Welcome to your dashboard!');
    }
}
