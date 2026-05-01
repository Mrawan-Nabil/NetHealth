<?php

namespace App\Http\Controllers\Api\Patient;

use App\Http\Controllers\Api\ApiController;
use App\Models\Appointment;
use Illuminate\Http\Request;

class PatientVisitHistoryApiController extends ApiController
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $appointments = Appointment::with(['doctor.user', 'clinic'])
            ->where('patient_id', $user->patient->user_id)
            ->orderBy('appointment_time', 'desc')
            ->get();

        $visits = $appointments->map(function ($appointment) {
            $doctorName = $appointment->doctor?->user?->full_name ?? 'Unknown';

            // Compute initials (max 2 chars)
            $nameParts = explode(' ', trim($doctorName));
            $initials  = strtoupper(substr($nameParts[0], 0, 1));
            if (isset($nameParts[1])) {
                $initials .= strtoupper(substr($nameParts[1], 0, 1));
            }

            // Derive appointment type display value
            $visitType = ucwords(str_replace('_', ' ', $appointment->appointment_type->value ?? 'consultation'));

            // Derive appointment status display value
            $status = strtolower($appointment->appointment_status->value ?? 'scheduled');

            return [
                'id'           => $appointment->id,
                'doctor_name'  => 'Dr. ' . $doctorName,
                'doctor_initials' => $initials,
                'specialty'    => $appointment->doctor?->specialty ?? 'General Practice',
                'clinic'       => $appointment->clinic?->clinic_name ?? 'NetHealth Virtual Clinic',
                'visit_type'   => $visitType,
                'date'         => $appointment->appointment_time
                    ? $appointment->appointment_time->format('M d, Y')
                    : 'N/A',
                'time'         => $appointment->appointment_time
                    ? $appointment->appointment_time->format('h:i A')
                    : 'N/A',
                'appointment_status' => $status,
                'appointment_type'   => $appointment->appointment_type->value ?? 'physical',
            ];
        });

        return response()->json([
            'status'  => 'success',
            'message' => 'Visit history loaded.',
            'data'    => $visits->values()->all(),
            'meta'    => [
                'current_page' => 1,
                'last_page'    => 1,
                'per_page'     => $visits->count(),
                'total'        => $visits->count(),
            ],
        ]);
    }
}
