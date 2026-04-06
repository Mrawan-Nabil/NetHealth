<?php

namespace App\Http\Controllers\Patient;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use Illuminate\Http\Request;
use Inertia\Inertia;

class VisitHistoryController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        // Fetch all appointments for the logged-in patient
        $appointments = Appointment::with(['doctor.user', 'clinic'])
            ->where('patient_id', $user->patient->user_id)
            ->orderBy('appointment_time', 'desc')
            ->get();

        // Map the database models to the exact shape VisitHistoryCard.vue expects
        $visits = $appointments->map(function ($appointment) {

            $doctorName = $appointment->doctor?->user?->full_name ?? 'Unknown';

            // Extract Initials (e.g., "Mohamed Barakat" -> "MB")
            $nameParts = explode(' ', trim($doctorName));
            $initials = strtoupper(substr($nameParts[0], 0, 1));
            if (isset($nameParts[1])) {
                $initials .= strtoupper(substr($nameParts[1], 0, 1));
            }

            // Generate consistent aesthetic colors based on the doctor's ID
            $colorThemes = [
                ['bg' => '#CCFBF1', 'text' => '#0F766E'], // Teal
                ['bg' => '#DBEAFE', 'text' => '#1D4ED8'], // Blue
                ['bg' => '#F3E8FF', 'text' => '#6D28D9'], // Purple
                ['bg' => '#FEF3C7', 'text' => '#B45309'], // Amber
            ];
            $theme = $colorThemes[($appointment->doctor_id ?? 0) % count($colorThemes)];

            // Ensure status exactly matches the UI's expected casing (Completed, Upcoming, Cancelled)
            $status = ucfirst(strtolower($appointment->appointment_status->value));

            return [
                'id' => $appointment->id,
                'doctorName' => 'Dr. '.$doctorName,
                'doctorInitials' => $initials,
                'specialty' => $appointment->doctor?->specialty ?? 'General Practice',
                'clinic' => $appointment->clinic?->clinic_name ?? 'NetHealth Virtual Clinic',
                'visitType' => ucwords(str_replace('_', ' ', $appointment->appointment_type->value ?? 'Consultation')),
                'date' => $appointment->appointment_time ? $appointment->appointment_time->format('M d, Y') : 'N/A',
                'time' => $appointment->appointment_time ? $appointment->appointment_time->format('h:i A') : 'N/A',
                'status' => $status,
                'avatarBg' => $theme['bg'],
                'avatarColor' => $theme['text'],
            ];
        });

        return Inertia::render('PatientDashboard/VisitHistory', [
            'visits' => $visits,
            'auth' => [
                'user' => [
                    'name' => $user->full_name,
                    'email' => $user->email,
                    'avatar' => $user->avatar ? '/storage/'.$user->avatar : null,
                ],
            ],
        ]);
    }
}
