<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\MedicalAttachment;
use App\Traits\AvatarResolver;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;

class DashboardController extends Controller
{
    use AvatarResolver;

    /**
     * Display the Doctor Dashboard
     */
    public function index(Request $request)
    {
        // ---------------------------------------------------------
        // 1. DOCTOR PROFILE
        // ---------------------------------------------------------
        $user = $request->user()->load('clinic');
        $firstName = explode(' ', $user->full_name)[0] ?? 'Doctor';

        $doctorProfile = [
            'id' => $user->id,
            'name' => 'Dr. '.$firstName,
            'fullName' => $user->full_name,
            'handle' => '@'.strtolower($firstName).$user->id,
            'avatar' => $this->resolveAvatarUrl(
                $user->avatar,
                $user->full_name ?? 'Doctor',
                '14B8A6'
            ),
            'clinic' => $user->clinic ? [
                'name' => $user->clinic->clinic_name ?? 'NetHealth Clinic',
                'address' => $user->clinic->clinic_address ?? 'Address not set',
            ] : null,
        ];

        // ---------------------------------------------------------
        // 2. KPI STATS
        // TODO: Replace with ->count() queries from DB ---> **Done**
        // ---------------------------------------------------------
        $stats = [
            'upcomingAppointments' => Appointment::where('doctor_id', $user->id)->where('appointment_status', 'scheduled')->count(),
            'pendingTestReviews' => MedicalAttachment::where('test_result_status', 'pending')
                ->whereHas('medicalRecord', function ($query) use ($user) {
                    $query->where('doctor_id', $user->id);
                })
                ->count(),
            'totalPatients' => Appointment::where('doctor_id', $user->id)
                ->distinct('patient_id')
                ->count(),
            'completedThisWeek' => Appointment::where('doctor_id', $user->id)->where('appointment_status', 'completed')->count(),
        ];

        // ---------------------------------------------------------
        // 3. TODAY's SCHEDULE
        // TODO: Replace with DB query ---> **Done**
        // ---------------------------------------------------------
        $todayRaw = Appointment::with('patient.user')
            ->where('doctor_id', $user->id)
            ->whereDate('appointment_time', Carbon::today())
            ->orderBy('appointment_time', 'asc')
            ->get();
        $todaySchedule = $todayRaw->map(function ($apt) {
            $patientName = $apt->patient->user->full_name ?? 'Unknown Patient';
            $avatar = $apt->patient?->user?->avatar;

            return [
                'id' => $apt->id,
                'patientName' => $patientName,
                'appointmentType' => ucwords(str_replace('_', ' ', $apt->appointment_type ?? 'Consultation')),
                'description' => $apt->visit_reason ?? 'General Consultation',
                'time' => $apt->appointment_time->format('h:i A'),
                'status' => ucfirst($apt->appointment_status ?? 'Waiting'), // 'Waiting' | 'Confirmed' | 'Completed'
                'avatar' => $avatar ?? $this->resolveAvatarUrl(
                    $apt->patient?->user?->avatar,
                    $apt->patient?->user?->full_name ?? 'Patient',
                    '14B8A6'),
            ];
        });

        // ---------------------------------------------------------
        // 4. UPCOMING APPOINTMENTS (Future)
        // TODO: Replace with DB query ---> **Done**
        // ---------------------------------------------------------
        $upcomingRaw = Appointment::with(['patient.user'])
            ->where('doctor_id', $user->id)
            ->whereDate('appointment_time', '>', Carbon::today())
            ->orderBy('appointment_time', 'asc')
            ->take(5) // Limit to next 5 for the dashboard
            ->get();

        $upcomingAppointments = $upcomingRaw->map(function ($apt) {
            $name = $apt->patient?->user?->full_name ?? 'Unknown Patient';
            // Generate initials safely
            $initials = collect(explode(' ', $name))->map(fn ($n) => substr($n, 0, 1))->take(2)->implode('');

            return [
                'id' => $apt->id,
                'initials' => strtoupper($initials),
                'name' => $name,
                'type' => ucwords(str_replace('_', ' ', $apt->appointment_type?->value ?? 'Consultation')),                'date' => $apt->appointment_time->format('M d'),
                'time' => $apt->appointment_time->format('h:i A'),
                'status' => ucfirst($apt->appointment_status?->value ?? 'Confirmed'),
            ];
        });

        // ---------------------------------------------------------
        // 5. PENDING REVIEWS (Labs/Imaging)
        // TODO: Replace with DB query  ---> **Done**
        // ---------------------------------------------------------
        $pendingReviewsRaw = MedicalAttachment::with(['medicalRecord.patient.user'])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                // Filter to only records belonging to this specific doctor
                $query->where('doctor_id', $user->id);
            })
            ->where('test_result_status', 'pending')
            ->orderBy('uploaded_at', 'desc')
            ->take(5)
            ->get();

        $pendingReviews = $pendingReviewsRaw->map(function ($attachment) {
            // Determine if it's Imaging or Lab based on the Enum
            $isImaging = $attachment->attachment_type?->value === 'imaging';

            return [
                'id' => $attachment->id,
                'reportType' => $attachment->attachment_name ?? 'Medical Report',
                'patientName' => $attachment->medicalRecord->patient?->user?->full_name ?? 'Unknown Patient',
                'category' => $isImaging ? 'Imaging' : 'Lab Test',
                'timeAgo' => $attachment->uploaded_at->diffForHumans(),
            ];
        });

        // ---------------------------------------------------------
        // 6. RECENT PATIENTS
        // TODO: Replace with DB query  ---> **Done**
        // ---------------------------------------------------------
        $recentRaw = Appointment::with('patient.user')
            ->where('doctor_id', $user->id)
            ->where('appointment_time', '<', Carbon::today())
            ->orderBy('appointment_time', 'desc')
            ->get()
            ->unique('patient_id')
            ->take(5);

        $recentPatients = $recentRaw->map(function ($apt) {
            $avatar = $apt->patient?->user?->avatar;

            return [
                'id' => $apt->patient_id,
                'name' => $apt->patient?->user?->full_name ?? 'Unknown Patient',
                'lastVisit' => $apt->appointment_time->format('M d, Y'),
                'note' => $apt->visit_reason ?? 'Previous Follow-up',
                'avatar' => $avatar,
            ];
        })->values(); // re-index the array after unique()

        // ---------------------------------------------------------
        // 7. DOCTOR'S SCHEDULE SETTINGS
        // TODO: Fetch from a 'doctor_settings' JSON column or relationship
        // Example: $schedule = $user->settings->schedule ?? $defaultSchedule;
        // ---------------------------------------------------------
        $schedule = [
            'days' => [
                ['name' => 'Monday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
                ['name' => 'Tuesday',   'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
                ['name' => 'Wednesday', 'enabled' => false, 'from' => '',         'to' => ''],
                ['name' => 'Thursday',  'enabled' => true,  'from' => '09:00 AM', 'to' => '05:00 PM'],
                ['name' => 'Friday',    'enabled' => true,  'from' => '09:00 AM', 'to' => '02:00 PM'],
                ['name' => 'Saturday',  'enabled' => false, 'from' => '',         'to' => ''],
                ['name' => 'Sunday',    'enabled' => false, 'from' => '',         'to' => ''],
            ],
            'duration' => '30 min',
            'breakBetweenSlots' => '5 min',
            'selectedPreset' => null,
            'appointmentTypes' => [
                'inClinic' => true,
                'followUp' => true,
                'labReview' => true,
            ],
            'labReviewOptions' => [
                'acceptLabTests' => true,
                'acceptXrayImages' => true,
            ],
        ];

        // ---------------------------------------------------------
        // 8. RETURN TO INERTIA
        // ---------------------------------------------------------
        $pagedata = [
            'doctor' => $doctorProfile,
            'stats' => $stats,
            'todaySchedule' => $todaySchedule,
            'upcomingAppointments' => $upcomingAppointments,
            'pendingReviews' => $pendingReviews,
            'recentPatients' => $recentPatients,
            'schedule' => $schedule,
        ];

        // dd($pagedata);

        return Inertia::render('DoctorDashboard/Index', $pagedata);
    }
}
