<?php

namespace App\Http\Controllers\Api\Patient;

use App\Enums\PrescriptionStatus;
use App\Http\Controllers\Api\ApiController;
use App\Models\Prescription;
use Carbon\Carbon;
use Illuminate\Http\Request;

class PatientPrescriptionApiController extends ApiController
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $rawPrescriptions = Prescription::with([
            'medicalRecord.doctor.user',
            'items.medicine',
        ])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                $query->where('patient_id', $user->patient->user_id);
            })
            ->orderBy('created_at', 'desc')
            ->get();

        $prescriptions = $rawPrescriptions->map(function ($prescription) {
            $expiresAt = $prescription->created_at->addDays(30)->format('M d, Y');
            $status    = $prescription->prescription_status->value ?? 'pending';

            // Compute a simple active/expired flag for the UI
            $isActive = in_array($status, [
                PrescriptionStatus::Pending->value,
                PrescriptionStatus::Issued->value,
            ]);

            return [
                'id'                 => $prescription->id,
                'doctor'             => 'Dr. ' . ($prescription->medicalRecord->doctor->user->full_name ?? 'Unknown'),
                'specialty'          => $prescription->medicalRecord->doctor->specialty ?? 'General Practice',
                'date'               => $prescription->created_at->format('M d, Y'),
                'expires'            => $expiresAt,
                'prescription_status'=> $status,
                'is_active'          => $isActive,
                'diagnosis'          => $prescription->medicalRecord->diagnosis_notes ?? 'General Checkup',
                // Flat list of "Name dosage — frequency for duration"
                'medicines'          => $prescription->items->map(function ($item) {
                    $parts = array_filter([
                        $item->medicine->name ?? null,
                        $item->dosage ?? null,
                        $item->frequency ? '— ' . $item->frequency : null,
                        $item->duration_days ? 'for ' . $item->duration_days . ' days' : null,
                    ]);
                    return implode(' ', $parts);
                })->toArray(),
            ];
        });

        return response()->json([
            'status'  => 'success',
            'message' => 'Prescriptions loaded.',
            'data'    => $prescriptions->values()->all(),
            'meta'    => [
                'current_page' => 1,
                'last_page'    => 1,
                'per_page'     => $prescriptions->count(),
                'total'        => $prescriptions->count(),
            ],
        ]);
    }

    public function show(Request $request, string $id)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $prescription = Prescription::with([
            'medicalRecord.doctor.user',
            'medicalRecord.patient.user',
            'items.medicine',
        ])->findOrFail($id);

        // Security: belongs to this patient?
        if ((int) $prescription->medicalRecord->patient_id !== (int) $user->patient->user_id) {
            return $this->errorResponse('Unauthorised access to this prescription.', 403);
        }

        $expiresAt = $prescription->created_at->addDays(30)->format('M d, Y');

        $data = [
            'id'            => $prescription->id,
            'generated_date'=> $prescription->created_at->format('F d, Y'),
            'expires'       => $expiresAt,
            'prescription_status' => $prescription->prescription_status->value,
            'doctor'        => [
                'name'           => 'Dr. ' . ($prescription->medicalRecord->doctor->user->full_name ?? 'Unknown'),
                'credentials'    => $prescription->medicalRecord->doctor->specialty ?? 'MD',
                'license'        => $prescription->medicalRecord->doctor->syndicate_id ?? 'N/A',
                'phone'          => $prescription->medicalRecord->doctor->user->phone ?? 'N/A',
                'avatar'         => $prescription->medicalRecord->doctor->user->avatar
                    ? '/storage/' . $prescription->medicalRecord->doctor->user->avatar
                    : 'https://ui-avatars.com/api/?name=Doctor&background=0F172A&color=fff',
            ],
            'patient'       => [
                'name'   => $prescription->medicalRecord->patient->user->full_name ?? 'N/A',
                'gender' => $prescription->medicalRecord->patient->user->gender?->value ?? 'N/A',
                'age'    => $prescription->medicalRecord->patient->user->birth_date
                    ? Carbon::parse($prescription->medicalRecord->patient->user->birth_date)->age
                    : null,
                'id'     => '#PT-' . str_pad($prescription->medicalRecord->patient->user_id, 8, '0', STR_PAD_LEFT),
            ],
            'diagnosis'     => [
                'title'       => $prescription->medicalRecord->diagnosis_title ?? 'Clinical Diagnosis',
                'description' => $prescription->medicalRecord->diagnosis_notes ?? 'No detailed description provided.',
            ],
            'medicines'     => $prescription->items->map(function ($item) {
                return [
                    'name'         => $item->medicine->name ?? 'Unknown',
                    'type'         => $item->medicine->category ?? 'Medication',
                    'dosage'       => $item->dosage ?? 'As directed',
                    'frequency'    => $item->frequency ?? 'As directed',
                    'duration'     => ($item->duration_days ?? '?') . ' Days',
                    'instructions' => 'Take as directed by physician.',
                ];
            }),
            'notes'         => $prescription->notes
                ? array_values(array_filter(explode("\n", $prescription->notes)))
                : ['No additional notes provided.'],
        ];

        return $this->successResponse($data, 'Prescription detail loaded.');
    }
}
