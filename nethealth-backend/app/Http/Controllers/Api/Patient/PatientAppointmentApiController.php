<?php

namespace App\Http\Controllers\Api\Patient;

use App\Http\Controllers\Api\ApiController;
use Carbon\Carbon;
use Illuminate\Http\Request;

class PatientAppointmentApiController extends ApiController
{
    public function index(Request $request)
    {
        $patient = $request->user()->patient;

        if (! $patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $appointments = $patient->appointments()
            ->with(['doctor.user', 'clinic'])
            ->orderBy('appointment_time', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => 'success',
            'message' => 'Appointments retrieved successfully.',
            'data' => $appointments->items(),
            'meta' => [
                'current_page' => $appointments->currentPage(),
                'last_page' => $appointments->lastPage(),
                'per_page' => $appointments->perPage(),
                'total' => $appointments->total(),
            ],
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'doctor_id'       => 'required|exists:users,id',
            'clinic_id'       => 'required|exists:clinics,id',
            'appointment_time' => 'required|date',
            'appointment_type' => 'required|string',
            'visit_reason'    => 'nullable|string',
            'patient_name'    => 'nullable|string|max:255',
            'patient_phone'   => 'nullable|string|max:50',
            'patient_email'   => 'nullable|email|max:255',
        ]);

        $appointment = $request->user()->patient->appointments()->create([
            'doctor_id'          => $request->doctor_id,
            'clinic_id'          => $request->clinic_id,
            'appointment_time'   => Carbon::parse($request->appointment_time),
            'appointment_status' => 'scheduled',
            'appointment_type'   => $request->appointment_type,
            'visit_reason'       => $request->visit_reason,
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Appointment booked successfully',
            'data'    => $appointment,
        ]);
    }

    /**
     * Cancel the specified appointment.
     */
    public function destroy(Request $request, $id)
    {
        $patient = $request->user()->patient;

        if (! $patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $appointment = $patient->appointments()->find($id);

        if (! $appointment) {
            return $this->errorResponse('Appointment not found or unauthorized.', 404);
        }

        // Only allow cancelling scheduled appointments
        if ($appointment->appointment_status !== \App\Enums\AppointmentStatus::Scheduled) {
            return $this->errorResponse('Only scheduled appointments can be cancelled.', 422);
        }

        $appointment->update([
            'appointment_status' => \App\Enums\AppointmentStatus::Cancelled,
            'cancelled_by' => 'patient',
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Appointment cancelled successfully.',
        ]);
    }
}
