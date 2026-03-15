<?php

namespace App\Http\Controllers\Auth;

use App\Enums\AccountStatus;
use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Patient\StorePatientRequest;
use App\Http\Requests\Patient\UpdateProfileRequest;
use App\Models\Appointment;
use App\Models\MedicalAttachment;
use App\Models\Patient;
use App\Models\Prescription;
use App\Traits\RegistersUsers;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
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
        //        dd('patient is working');

        if (Auth::user()->account_status !== AccountStatus::Active) {
            return redirect()->route('waiting.approval');
        }

        return redirect()->route('dashboard', ['role' => Auth::user()->role])
            ->with('success', 'Welcome to your dashboard!');

    }

    public function index()
    {
        $patient = auth()->user()->patient;

        $healthOverview = [
            'blood_type' => $patient->blood_type,
            'allergies' => $patient->allergies,
            'chronic_conditions' => $patient->chronic_conditions,
        ];

        $upcomingAppointments = Appointment::where('patient_id', $patient->id)
            ->where('appointment_status', 'scheduled')
            ->count();

        $latestPrescriptionCount = Prescription::where('prescription_status', 'issued')
            ->whereHas('medicalRecord', function ($q) use ($patient) {
                $q->where('patient_id', $patient->id);
            })
            ->count();

        $pendingTests = MedicalAttachment::where('test_result_status', 'pending')
            ->whereHas('medicalRecord', function ($query) use ($patient) {
                $query->where('patient_id', $patient->id);
            })
            ->count();

        $nextAppointment = Appointment::where('patient_id', $patient->id)
            ->where('appointment_status', 'scheduled')
            ->orderBy('appointment_time')
            ->first();

        // 1. ADDED: Fetch the 3 most recent appointments/records for the "Recent Medical Records" card
        $recentRecords = Appointment::where('patient_id', $patient->id)
            ->where('appointment_status', 'completed')
            ->with('doctor.user')
            ->orderBy('appointment_time', 'desc')
            ->take(3)
            ->get()
            ->map(function ($appointment) {
                // Map it to look exactly like the dummy data the Vue component expects
                return [
                    'title' => 'Visit Summary',
                    'doctor' => 'Dr. '.$appointment->doctor->user->full_name,
                    'date' => $appointment->appointment_time->format('M d, Y'),
                    'status' => 'Completed',
                ];
            });

        // 2. ADDED: A basic activity timeline.
        // (Later, you might want to pull this from a dedicated 'activity_logs' table)
        $activities = [
            [
                'title' => 'Appointment confirmed with Dr. Ayman',
                'time' => now()->subHours(2)->diffForHumans(), // Carbon makes this "2 hours ago"
                'type' => 'appointment', // Matches your Vue color keys!
            ],
            [
                'title' => 'Blood Test results uploaded',
                'time' => now()->subDay()->diffForHumans(), // "1 day ago"
                'type' => 'test',
            ],
            [
                'title' => 'Prescription renewed',
                'time' => now()->subDays(3)->diffForHumans(), // "3 days ago"
                'type' => 'prescription',
            ],
        ];

        return inertia('PatientDashboard/Dashboard', [
            'healthOverview' => $healthOverview,
            'upcomingAppointments' => $upcomingAppointments,
            'latestPrescriptionCount' => $latestPrescriptionCount,
            'pendingTests' => $pendingTests,
            'nextAppointment' => $nextAppointment,
            'recentRecords' => $recentRecords,
            'activities' => $activities,
        ]);

    }

    // profile view
    public function show()
    {
        // return current data in view -> pass it to fields
        $user = auth()->user();
        //        return inertia('Profile', [
        //            'user' => $user->load('patient')
        //        ]);
    }

    // when click save changes -> save data
    public function update(UpdateProfileRequest $request)
    {
        $user = auth()->user();
        $patient = $user->patient;

        $data = $request->validated();

        /*
        * add avatar in DB & handle it
        */
        $user->update([
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'national_id' => $data['national_id'],
            'date_of_birth' => $data['date_of_birth'],
            'gender' => $data['gender'],
            'governorate' => $data['governorate'],
        ]);

        $patient->update([
            'emergency_contact_name' => $data['emergency_contact_name'],
            'emergency_contact_phone' => $data['emergency_contact_phone'],
            'emergency_contact_relationship' => $data['emergency_contact_relationship'],
        ]);

        // Handle password change
        if ($request->filled('old_password') && $request->filled('new_password')) {

            if (! Hash::check($request->old_password, $user->password)) {
                return back()->withErrors([
                    'old_password' => 'Current password is incorrect',
                ]);
            }

            $user->update([
                'password' => Hash::make($request->new_password),
            ]);
        }

        return back()->with('success', 'Profile updated');
    }
}
