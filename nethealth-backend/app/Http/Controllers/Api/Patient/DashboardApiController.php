<?php

namespace App\Http\Controllers\Api\Patient;

use App\Http\Controllers\Api\ApiController;
use App\Http\Resources\Api\DashboardResource;
use App\Models\Appointment;
use App\Models\MedicalAttachment;
use App\Models\MedicalRecord;
use App\Models\Prescription;
use Illuminate\Http\Request;

class DashboardApiController extends ApiController
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found. Please complete your setup.', 404);
        }

        $patientId = $user->patient->user_id;

        // 1. Calculate Stats
        $upcomingAppointments = Appointment::where('patient_id', $patientId)
            ->where('appointment_status', 'scheduled')
            ->where('appointment_time', '>=', now())
            ->count();

        $activePrescriptions = Prescription::whereHas('medicalRecord', function ($query) use ($patientId) {
            $query->where('patient_id', $patientId);
        })
            ->whereIn('prescription_status', ['pending', 'issued'])
            ->count();

        $pendingTests = MedicalAttachment::whereHas('medicalRecord', function ($query) use ($patientId) {
            $query->where('patient_id', $patientId);
        })
            ->whereIn('attachment_type', ['lab_result', 'imaging'])
            ->where('test_result_status', 'pending')
            ->count();

        // 2. Fetch Next Appointment (Closest in the future)
        $nextAppointment = Appointment::with(['doctor.user', 'clinic'])
            ->where('patient_id', $patientId)
            ->where('appointment_status', 'scheduled')
            ->where('appointment_time', '>=', now())
            ->orderBy('appointment_time', 'asc')
            ->first();

        // 3. Fetch Recent Records (Last 3)
        $recentRecords = MedicalRecord::with(['doctor.user', 'appointment'])
            ->where('patient_id', $patientId)
            ->orderBy('created_at', 'desc')
            ->take(3)
            ->get();

        // 4. Infer Primary Doctor (from the most recent medical record)
        $primaryDoctor = $recentRecords->first() ? $recentRecords->first()->doctor : null;

        // Combine into a data transfer array
        $dashboardData = [
            'patient' => $user->patient,
            'primary_doctor' => $primaryDoctor,
            'stats' => [
                'upcoming_appointments' => $upcomingAppointments,
                'active_prescriptions' => $activePrescriptions,
                'pending_tests' => $pendingTests,
            ],
            'next_appointment' => $nextAppointment,
            'recent_records' => $recentRecords,
        ];

        return $this->successResponse(
            new DashboardResource((object) $dashboardData),
            'Dashboard loaded successfully.'
        );
    }
}
