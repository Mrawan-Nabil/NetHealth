<?php

namespace App\Http\Controllers\Patient;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\MedicalAttachment;
use App\Models\Prescription;
use Illuminate\Http\Request;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $patient = $user->patient;

        if (! $patient) {
            return redirect()->route('patient.setup.profile');
        }

        // 1. Find the "Primary" or Most Recent Doctor via Appointments
        $latestAppointment = Appointment::with('doctor.user')
            ->where('patient_id', $patient->user_id)
            ->orderBy('appointment_time', 'desc')
            ->first();

        $recentDoctor = $latestAppointment?->doctor;

        // 2. Build the Health Overview safely
        $healthOverview = [
            'blood_type' => $patient->blood_type,
            'allergies' => $patient->allergies,
            'chronic_conditions' => $patient->chronic_conditions,

            // Map the doctor from the latest appointment, if they have one
            'doctor' => $recentDoctor ? [
                'specialty' => $recentDoctor->specialty ?? 'General Practice',
                'user' => [
                    'full_name' => $recentDoctor->user->full_name,
                    'avatar' => $recentDoctor->user->avatar,
                ],
            ] : null,
        ];

        $upcomingAppointments = Appointment::where('patient_id', $patient->user_id)
            ->where('appointment_status', 'scheduled')
            ->count();

        $latestPrescriptionCount = Prescription::where('prescription_status', 'issued')
            ->whereHas('medicalRecord', function ($q) use ($patient) {
                $q->where('patient_id', $patient->user_id);
            })
            ->count();

        $pendingTests = MedicalAttachment::where('test_result_status', 'pending')
            ->whereHas('medicalRecord', function ($query) use ($patient) {
                $query->where('patient_id', $patient->user_id);
            })
            ->count();

        // 2 & 3. Fix Next Appointment Structure & Null Handling
        $nextApptModel = Appointment::with(['doctor.user', 'clinic'])
            ->where('patient_id', $patient->user_id)
            ->where('appointment_status', 'scheduled')
            ->orderBy('appointment_time')
            ->first();

        // Map it perfectly to what AppointmentDetailsModal.vue and AppointmentCard.vue expects
        $nextAppointment = $nextApptModel ? [
            'id' => $nextApptModel->id,
            'appointment_status' => $nextApptModel->appointment_status,
            'appointment_time' => \Carbon\Carbon::parse($nextApptModel->appointment_time)->format('h:i A'),
            'time' => \Carbon\Carbon::parse($nextApptModel->appointment_time)->format('M d, Y - h:i A'),
            'doctor' => [
                'specialty' => $nextApptModel->doctor?->specialty ?? 'General Practice',
                'user' => [
                    'full_name' => $nextApptModel->doctor?->user?->full_name ?? 'Unknown Doctor',
                    'avatar' => $nextApptModel->doctor?->user?->avatar,
                ],
            ],
            'clinic' => [
                'clinic_address' => $nextApptModel->clinic?->clinic_address ?? 'Main Clinic',
            ],
            'location' => $nextApptModel->clinic?->clinic_name ?? 'Main Clinic',
            'type' => $nextApptModel->appointment_type ?? 'General Consultation',
            'duration' => '30 minutes', // Or map from DB
            'notes' => $nextApptModel->notes,
        ] : null;

        // 4. Fix Recent Records
        $recentRecords = Appointment::where('patient_id', $patient->user_id)
            ->where('appointment_status', 'completed')
            ->with('doctor.user')
            ->orderBy('appointment_time', 'desc')
            ->take(3)
            ->get()
            ->map(function ($appointment) {
                return [
                    'id' => $appointment->id,
                    'title' => 'Visit Summary',
                    // Safe fallback if doctor was deleted
                    'doctor' => $appointment->doctor ? 'Dr. '.$appointment->doctor->user?->full_name : 'Unknown Doctor',
                    'date' => \Carbon\Carbon::parse($appointment->appointment_time)->format('M d, Y'),
                    'status' => 'completed',
                ];
            });

        $activities = [
            [
                'title' => 'Appointment confirmed with Dr. '.($latestAppointment->doctor->user->full_name ?? 'Unknown Doctor'),
                'time' => now()->subHours(2)->diffForHumans(),
                'type' => 'appointment',
            ],
        ];



        return Inertia::render('PatientDashboard/DashboardInteractive', [
            'healthOverview' => $healthOverview,
            'upcomingAppointments' => $upcomingAppointments,
            'latestPrescriptionCount' => $latestPrescriptionCount,
            'pendingTests' => $pendingTests,
            'nextAppointment' => $nextAppointment,
            'recentRecords' => $recentRecords,
            'activities' => $activities,
        ]);
    }
}
