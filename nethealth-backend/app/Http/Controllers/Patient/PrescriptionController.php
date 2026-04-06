<?php

namespace App\Http\Controllers\Patient;

use App\Http\Controllers\Controller;
use App\Models\Prescription;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PrescriptionController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        // Fetch prescriptions with eager loaded relationships to avoid N+1 queries
        $rawPrescriptions = Prescription::with([
            'medicalRecord.doctor.user',
            'items.medicine',
        ])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                // Assuming medical records belong to a patient
                $query->where('patient_id', $user->patient->user_id);
            })
            ->orderBy('created_at', 'desc')
            ->get();

        // Map the database models into the exact shape PrescriptionCard.vue expects
        $prescriptions = $rawPrescriptions->map(function ($prescription) {
            return [
                'id' => $prescription->id,
                'doctor' => 'Dr. '.($prescription->medicalRecord->doctor->user->full_name ?? 'Unknown'),
                // Fallback to a default if specialty isn't on the doctor model yet
                'specialty' => $prescription->medicalRecord->doctor->specialty ?? 'General Practice',
                'date' => $prescription->created_at->format('M d, Y'),
                // Assuming standard 30 day expiration for UI, adjust if you have a real DB column
                'expires' => $prescription->created_at->addDays(30)->format('M d, Y'),
                // Uses your Enum
                'status' => $prescription->prescription_status->value ?? 'issued',
                'diagnosis' => $prescription->medicalRecord->diagnosis_notes ?? 'General Checkup',
                // Pluck just the medicine names into a flat array of strings
                'medicines' => $prescription->items->map(function ($item) {
                    return $item->medicine->name;
                })->toArray(),
            ];
        });

        return Inertia::render('PatientDashboard/MedicalRecords', [
            'prescriptions' => $prescriptions,
            'notifications' => [], // Add notification logic later
            'currentUser' => [
                'name' => $user->full_name,
                'username' => '@'.explode('@', $user->email)[0],
                'avatar' => $user->avatar ? '/storage/'.$user->avatar : "https://ui-avatars.com/api/?name={$user->full_name}&background=0D9488&color=fff",
            ],
        ]);
    }

    public function show(Request $request, string $id)
    {
        $user = $request->user();

        // Find the specific prescription and eager load EVERYTHING needed for the detailed view
        $prescriptionModel = Prescription::with([
            'medicalRecord.doctor.user',
            'medicalRecord.patient.user',
            'items.medicine',
        ])->findOrFail($id);

        // 🛑 DEBUG POINT 1: Dump the raw model to an array
        // dd($prescriptionModel->toArray());

        // Security Check: Ensure this prescription belongs to the logged-in patient
        if ($prescriptionModel->medicalRecord->patient_id !== $user->patient->user_id) {
            abort(403, 'Unauthorized access to this medical record.');
        }

        // 🛑 DEBUG POINT 2: Test the specific chain
        //        dd([
        //            '1_has_record' => $prescriptionModel->medicalRecord !== null,
        //            '2_has_doctor' => $prescriptionModel->medicalRecord?->doctor !== null,
        //            '3_has_user' => $prescriptionModel->medicalRecord?->doctor?->user !== null,
        //            '4_doctor_name' => $prescriptionModel->medicalRecord?->doctor?->user?->full_name,
        //        ]);

        // Map to the complex object structure expected by PrescriptionDetails.vue
        $formattedPrescription = [
            'id' => $prescriptionModel->id,
            'generatedDate' => $prescriptionModel->created_at->format('F d, Y'),

            'doctor' => [
                'name' => 'Dr. '.($prescriptionModel->medicalRecord->doctor->user->full_name ?? 'Unknown'),
                'credentials' => $prescriptionModel->medicalRecord->doctor->specialty ?? 'MD',
                'license' => $prescriptionModel->medicalRecord->doctor->syndicate_id ?? 'N/A',
                'phone' => $prescriptionModel->medicalRecord->doctor->user->phone ?? 'N/A',
                'status' => $prescriptionModel->medicalRecord->doctor->user->account_status->value ?? 'N/A',
                'clinicAddress' => $prescriptionModel->medicalRecord->appointment->clinic->clinic_address ?? 'NetHealth Virtual Clinic',
                'avatar' => $prescriptionModel->medicalRecord->doctor->user->avatar
                    ? 'storage/app/public/avatars'.$prescriptionModel->medicalRecord->doctor->user->avatar
                    : 'https://ui-avatars.com/api/?name=Doctor&background=0F172A&color=fff',
            ],

            'patient' => [
                'name' => $prescriptionModel->medicalRecord->patient->user->full_name,
                'gender' => $prescriptionModel->medicalRecord->patient->user->gender,
                'age' => Carbon::parse($prescriptionModel->medicalRecord->patient->user->birth_date)->age ?? 'N/A',
                'id' => '#PT-'.str_pad($prescriptionModel->medicalRecord->patient->user_id, 8, '0', STR_PAD_LEFT),
            ],

            'diagnosis' => [
                'title' => $prescriptionModel->medicalRecord->diagnosis_title ?? 'Clinical Diagnosis',
                'description' => $prescriptionModel->medicalRecord->diagnosis_notes ?? 'No detailed description provided by the doctor.',
            ],

            'medicines' => $prescriptionModel->items->map(function ($item) {
                return [
                    'name' => $item->medicine->name,
                    'type' => $item->medicine->category ?? 'Medication', // e.g., 'ACE Inhibitor'
                    'dosage' => $item->dosage,
                    'frequency' => $item->frequency,
                    'duration' => $item->duration_days.' Days',
                    'instructions' => $item->notes ?? 'Take as directed by physician',
                ];
            }),

            // Assuming notes might be stored as a newline-separated string in DB, split them into an array
            'notes' => $prescriptionModel->notes
                ? array_filter(explode("\n", $prescriptionModel->notes))
                : ['No additional notes provided.'],

            // Placeholder for attachments (you'll implement file uploads later)
            'attachments' => [
                // ['name' => 'Scan.pdf', 'size' => '1.2 MB']
            ],
        ];

        // 🛑 DEBUG POINT 3: Check the final array going to Vue
        // dd($formattedPrescription['doctor']);

        return Inertia::render('PatientDashboard/PrescriptionDetails', [
            'prescription' => $formattedPrescription,
        ]);
    }
}
