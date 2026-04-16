<?php

namespace App\Http\Controllers\Api\Patient;

use App\Enums\AppointmentStatus;
use App\Http\Controllers\Api\ApiController;
use App\Models\Appointment;
use Illuminate\Http\Request;

class PatientAppointmentApiController extends ApiController
{
    // ─────────────────────────────────────────────────────────────────────────
    // GET /v1/patient/appointments
    // ─────────────────────────────────────────────────────────────────────────

    public function index(Request $request)
    {
        $patient = $request->user()->patient;

        if (!$patient) {
            return $this->errorResponse('Patient profile not found.', null, 404);
        }

        $appointments = $patient->appointments()
            ->with(['doctor.user', 'clinic'])
            ->orderBy('appointment_time', 'desc')
            ->paginate($request->get('per_page', 15));

        // Map to a clean shape the Flutter client expects
        $mapped = $appointments->getCollection()->map(function (Appointment $appt) {
            $doctor = $appt->doctor;
            $user   = $doctor?->user;

            return [
                'id'                  => $appt->id,
                'appointment_time'    => $appt->appointment_time?->toIso8601String(),
                'appointment_status'  => $appt->appointment_status?->value,
                'appointment_type'    => $appt->appointment_type?->value,
                'visit_reason'        => $appt->visit_reason,
                'cancelled_by'        => $appt->cancelled_by,
                'cancellation_reason' => $appt->cancellation_reason,
                'doctor' => $user ? [
                    'id'                 => $user->id,
                    'full_name'          => $user->full_name,
                    'specialty'          => $doctor->specialty ?? '',
                    'professional_title' => $doctor->professional_title ?? 'dr',
                    'avatar_url'         => $user->avatar_url ?? null,
                    'consultation_fee'   => $doctor->consultation_fee ?? null,
                    'clinic_name'        => $appt->clinic?->clinic_name ?? null,
                ] : null,
                'clinic' => $appt->clinic ? [
                    'id'          => $appt->clinic->id,
                    'clinic_name' => $appt->clinic->clinic_name,
                    'address'     => $appt->clinic->address ?? null,
                ] : null,
            ];
        });

        $appointments->setCollection($mapped);

        return response()->json([
            'status'  => 'success',
            'message' => 'Appointments retrieved successfully.',
            'data'    => $appointments->items(),
            'meta'    => [
                'current_page' => $appointments->currentPage(),
                'last_page'    => $appointments->lastPage(),
                'per_page'     => $appointments->perPage(),
                'total'        => $appointments->total(),
            ],
        ]);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST /v1/patient/appointments
    // ─────────────────────────────────────────────────────────────────────────

    public function store(Request $request)
    {
        $patient = $request->user()->patient;

        if (!$patient) {
            return $this->errorResponse('Patient profile not found.', null, 404);
        }

        $validated = $request->validate([
            'doctor_id'        => 'required|integer|exists:users,id',
            'appointment_time' => 'required|date|after:now',
            'visit_reason'     => 'required|string|max:1000',
            'appointment_type' => 'nullable|in:in_person,virtual',
            'clinic_id'        => 'nullable|integer|exists:clinics,id',
        ]);

        $appointment = Appointment::create([
            'patient_id'         => $patient->user_id,
            'doctor_id'          => $validated['doctor_id'],
            'appointment_time'   => $validated['appointment_time'],
            'visit_reason'       => $validated['visit_reason'],
            'appointment_type'   => $validated['appointment_type'] ?? 'in_person',
            'appointment_status' => AppointmentStatus::Scheduled,
            'clinic_id'          => $validated['clinic_id'] ?? null,
        ]);

        $appointment->load(['doctor.user', 'clinic']);
        $doctor = $appointment->doctor;
        $user   = $doctor?->user;

        $data = [
            'id'                  => $appointment->id,
            'appointment_time'    => $appointment->appointment_time?->toIso8601String(),
            'appointment_status'  => $appointment->appointment_status?->value,
            'appointment_type'    => $appointment->appointment_type?->value,
            'visit_reason'        => $appointment->visit_reason,
            'cancelled_by'        => null,
            'cancellation_reason' => null,
            'doctor' => $user ? [
                'id'                 => $user->id,
                'full_name'          => $user->full_name,
                'specialty'          => $doctor->specialty ?? '',
                'professional_title' => $doctor->professional_title ?? 'dr',
                'avatar_url'         => $user->avatar_url ?? null,
            ] : null,
            'clinic' => $appointment->clinic ? [
                'id'          => $appointment->clinic->id,
                'clinic_name' => $appointment->clinic->clinic_name,
            ] : null,
        ];

        return $this->successResponse($data, 'Appointment booked successfully.', 201);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // DELETE /v1/patient/appointments/{id}
    // ─────────────────────────────────────────────────────────────────────────

    public function destroy(Request $request, int $id)
    {
        $patient = $request->user()->patient;

        if (!$patient) {
            return $this->errorResponse('Patient profile not found.', null, 404);
        }

        // Scope to this patient's appointments only — prevents deleting others'
        $appointment = Appointment::where('id', $id)
            ->where('patient_id', $patient->user_id)
            ->first();

        if (!$appointment) {
            return $this->errorResponse('Appointment not found or does not belong to you.', null, 404);
        }

        if ($appointment->appointment_status === AppointmentStatus::Completed) {
            return $this->errorResponse('Completed appointments cannot be cancelled.', null, 422);
        }

        $appointment->update([
            'appointment_status' => AppointmentStatus::Cancelled,
            'cancelled_by'       => 'patient',
        ]);

        return $this->successResponse(null, 'Appointment cancelled successfully.');
    }
}
