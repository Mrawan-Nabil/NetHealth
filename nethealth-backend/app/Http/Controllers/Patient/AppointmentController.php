<?php

namespace App\Http\Controllers\Patient;

use App\Enums\AppointmentStatus;
use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\Doctor;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;

class AppointmentController extends Controller
{
    private function resolveAvatarUrl(?string $avatar, string $name, string $background = '0D9488'): string
    {
        $fallback = 'https://ui-avatars.com/api/?name='.urlencode($name).'&background='.$background.'&color=fff';

        if (! $avatar) {
            return $fallback;
        }

        if (str_starts_with($avatar, 'http://') || str_starts_with($avatar, 'https://')) {
            if (str_contains($avatar, 'via.placeholder.com') || str_contains($avatar, 'placehold.co')) {
                return $fallback;
            }

            return $avatar;
        }

        return asset('storage/'.$avatar);
    }

    /**
     * Display the user's appointments (Scheduled, Completed, Canceled)
     */
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        // Fetch all appointments for the logged-in patient
        $rawAppointments = Appointment::with(['doctor.user', 'clinic', 'medicalRecord.prescriptions', 'medicalRecord.attachments'])
            ->where('patient_id', $user->patient->user_id)
            ->orderBy('appointment_time', 'desc')
            ->get();

        // Map the data exactly as the Vue cards expect it
        $appointments = $rawAppointments->map(function ($apt) {

            // Format datetime: "March 20, 2026 • 10:00 AM"
            $dateTime = $apt->appointment_time
                ? $apt->appointment_time->format('F j, Y • h:i A')
                : 'Date TBD';

            // Ensure status exactly matches the Vue filter logic ('Completed', 'Scheduled', 'Cancelled')
            $status = ucfirst(strtolower($apt->appointment_status->value ?? 'scheduled'));

            // Gather reports if any exist (For CompletedAppointmentCard)
            $reports = [];
            if ($apt->medicalRecord && $apt->medicalRecord->attachments) {
                foreach ($apt->medicalRecord->attachments as $attachment) {
                    $reports[] = ['name' => $attachment->attachment_name ?? 'Medical File'];
                }
            }

            return [
                'id' => $apt->id,
                'status' => $status,
                'doctorId' => $apt->doctor_id,
                'doctorName' => 'Dr. '.($apt->doctor?->user?->full_name ?? 'Unknown Doctor'),
                'doctorAvatar' => $this->resolveAvatarUrl(
                    $apt->doctor?->user?->avatar,
                    $apt->doctor?->user?->full_name ?? 'Doctor',
                    '0F172A'
                ),
                'specialty' => $apt->doctor?->specialty ?? 'General Practice',
                'dateTime' => $dateTime,
                'clinicAddress' => $apt->clinic?->clinic_name.' - '.$apt->clinic?->clinic_address,
                'visitType' => ucwords(str_replace('_', ' ', $apt->appointment_type->value ?? 'Consultation')),

                // Specific to CancelledAppointmentCard
                'cancelledBy' => $apt->cancelled_by ?? 'Patient', // Assuming you might add this column later, defaulting to Patient
                'reason' => 'Patient Request', // Assuming you might add a cancellation_reason column later

                // Specific to CompletedAppointmentCard
                'reports' => $reports,
            ];
        });

