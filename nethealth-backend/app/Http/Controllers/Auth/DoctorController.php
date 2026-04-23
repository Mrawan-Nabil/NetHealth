<?php

namespace App\Http\Controllers\Auth;

use App\Enums\AccountStatus;
use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Doctor\StoreDoctorRequest;
use App\Models\Doctor;
use App\Traits\RegistersUsers;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class DoctorController extends Controller
{
    use RegistersUsers;
    public function create()
    {
        return Inertia::render('RegisterDoctor');
    }

    public function store(StoreDoctorRequest $request)
    {
        $data = $request->validated();

        // Pass clinic_id into the base user creation so it gets stored on the users table FK.
        $user = $this->createBaseUser($data, UserRole::Doctor->value);

        // If a clinic_id was provided (e.g. admin pre-assigns), update the user record.
        if (! empty($data['clinic_id'])) {
            $user->update(['clinic_id' => $data['clinic_id']]);
        }

        $documentPaths = [];
        if ($request->hasFile('verification_documents')) {
            foreach ($request->file('verification_documents') as $file) {
                $documentPaths[] = $file->store('verification_documents/doctors', 'public');
            }
        }

        Doctor::create([
            'user_id'                => $user->id,
            'medical_license'        => $data['medical_license_number'],
            'specialty'              => $data['specialty'],
            'professional_title'     => $data['professional_title'],
            'syndicate_id'           => $data['syndicate_id'],
            'consultation_fee'       => $data['consultation_fee'],
            'experience'             => $data['experience'] ?? null,
            'qualifications'         => $data['qualifications'] ?? null,
            'verification_documents' => $documentPaths,
        ]);
        Auth::login($user);

        if ($user->account_status !== AccountStatus::Active) {
            return redirect()->route('waiting.approval');
        }

        return redirect()->route('dashboard', ['role' => Auth::user()->role])
            ->with('success', 'Welcome to your dashboard!');

    }
}
