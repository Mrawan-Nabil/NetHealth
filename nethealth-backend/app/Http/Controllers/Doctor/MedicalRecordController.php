<?php

/** @noinspection DuplicatedCode */

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\MedicalAttachment;
use App\Models\Patient;
use App\Models\Prescription;
use App\Traits\AvatarResolver;
use App\Traits\DoctorPropBuilder;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;

class MedicalRecordController extends Controller
{
    use AvatarResolver, DoctorPropBuilder;

    /**
     * Display the comprehensive medical record for a specific patient.
     */
    public function show(Request $request)
    {
        $user = $request->user();

        // 1. Validate the patient ID from the query string (?patient=X)
        $patientId = $request->query('patient');
        if (! $patientId) {
            abort(404, 'Patient ID is required.');
        }

        // 2. Doctor Profile
        $doctorProfile = $this->buildDoctorProp($user);

        // 3. Fetch Patient Core Data
        $patientModel = Patient::with(['user', 'medicalRecords' => function ($query) use ($user) {
            // This ensures the doctor only loads THEIR specific records for this patient
            $query->where('doctor_id', $user->id)->with('doctor.user');
        }])
            ->whereHas('medicalRecords', function ($query) use ($user) {
                // This ensures we only fetch the patient if they are actually assigned to this doctor
                $query->where('doctor_id', $user->id);
            })
            ->where('user_id', $patientId)
            ->firstOrFail();

        $patientName = $patientModel->user->full_name ?? 'Unknown Patient';

        $initials = collect(explode(' ', $patientName))->map(fn ($n) => substr($n, 0, 1))->take(2)->implode('');

        $patientData = [
            'name' => $patientName,
            'initials' => strtoupper($initials),
            'id' => 'PT-'.str_pad($patientModel->user_id, 5, '0', STR_PAD_LEFT),
            'dob' => $patientModel->user->birth_date ? Carbon::parse($patientModel->user->birth_date)->format('F d, Y') : 'Unknown',
            'email' => $patientModel->user->email ?? 'No email provided',
            'gender' => ucfirst($patientModel->user->gender?->value ?? $patientModel->user->gender ?? 'Unspecified'),
            'age' => (string) ($patientModel->user->birth_date ? Carbon::parse($patientModel->user->birth_date)->age : 'N/A'),
            'phone' => $patientModel->user->phone ?? 'No phone provided',
            'bloodType' => $patientModel->blood_type ?? 'Unknown',
            'notes' => \App\Models\MedicalRecord::where('patient_id', $patientId)
                ->where('doctor_id', $user->id) // SECURITY: Only this doctor's notes
                ->whereNotNull('diagnosis_notes')
                ->where('diagnosis_notes', '!=', '')
                ->orderBy('created_at', 'desc')
                ->get()
                ->map(fn ($record) => [
                    'id' => $record->id,
                    'doctor_id' => $record->doctor_id,
                    'patient_id' => $record->patient_id,
                    'text' => $record->diagnosis_notes,
                    'date' => $record->created_at ? $record->created_at->format('M d, Y - h:i A') : 'Date not recorded',
                ])->toArray(),   ];

        // dd($patientData['notes']);

        // 4. Fetch All Attachments (Labs & Imaging)
        // We fetch them all at once via MedicalRecord to minimize queries
        $attachments = MedicalAttachment::with('medicalRecord.doctor.user')
            ->whereHas('medicalRecord', function ($query) use ($patientId) {
                $query->where('patient_id', $patientId);
            })
            ->orderBy('uploaded_at', 'desc')
            ->get();

        // 4a. Format Test Results (Labs)
        $testResults = $attachments
            ->filter(fn ($att) => $att->attachment_type?->value !== 'imaging')
            ->values()
            ->map(fn ($lab) => [
                'id' => $lab->id,
                'title' => $lab->attachment_name ?? 'Lab Result',
                'lab' => 'NetHealth Clinical Lab', // Modify if you store specific lab facility names
                'date' => $lab->uploaded_at ? $lab->uploaded_at->format('M d, Y') : 'Unknown Date',
                'status' => ucfirst($lab->test_result_status?->value ?? $lab->test_result_status ?? 'Pending'),
            ]);

        // 4b. Format Imaging
        $imaging = $attachments
            ->filter(fn ($att) => $att->attachment_type?->value === 'imaging')
            ->values()
            ->map(function ($img) {
                // Fallback logic to determine modality from title if not explicitly stored
                $title = strtolower($img->attachment_name ?? '');
                $modality = str_contains($title, 'mri') ? 'MRI' : (str_contains($title, 'ct') ? 'CT Scan' : (str_contains($title, 'ultrasound') ? 'Ultrasound' : 'X-ray'));

                return [
                    'id'     => $img->id,
                    'title' => $img->attachment_name ?? 'Imaging Scan',
                    'region' => $img->notes ?? 'Unspecified Region', // Using notes as a fallback for body region
                    'doctor' => 'Dr. '.($img->medicalRecord?->doctor?->user?->full_name ?? 'Unknown'),
                    'date' => $img->uploaded_at ? $img->uploaded_at->format('M d, Y') : 'Unknown Date',
                    'modality' => $modality,
                ];
            });

        // 5. Format Prescriptions
        $rawPrescriptions = Prescription::with([
            'medicalRecord.appointment', // Kept so visitType doesn't break
            'medicalRecord.doctor.user',
            'items.medicine',
        ])
            ->whereHas('medicalRecord', function ($query) use ($patientId) {
                $query->where('patient_id', $patientId);
            })
            ->orderBy('created_at', 'desc')
            ->get();

        // Map the database models into the exact shape PrescriptionCard.vue expects
        $prescriptions = $rawPrescriptions->map(function ($prescription) {

            // Format status cleanly for the UI Badge (Active / Expired)
            $rawStatus = $prescription->prescription_status->value ?? $prescription->status ?? 'issued';
            $uiStatus = in_array(strtolower($rawStatus), ['active', 'issued']) ? 'Active' : 'Expired';

            return [
                'id' => $prescription->id,
                'doctor' => 'Dr. '.($prescription->medicalRecord->doctor->user->full_name ?? 'Unknown'),
                'specialty' => $prescription->medicalRecord->doctor->specialty ?? 'General Practice',
                'visitType' => ucwords(str_replace('_', ' ', $prescription->medicalRecord->appointment->appointment_type->value ?? 'Consultation')),
                'date' => $prescription->created_at->format('M d, Y'),
                'expires' => $prescription->created_at->addDays(30)->format('M d, Y'),
                'status' => $uiStatus,
                'condition' => $prescription->notes ?? $prescription->medicalRecord->diagnosis_notes ?? 'General Treatment',
                'diagnosis' => $prescription->medicalRecord->diagnosis_notes ?? 'General Checkup',

                // Pluck just the medicine names into a flat array of strings
                'medicines' => $prescription->items->map(function ($item) {
                    // You can easily append dosages here later if needed! e.g., $item->medicine->name . ' ' . $item->dosage
                    return $item->medicine->name;
                })->toArray(),
            ];
        });

        // dd($prescriptions);

        // 6. Format Visit History
        $visitsRaw = Appointment::with(['doctor.user', 'medicalRecord.prescriptions'])
            ->where('patient_id', $patientId)
            ->where('appointment_status', 'completed') // Usually only show completed visits in history
            ->orderBy('appointment_time', 'desc')
            ->get();

        $visits = $visitsRaw->map(function ($apt) {
            $hasPrescription = $apt->medicalRecord && $apt->medicalRecord->prescriptions->isNotEmpty();

            return [
                'visitType' => ucwords(str_replace('_', ' ', $apt->appointment_type?->value ?? 'Consultation')),
                'date' => $apt->appointment_time->format('M d, Y'),
                'time' => $apt->appointment_time->format('h:i A'),
                'title' => $apt->visit_reason ?? 'General Consultation',
                'summary' => $apt->medicalRecord?->diagnosis_notes ?? 'No clinical summary provided for this visit.',
                'status' => ucfirst($apt->appointment_status?->value ?? 'Completed'),
                'hasPrescription' => $hasPrescription,
                'prescriptionNote' => $hasPrescription ? 'Medication prescribed during visit' : null,
            ];
        });

        // 7. Return to Inertia
        return Inertia::render('DoctorDashboard/MedicalRecord', [
            'doctor' => $doctorProfile,
            'patient' => $patientData,
            'testResults' => $testResults,
            'imaging' => $imaging,
            'prescriptions' => $prescriptions,
            'visits' => $visits,
        ]);
    }
}
