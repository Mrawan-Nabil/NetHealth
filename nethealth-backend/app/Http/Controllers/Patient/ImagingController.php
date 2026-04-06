<?php

namespace App\Http\Controllers\Patient;

use App\Enums\AttachmentType;
use App\Http\Controllers\Controller;
use App\Models\MedicalAttachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class ImagingController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        // Fetch attachments for this patient that are specifically Imaging
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

        // Map data to match ImagingRecordCard.vue
        $imagingRecords = $rawAttachments->map(function ($attachment) {

            $fileFormat = $this->getFileFormat($attachment->mime_type);
            $fileSize = $this->getFileSize($attachment->file_path);

            // Map 'Reviewed' status to 'VERIFIED' for the UI button logic
            $status = strtoupper($attachment->test_result_status->value);

            // Determine if it's an MRI for the specific icon in your UI
            $clinicalType = $this->extractImagingModality($attachment->attachment_name);

            return [
                'id' => $attachment->id,
                'title' => $attachment->attachment_name ?? 'Diagnostic Scan',
                'type' => $clinicalType, // Now returns "MRI", "Ultrasound", "X-Ray", etc.
                'status' => $status,
                'hospital' => $attachment->medicalRecord?->appointment?->clinic?->clinic_name ?? 'NetHealth Central',
                'physician' => 'Dr. '.($attachment->medicalRecord?->doctor?->user?->full_name ?? 'Unknown'),
                'scanDate' => $attachment->uploaded_at ? $attachment->uploaded_at->format('M d, Y') : 'N/A',
                'uploadDate' => $attachment->uploaded_at ? $attachment->uploaded_at->format('M d, Y') : null,
                'file' => [
                    'name' => basename($attachment->file_path),
                    'format' => $fileFormat,
                    'size' => $fileSize,
                ],
            ];
        });

        return Inertia::render('PatientDashboard/ImagingRecords', [
            'imagingRecords' => $imagingRecords,
            'auth' => [
                'user' => [
                    'name' => $user->full_name,
                    'email' => $user->email,
                    'avatar' => $user->avatar ? '/storage/'.$user->avatar : null,
                ],
            ],
        ]);
    }

    public function show(Request $request, string $id)
    {
        $user = $request->user();

        // Find the specific attachment with all relationships
        $attachment = MedicalAttachment::with([
            'medicalRecord.doctor.user',
            'medicalRecord.appointment.clinic',
        ])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                $query->where('patient_id', $user->patient->user_id);
            })
            ->findOrFail($id);

        $fileFormat = $this->getFileFormat($attachment->mime_type);
        $fileSize = $this->getFileSize($attachment->file_path);
        $filePath = $attachment->file_path;

        // Check if the file ACTUALLY exists on your hard drive
        $imageUrl = asset('storage/'.$filePath);

        //            ? asset('storage/'.$filePath)
        //            // Fallback to a placeholder if it's fake factory data
        //            : 'https://placehold.co/800x600/1A1F2E/14B8A6?text=Sample+Scan+Data';

        $physicianName = 'Dr. '.($attachment->medicalRecord?->doctor?->user?->full_name ?? 'Unknown');
        $physicianTitle = $attachment->medicalRecord?->doctor?->professional_title ?? 'Radiologist';
        $clinicalType = $this->extractImagingModality($attachment->attachment_name);

        // Map to match ImagingDetails.vue expectations
        $imagingData = [
            'id' => $attachment->id,
            'title' => $attachment->attachment_name ?? 'Diagnostic Scan',
            'fileInfo' => [
                'type' => $clinicalType,
                'size' => $fileSize,
                'physician' => $physicianName,
                'radiologyCenter' => $attachment->medicalRecord?->appointment?->clinic?->clinic_name ?? 'NetHealth Central',
                'scanDate' => $attachment->uploaded_at ? $attachment->uploaded_at->format('M d, Y') : 'N/A',
                'format' => $fileFormat,
            ],
            'notes' => [
                'physicianInterpretation' => [
                    'text' => $attachment->notes ?? 'No interpretation notes provided by the physician.',
                    'author' => $physicianName.', '.$physicianTitle,
                ],
                'patientComments' => [
                    'text' => '', // Reserved for future feature
                ],
            ],
            'images' => [
                // Single file mapped to the viewer array
                [
                    'id' => $attachment->id,
                    'url' => $imageUrl,
                    'active' => true,
                ],
            ],
        ];

        return Inertia::render('PatientDashboard/ImagingDetail', [
            'imagingData' => $imagingData,
            'auth' => [
                'user' => [
                    'name' => $user->full_name,
                    'email' => $user->email,
                    'avatar' => $user->avatar ? '/storage/'.$user->avatar : null,
                ],
            ],
        ]);
    }

    /**
     * Helper to safely format file sizes
     */
    private function getFileSize($path)
    {
        if (! $path || ! Storage::disk('public')->exists($path)) {
            return 'Unknown Size';
        }

        $bytes = Storage::disk('public')->size($path);
        $units = ['B', 'KB', 'MB', 'GB'];
        $power = $bytes > 0 ? floor(log($bytes, 1024)) : 0;

        return number_format($bytes / pow(1024, $power), 1, '.', '').' '.$units[$power];
    }

    /**
     * Helper to format mime types for UI display
     */
    private function getFileFormat($mimeType)
    {
        return match ($mimeType) {
            'application/dicom' => 'DICOM',
            'application/pdf' => 'PDF',
            'image/jpeg', 'image/jpg' => 'JPG',
            'image/png' => 'PNG',
            default => 'FILE',
        };
    }

    private function extractImagingModality(?string $name): string
    {
        if (! $name) {
            return 'Imaging';
        }

        // Convert to lowercase for easier matching
        $lowerName = strtolower($name);

        if (str_contains($lowerName, 'mri') || str_contains($lowerName, 'magnetic resonance')) {
            return 'MRI';
        }
        if (str_contains($lowerName, 'ct ') || str_contains($lowerName, 'cat scan') || str_contains($lowerName, 'computed tomography')) {
            return 'CT Scan';
        }
        if (str_contains($lowerName, 'x-ray') || str_contains($lowerName, 'xray')) {
            return 'X-Ray';
        }
        if (str_contains($lowerName, 'ultrasound') || str_contains($lowerName, 'sonogram') || str_contains($lowerName, 'echo')) {
            return 'Ultrasound';
        }
        if (str_contains($lowerName, 'pet ') || str_contains($lowerName, 'positron')) {
            return 'PET Scan';
        }
        if (str_contains($lowerName, 'fluoroscopy')) {
            return 'Fluoroscopy';
        }
        if (str_contains($lowerName, 'mammogram') || str_contains($lowerName, 'mammography')) {
            return 'Mammogram';
        }

        // Fallback if no specific machine type is detected
        return 'Imaging';
    }
}
