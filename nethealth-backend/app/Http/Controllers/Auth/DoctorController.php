<?php

namespace App\Http\Controllers\Auth;

use App\Enums\AccountStatus;
use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Doctor\StoreDoctorRequest;
use App\Models\Doctor;
use App\Traits\RegistersUsers;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
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

        try {
            // 1. ATTEMPT THE TRANSACTION
            $user = DB::transaction(function () use ($request, $data) {

                $user = $this->createBaseUser($data, UserRole::Doctor->value);

                $documentPaths = [];
                if ($request->hasFile('verification_documents')) {
                    foreach ($request->file('verification_documents') as $file) {
                        $documentPaths[] = $file->store('verification_documents/doctors', 'public');
                    }
                }

                Doctor::create([
                    'user_id' => $user->id,
                    'medical_license' => $data['medical_license_number'],
                    'specialty' => $data['specialty'],
                    'professional_title' => $data['professional_title'],
                    'syndicate_id' => $data['syndicate_id'],
                    'consultation_fee' => $data['consultation_fee'],
                    'experience' => $data['experience'] ?? null,
                    'qualifications' => $data['qualifications'] ?? null,
                    'verification_documents' => $documentPaths,
                ]);

                return $user;
            });

            // 2. IF SUCCESSFUL, LOG THEM IN
            Auth::login($user);

            $status = Auth::user()->account_status;
            $statusValue = $status instanceof AccountStatus ? $status->value : $status;

            if ($statusValue !== AccountStatus::Active->value) {
                return redirect()->route('waiting.approval');
            }

            return redirect()->route('dashboard', ['role' => Auth::user()->role])
                ->with('success', 'Welcome to your dashboard!');

        } catch (\Throwable $e) {
            // 3. IF IT CRASHES, CATCH THE ERROR GRACEFULLY

            // Log it so you can see what actually broke in storage/logs/laravel.log
            \Illuminate\Support\Facades\Log::error('Doctor Registration Failed: '.$e->getMessage());

            // Redirect back to the form and show them a message
            return back()->withErrors(['email' => 'An error occurred during registration. Please check your details and try again.']);
        }
    }
}
