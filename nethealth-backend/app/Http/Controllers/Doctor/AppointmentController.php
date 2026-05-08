<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Traits\AvatarResolver;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AppointmentController extends Controller
{
    use AvatarResolver;

    /**
     * Display the Doctor's Appointments Manager.
     */
    public function index(Request $request)
    {
        $user = $request->user()->load('clinic');
        $doctorId = $user->id;

        // 1. Construct Doctor Profile Prop
        $firstName = explode(' ', $user->full_name)[0] ?? 'Doctor';
        $doctorProfile = [
            'id' => $user->id,
            'name' => 'Dr. '.$firstName,
            'fullName' => $user->full_name,
            'handle' => '@'.($user->username ?? strtolower($firstName).$user->id),
            'avatar' => $this->resolveAvatarUrl($user->avatar, $user->full_name ?? 'Doctor', '14B8A6'),
        ];

        // 2. Fetch all appointments for this doctor with eager loading
        // We fetch them all at once, then filter using Laravel Collections for performance
        $allAppointments = Appointment::with(['patient.user'])
            ->where('doctor_id', $doctorId)
            ->get();

        // --- COMPLETED APPOINTMENTS ---
        $completedAppointments = $allAppointments
            ->filter(fn ($apt) => $apt->appointment_status?->value === 'completed')
            ->sortByDesc('appointment_time')
            ->values()
            ->map(function ($apt) {
                $name = $apt->patient?->user?->full_name ?? 'Unknown Patient';
                $initials = collect(explode(' ', $name))->map(fn ($n) => substr($n, 0, 1))->take(2)->implode('');

                return [
                    'id' => $apt->id,
                    'patientName' => $name,
                    'initials' => strtoupper($initials),
                    'date' => $apt->appointment_time->format('M d, Y'),
                    'time' => $apt->appointment_time->format('h:i A'),
                    'visitType' => ucwords(str_replace('_', ' ', $apt->appointment_type?->value ?? 'Consultation')),
                    'canEdit' => true, // Adjust this logic if there is a time limit on edits
                ];
            });

        // --- UPCOMING APPOINTMENTS ---
        $upcomingAppointments = $allAppointments
            ->filter(function ($apt) {
                $status = $apt->appointment_status?->value;

                // Treat 'scheduled' as upcoming if it's in the future (or today)
                return $status === 'scheduled' && $apt->appointment_time >= Carbon::today();
            })
            ->sortBy('appointment_time') // Ascending order so nearest is first
            ->values()
            ->map(function ($apt) {
                $name = $apt->patient?->user?->full_name ?? 'Unknown Patient';
                $initials = collect(explode(' ', $name))->map(fn ($n) => substr($n, 0, 1))->take(2)->implode('');

                return [
                    'id' => $apt->id,
                    'patientName' => $name,
                    'initials' => strtoupper($initials),
                    'visitType' => ucwords(str_replace('_', ' ', $apt->appointment_type?->value ?? 'Consultation')),
                    'date' => $apt->appointment_time->format('M d, Y'),
                    'time' => $apt->appointment_time->format('h:i A'),
                    'status' => 'Confirmed', // Or dynamically check if you have a 'pending' state
                    'action' => 'View Details',
                ];
            });

        // --- CANCELLED APPOINTMENTS ---
        $cancelledAppointments = $allAppointments
            ->filter(fn ($apt) => $apt->appointment_status?->value === 'cancelled')
            ->sortByDesc('appointment_time')
            ->values()
            ->map(function ($apt) {
                $name = $apt->patient?->user?->full_name ?? 'Unknown Patient';
                $initials = collect(explode(' ', $name))->map(fn ($n) => substr($n, 0, 1))->take(2)->implode('');

                return [
                    'id' => $apt->id,
                    'patientName' => $name,
                    'initials' => strtoupper($initials),
                    'date' => $apt->appointment_time->format('M d, Y'),
                    'time' => $apt->appointment_time->format('h:i A'),
                    // Fallback notes if your DB doesn't have these columns yet
                    'cancelledNote' => $apt->notes ?? 'Appointment was cancelled.',
                    'reason' => $apt->visit_reason ?? 'No reason provided',
                ];
            });

        // 3. Return the data to Inertia
        return Inertia::render('DoctorDashboard/Appointments', [
            'doctor' => $doctorProfile,
            'completedAppointments' => $completedAppointments,
            'upcomingAppointments' => $upcomingAppointments,
            'cancelledAppointments' => $cancelledAppointments,
        ]);
    }
}
