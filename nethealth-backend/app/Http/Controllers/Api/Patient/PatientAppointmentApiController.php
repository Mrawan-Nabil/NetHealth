<?php

namespace App\Http\Controllers\Api\Patient;

use App\Http\Controllers\Api\ApiController;
use Illuminate\Http\Request;

class PatientAppointmentApiController extends ApiController
{
    public function index(Request $request)
    {
        $patient = $request->user()->patient;

        if (!$patient) {
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
            ]
        ]);
    }

    /**
     * Cancel the specified appointment.
     */
    public function destroy(Request $request, $id)
    {
        $patient = $request->user()->patient;

        if (!$patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $appointment = $patient->appointments()->find($id);

        if (!$appointment) {
            return $this->errorResponse('Appointment not found or unauthorized.', 404);
        }

        // Only allow cancelling scheduled appointments
        if ($appointment->appointment_status !== \App\Enums\AppointmentStatus::Scheduled) {
            return $this->errorResponse('Only scheduled appointments can be cancelled.', 422);
        }

        $appointment->update([
            'appointment_status' => \App\Enums\AppointmentStatus::Cancelled,
            'cancelled_by' => 'patient'
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Appointment cancelled successfully.'
        ]);
    }
}
