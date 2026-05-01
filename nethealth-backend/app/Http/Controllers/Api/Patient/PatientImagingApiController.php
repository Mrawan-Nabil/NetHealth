<?php

namespace App\Http\Controllers\Api\Patient;

use App\Enums\AttachmentType;
use App\Http\Controllers\Api\ApiController;
use App\Models\MedicalAttachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PatientImagingApiController extends ApiController
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $rawAttachments = MedicalAttachment::with([
            'medicalRecord.doctor.user',
            'medicalRecord.appointment.clinic',
        ])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                $query->where('patient_id', $user->patient->user_id);
            })
            ->where('attachment_type', AttachmentType::Imaging->value)
            ->orderBy('uploaded_at', 'desc')
            ->get();

        $imagingRecords = $rawAttachments->map(function ($attachment) {
            $format = $this->fileFormat($attachment->mime_type);
            $modality = $this->extractModality($attachment->attachment_name);
            $status = strtolower($attachment->test_result_status->value ?? 'pending');

            return [
                'id' => $attachment->id,
                'title' => $attachment->attachment_name ?? 'Diagnostic Scan',
                'type' => $modality,
                'test_result_status' => $status,
                'hospital' => $attachment->medicalRecord?->appointment?->clinic?->clinic_name ?? 'NetHealth Central',
                'physician' => 'Dr. '.($attachment->medicalRecord?->doctor?->user?->full_name ?? 'Unknown'),
                'scan_date' => $attachment->uploaded_at?->format('M d, Y'),
                'file' => [
                    'name' => basename($attachment->file_path ?? ''),
                    'format' => $format,
                    'size' => $this->fileSize($attachment->file_path),
                ],
            ];
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Imaging records loaded.',
            'data' => $imagingRecords->values()->all(),
            'meta' => [
                'current_page' => 1,
                'last_page' => 1,
                'per_page' => $imagingRecords->count(),
                'total' => $imagingRecords->count(),
            ],
        ]);
    }

    public function show(Request $request, string $id)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $attachment = MedicalAttachment::with([
            'medicalRecord.doctor.user',
            'medicalRecord.appointment.clinic',
        ])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                $query->where('patient_id', $user->patient->user_id);
            })
            ->findOrFail($id);

        $format = $this->fileFormat($attachment->mime_type);
        $fileSize = $this->fileSize($attachment->file_path);
        $imageUrl = asset('storage/'.$attachment->file_path);
        $modality = $this->extractModality($attachment->attachment_name);
        $physicianName = 'Dr. '.($attachment->medicalRecord?->doctor?->user?->full_name ?? 'Unknown');
        $physicianTitle = $attachment->medicalRecord?->doctor?->professional_title ?? 'Radiologist';

        $data = [
            'id' => $attachment->id,
            'title' => $attachment->attachment_name ?? 'Diagnostic Scan',
            'type' => $modality,
            'test_result_status' => strtolower($attachment->test_result_status->value ?? 'pending'),
            'file_info' => [
                'type' => $modality,
                'size' => $fileSize,
                'physician' => $physicianName,
                'radiology_center' => $attachment->medicalRecord?->appointment?->clinic?->clinic_name ?? 'NetHealth Central',
                'scan_date' => $attachment->uploaded_at?->format('M d, Y'),
                'format' => $format,
            ],
            'notes' => [
                'physician_interpretation' => [
                    'text' => $attachment->notes ?? 'No interpretation notes provided by the physician.',
                    'author' => $physicianName.', '.$physicianTitle,
                ],
            ],
            // images array for the viewer — single file maps here
            'images' => [
                [
                    'id' => $attachment->id,
                    'url' => $imageUrl,
                    'active' => true,
                ],
            ],
        ];

        return $this->successResponse($data, 'Imaging detail loaded.');
    }

    // ── Helpers ─────────────────────────────────────────────────────────────────

    private function fileFormat(?string $mimeType): string
    {
        return match ($mimeType) {
            'application/dicom' => 'DICOM',
            'application/pdf' => 'PDF',
            'image/jpeg', 'image/jpg' => 'JPG',
            'image/png' => 'PNG',
            default => 'FILE',
        };
    }

    private function fileSize(?string $path): string
    {
        if (! $path || ! Storage::disk('public')->exists($path)) {
            return 'Unknown';
        }
        $bytes = Storage::disk('public')->size($path);
        $units = ['B', 'KB', 'MB', 'GB'];
        $power = $bytes > 0 ? floor(log($bytes, 1024)) : 0;

        return number_format($bytes / pow(1024, $power), 1).' '.$units[$power];
    }

    private function extractModality(?string $name): string
    {
        if (! $name) {
            return 'Imaging';
        }
        $lower = strtolower($name);
        if (str_contains($lower, 'mri') || str_contains($lower, 'magnetic resonance')) {
            return 'MRI';
        }
        if (str_contains($lower, 'ct ') || str_contains($lower, 'cat scan') || str_contains($lower, 'computed tomography')) {
            return 'CT Scan';
        }
        if (str_contains($lower, 'x-ray') || str_contains($lower, 'xray')) {
            return 'X-Ray';
        }
        if (str_contains($lower, 'ultrasound') || str_contains($lower, 'sonogram') || str_contains($lower, 'echo')) {
            return 'Ultrasound';
        }
        if (str_contains($lower, 'pet ') || str_contains($lower, 'positron')) {
            return 'PET Scan';
        }
        if (str_contains($lower, 'mammogram') || str_contains($lower, 'mammography')) {
            return 'Mammogram';
        }

        return 'Imaging';
    }
}
