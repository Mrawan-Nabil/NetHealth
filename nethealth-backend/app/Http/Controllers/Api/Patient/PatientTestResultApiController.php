<?php

namespace App\Http\Controllers\Api\Patient;

use App\Enums\AttachmentType;
use App\Http\Controllers\Api\ApiController;
use App\Models\MedicalAttachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PatientTestResultApiController extends ApiController
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $rawAttachments = MedicalAttachment::with(['medicalRecord.doctor.user'])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                $query->where('patient_id', $user->patient->user_id);
            })
            ->where('attachment_type', AttachmentType::Lab_Result->value)
            ->orderBy('uploaded_at', 'desc')
            ->get();

        $testResults = $rawAttachments->map(function ($attachment) {
            $category = ucwords(str_replace('_', ' ', $attachment->attachment_type->value));
            $format   = $this->fileFormat($attachment->mime_type);

            return [
                'id'                  => $attachment->id,
                'name'                => $attachment->attachment_name ?? 'Unnamed Test',
                'category'            => $category,
                'lab'                 => $attachment->medicalRecord?->doctor?->user?->full_name
                    ? 'Ordered by Dr. ' . $attachment->medicalRecord->doctor->user->full_name
                    : 'Lab Result',
                'date'                => $attachment->uploaded_at?->format('M d, Y'),
                'test_result_status'  => $attachment->test_result_status->value ?? 'pending',
                'format'              => $format,
            ];
        });

        return response()->json([
            'status'  => 'success',
            'message' => 'Test results loaded.',
            'data'    => $testResults->values()->all(),
            'meta'    => [
                'current_page' => 1,
                'last_page'    => 1,
                'per_page'     => $testResults->count(),
                'total'        => $testResults->count(),
            ],
        ]);
    }

    public function show(Request $request, string $id)
    {
        $user = $request->user()->load('patient');

        if (! $user->patient) {
            return $this->errorResponse('Patient profile not found.', 404);
        }

        $attachment = MedicalAttachment::with(['medicalRecord.doctor.user'])
            ->whereHas('medicalRecord', function ($query) use ($user) {
                $query->where('patient_id', $user->patient->user_id);
            })
            ->findOrFail($id);

        $format   = $this->fileFormat($attachment->mime_type);
        $fileSize = $this->fileSize($attachment->file_path);
        $fileUrl  = asset('storage/' . $attachment->file_path);
        $category = ucwords(str_replace('_', ' ', $attachment->attachment_type->value));

        $data = [
            'id'                 => $attachment->id,
            'name'               => $attachment->attachment_name ?? 'Unnamed Test',
            'category'           => $category,
            'lab'                => $attachment->medicalRecord?->doctor?->user?->full_name
                ? 'Ordered by Dr. ' . $attachment->medicalRecord->doctor->user->full_name
                : 'Lab Result',
            'date'               => $attachment->uploaded_at?->format('M d, Y'),
            'test_result_status' => $attachment->test_result_status->value ?? 'pending',
            'format'             => $format,
            'file_size'          => $fileSize,
            'file_url'           => $fileUrl,
            'mime_type'          => $attachment->mime_type,
            'notes'              => $attachment->notes,
        ];

        return $this->successResponse($data, 'Test result detail loaded.');
    }

    private function fileFormat(?string $mimeType): string
    {
        return match ($mimeType) {
            'application/dicom' => 'DICOM',
            'application/pdf'   => 'PDF',
            'image/jpeg', 'image/jpg' => 'JPG',
            'image/png'         => 'PNG',
            default             => 'FILE',
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

        return number_format($bytes / pow(1024, $power), 1) . ' ' . $units[$power];
    }
}
