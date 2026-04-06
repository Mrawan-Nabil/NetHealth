<?php

namespace App\Http\Controllers\Patient;

use App\Enums\AppointmentStatus;
use App\Enums\AppointmentType;
use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\Doctor;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Validation\Rules\Enum;
use Inertia\Inertia;

class AppointmentController extends Controller
{
    /**
     * Display the user's appointments (Scheduled, Completed, Cancelled)
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
                'doctorName' => 'Dr. '.($apt->doctor?->user?->full_name ?? 'Unknown Doctor'),
                'doctorAvatar' => $apt->doctor?->user?->avatar
                    ? asset('storage/'.$apt->doctor->user->avatar)
                    : 'https://ui-avatars.com/api/?name='.urlencode($apt->doctor?->user?->full_name ?? 'Doctor').'&background=0F172A&color=fff',
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

        // 1. Fetch all active doctors with their associated users and clinics (via appointments for now, or direct clinic relation if you have one)
        $rawDoctors = Doctor::with(['user', 'appointments.clinic'])->get();

        // Extract unique specialties from the doctors table
        $uniqueSpecialties = $rawDoctors->pluck('specialty')->filter()->unique()->values();

        // Map specialties into the format the UI expects (with fallback icons)
        $specialties = $uniqueSpecialties->map(function ($spec, $index) {
            return [
                'id' => 'spec_'.$index,
                'name' => $spec,
                // A generic medical cross SVG as a fallback icon
                'icon' => '<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>',
            ];
        });

        // Map doctors for the DoctorCard component
        $doctors = $rawDoctors->map(function ($doc) use ($uniqueSpecialties) {

            // Find the specialty ID we generated above to link them
            $specialtyId = 'spec_'.$uniqueSpecialties->search($doc->specialty);

            // Find a clinic associated with this doctor (Assuming they have appointments at a clinic)
            // If you have a direct Doctor -> Clinic relationship, use that instead!
            $clinicName = $doc->appointments->first()?->clinic?->clinic_name ?? 'NetHealth Virtual Clinic';

            return [
                'id' => $doc->user_id,
                'name' => 'Dr. '.($doc->user?->full_name ?? 'Unknown'),
                'avatar' => $doc->user?->avatar
                    ? asset('storage/'.$doc->user->avatar)
                    : 'https://ui-avatars.com/api/?name='.urlencode($doc->user?->full_name ?? 'Doctor').'&background=14B8A6&color=fff',
                'specialty' => $doc->specialty ?? 'General Practice',
                'specialtyId' => $specialtyId,
                'hospital' => $clinicName,
                'rating' => '4.'.rand(5, 9), // Placeholder rating since it's not in DB
                'reviews' => rand(80, 300),    // Placeholder reviews
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

        // Fetch the specific doctor and their relationships
        $doc = Doctor::with(['user', 'appointments.clinic'])->findOrFail($id);

        $clinicName = $doc->appointments->first()?->clinic?->clinic_name ?? 'NetHealth Virtual Clinic';

        // Format the doctor data exactly as DoctorProfile.vue expects
        $doctorProfile = [
            'id' => $doc->user_id,
            'name' => 'Dr. '.($doc->user?->full_name ?? 'Unknown'),
            'avatar' => $doc->user?->avatar
                ? asset('storage/'.$doc->user->avatar)
                : 'https://ui-avatars.com/api/?name='.urlencode($doc->user?->full_name ?? 'Doctor').'&background=14B8A6&color=fff',
            'specialty' => $doc->specialty ?? 'General Practice',
            'hospital' => $clinicName,
            'rating' => '4.'.rand(5, 9), // Placeholder
            'reviews' => rand(80, 300),    // Placeholder
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
        // 1. Validate the incoming data from Vue
        $validated = $request->validate([
            'doctor_id' => 'required|exists:doctors,user_id',
            'appointment_time' => 'required|date',
            'appointment_type' => ['required', new Enum(AppointmentType::class)],
            'notes' => 'nullable|string',
        ]);

        $user = $request->user()->load('patient');

        // 2. Find the doctor's clinic (so we know where the appointment is)
        $doctor = Doctor::with('appointments.clinic')->findOrFail($validated['doctor_id']);
        $clinicId = $doctor->appointments->first()?->clinic_id;

        // 3. Create the appointment
        $appointment = Appointment::create([
            'patient_id' => $user->patient->user_id,
            'doctor_id' => $validated['doctor_id'],
            'clinic_id' => $clinicId, // Can be null if it's an online visit
            'appointment_time' => Carbon::parse($validated['appointment_time']),
            'appointment_status' => AppointmentStatus::Scheduled->value, // Assuming you have this enum
            'appointment_type' => $validated['appointment_type'],
            'visit_reason' => $validated['notes'],
        ]);

        // (Optional: Handle file uploads here if the patient attached files)

        // 4. Redirect back so Vue knows it was successful
        return redirect()->back()->with('success', 'Appointment booked successfully!');
    }
}
