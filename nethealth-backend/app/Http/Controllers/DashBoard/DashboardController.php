<?php

namespace App\Http\Controllers\DashBoard;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Patient\StorePatientRequest;
use App\Http\Requests\Patient\UpdateProfileRequest;
use App\Models\Appointment;
use App\Models\Prescription;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function create(string $role)
    {
        $user = Auth::user();

        // Safely extract the role value whether it's an Enum object or a raw string
        $actualRole = $user->role instanceof UserRole ? $user->role->value : $user->role;

        // 1. THE SECURITY BOUNCER
        if ($actualRole !== $role) {
            return redirect()->route('dashboard', ['role' => $actualRole]);
        }

        // 2. GET THE COMPONENT NAME (Using the Enum values directly!)
        $component = match ($role) {
            UserRole::Patient->value => 'Dashboards/PatientDashboard',
            UserRole::Doctor->value => 'Dashboards/DoctorDashboard',
            UserRole::Clinic->value => 'Dashboards/ClinicDashboard',
            UserRole::Pharmacy->value => 'Dashboards/PharmacyDashboard',
            UserRole::Admin->value => 'Dashboards/AdminDashboard',
            default => null,
        };

        // 3. HANDLE INVALID ROLES SAFELY
        if (! $component) {
            abort(404, 'Dashboard not found');
        }

        // 4. RENDER THE PAGE WITH DYNAMIC DATA
        return Inertia::render($component, [
            'userData' => [
                'name' => explode(' ', $user->full_name)[0],
                'fullName' => $user->full_name,
                'handle' => '@'.explode('@', $user->email)[0],
                'avatar' => 'https://ui-avatars.com/api/?name='.urlencode($user->full_name).'&background=10b981&color=fff',
            ],
        ]);
    }
}