        return Inertia::render('PatientDashboard/Appointments', [
            'appointments' => $appointments,
            'auth' => [
                'user' => [
                    'name' => $user->full_name,
                    'email' => $user->email,
                    'avatar' => $user->avatar ? asset('storage/'.$user->avatar) : null,
                ],
            ],
        ]);
    }

    /**
     * Display the "Book a New Appointment" / Doctor Search page
     */
    public function create(Request $request)
    {
        $user = $request->user();

        // Phase 1: Eager-load the clinic directly via the User model's clinic_id FK.
        // No longer traversing appointments to guess the clinic.
        $rawDoctors = Doctor::with(['user.clinic'])->get();

        // Extract unique specialties from the doctors table
        $uniqueSpecialties = $rawDoctors->pluck('specialty')->filter()->unique()->values();

        // Map specialties into the format the UI expects (with fallback icons)
        $specialties = $uniqueSpecialties->map(function ($spec, $index) {
            return [
                'id' => 'spec_'.$index,
                'name' => $spec,
                'icon' => '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>',
            ];
        });

        // Map doctors for the DoctorCard component
        $doctors = $rawDoctors->map(function ($doc) use ($uniqueSpecialties) {

            $specialtyId = 'spec_'.$uniqueSpecialties->search($doc->specialty);

            // Phase 1: Use direct User -> Clinic relationship instead of guessing via appointments.
            $clinicName = $doc->user?->clinic?->clinic_name ?? 'NetHealth Virtual Clinic';

            return [
                'id' => $doc->user_id,
                'name' => 'Dr. '.($doc->user?->full_name ?? 'Unknown'),
                'avatar' => $this->resolveAvatarUrl(
                    $doc->user?->avatar,
                    $doc->user?->full_name ?? 'Doctor',
                    '14B8A6'
                ),
                'specialty' => $doc->specialty ?? 'General Practice',
                'specialtyId' => $specialtyId,
                'hospital' => $clinicName,
                'clinic' => $doc->user?->clinic ? [
                    'id' => $doc->user->clinic->id,
                    'name' => $doc->user->clinic->clinic_name,
                ] : null,
                'rating' => '4.'.rand(5, 9),
                'reviews' => rand(80, 300),
                'price' => '$'.($doc->consultation_fee ?? '150'),
            ];
        });

        return Inertia::render('PatientDashboard/CreateAppointment', [
            'doctors' => $doctors,
            'specialties' => $specialties,
            'auth' => [
                'user' => [
                    'name' => $user->full_name,
                    'email' => $user->email,
                    'avatar' => $user->avatar ? asset('storage/'.$user->avatar) : null,
                ],
            ],
        ]);
    }

    /**
     * Display the individual Doctor Profile / Booking Page
     */
    public function showDoctor(Request $request, string $id)
    {
        $user = $request->user();

        // Phase 1: Fetch doctor with direct User -> Clinic relationship.
        $doc = Doctor::with(['user.clinic'])->findOrFail($id);

        // Phase 1 UI: Directly use the new FK relationship.
        $clinicName = $doc->user?->clinic?->clinic_name ?? 'NetHealth Virtual Clinic';

        $doctorProfile = [
            'id' => $doc->user_id,
            'name' => 'Dr. '.($doc->user?->full_name ?? 'Unknown'),
            'avatar' => $this->resolveAvatarUrl(
                $doc->user?->avatar,
                $doc->user?->full_name ?? 'Doctor',
                '14B8A6'
            ),
            'specialty' => $doc->specialty ?? 'General Practice',
            'hospital' => $clinicName,
            // Expose the full clinic object so DoctorProfile.vue can bind doctor.clinic?.name
            'clinic' => $doc->user?->clinic ? [
                'id' => $doc->user->clinic->id,
                'name' => $doc->user->clinic->clinic_name,
                'address' => $doc->user->clinic->clinic_address,
            ] : null,
            'rating' => '4.'.rand(5, 9),
            'reviews' => rand(80, 300),
            'price' => '$'.($doc->consultation_fee ?? '100'),
        ];

        // dd($doctorProfile);
        // Make sure the Vue component name matches your actual file name!
        return Inertia::render('PatientDashboard/DoctorProfile', [
            'doctor' => $doctorProfile,
            'auth' => [
                'user' => [
                    'name' => $user->full_name,
                    'email' => $user->email,
                    'avatar' => $user->avatar ? asset('storage/'.$user->avatar) : null,
                ],
            ],
        ]);
    }

    /**
     * Store the new appointment in the database
     */
    public function store(Request $request)
    {
        // Phase 2: Validate only what the frontend should supply.
        // clinic_id is NO LONGER accepted from the request — it is resolved server-side.
        $request->validate([
            'doctor_id' => 'required|exists:users,id',
            'appointment_time' => 'required|date',
            'appointment_type' => 'nullable|string',
            'visit_reason' => 'nullable|string',
            'notes' => 'nullable|string',
        ]);

        // Phase 2 — Auto-Assignment: Resolve clinic from the doctor's User record directly.
        $doctor = User::findOrFail($request->doctor_id);

        // Phase 2 — Failsafe: Reject booking if doctor has no assigned clinic.
        if (! $doctor->clinic_id) {
            throw ValidationException::withMessages([
                'doctor_id' => 'This doctor is not assigned to a clinic. Please contact support.',
            ]);
        }

        $appointment = $request->user()->patient->appointments()->create([
            'doctor_id' => $doctor->id,
            'clinic_id' => $doctor->clinic_id,  // Authoritative — set by backend only.
            'appointment_time' => Carbon::parse($request->appointment_time),
            'appointment_status' => 'scheduled',
            'appointment_type' => $request->appointment_type ?? 'physical',
            'visit_reason' => $request->visit_reason,
            'notes' => $request->notes,
        ]);

        return redirect()->route('appointments.index')
            ->with('success', 'Appointment booked successfully!');
    }

    /**
     * Reschedule an existing appointment.
     */
    public function update(Request $request, int $id)
    {
        // 1. Validate the payload from Inertia (from RescheduleModal.vue)
        $request->validate([
            'date' => 'required|date',
            'time' => 'required|string', // e.g., "10:00 AM"
            'reason' => 'nullable|string',
        ]);

        $user = $request->user();
        $appointment = Appointment::findOrFail($id);

        // 2. Security check: Ensure the patient owns this appointment
        $ownsAppointment = (int) $appointment->patient_id === (int) $user->id
            || (int) $appointment->patient_id === (int) ($user->patient?->user_id ?? 0);

        if (! $ownsAppointment) {
            abort(403, 'You are not allowed to reschedule this appointment.');
        }

        // 3. Combine the date and time strings into a valid Carbon database timestamp
        $newAppointmentTime = Carbon::parse($request->date.' '.$request->time);

        // 4. Prepare data for update
        $updateData = [
            'appointment_time' => $newAppointmentTime,
            'appointment_status' => 'scheduled', // Reset to scheduled in case it was pending/cancelled
        ];

        // 5. If they provided a reason, append it to the appointment notes
        if ($request->filled('reason')) {
            $existingNotes = $appointment->notes ? $appointment->notes."\n\n" : '';
            $updateData['notes'] = $existingNotes.'Reschedule Reason: '.$request->reason;
        }

        // 6. Save to database
        $appointment->update($updateData);

        // 7. Return Inertia response
        return back()->with('success', 'Appointment rescheduled successfully to '.$newAppointmentTime->format('M j, Y h:i A'));
    }

    /**
     * Cancel appointment for current patient.
     */
    public function destroy(Request $request, int $id)
    {
        $user = $request->user();
        $appointment = Appointment::findOrFail($id);

        $ownsAppointment = (int) $appointment->patient_id === (int) $user->id
            || (int) $appointment->patient_id === (int) ($user->patient?->user_id ?? 0);

        if (! $ownsAppointment) {
            abort(403, 'You are not allowed to cancel this appointment.');
        }

        if ($appointment->appointment_status === AppointmentStatus::Cancelled) {
            return back()->with('info', 'Appointment is already cancelled.');
        }

        $appointment->update([
            'appointment_status' => AppointmentStatus::Cancelled->value,
        ]);

        return back()->with('success', 'Appointment cancelled successfully.');
    }
}
