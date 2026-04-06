<?php

namespace App\Http\Controllers\Patient;

use App\Enums\AttachmentType;
use App\Http\Controllers\Controller;
use App\Models\MedicalAttachment;
use Illuminate\Http\Request;
use Inertia\Inertia;

class TestResultController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user()->load('patient');

        // Fetch attachments, ensuring we only get them for the logged-in patient
        $rawAttachments = MedicalAttachment::whereHas('medicalRecord', function ($query) use ($user) {
            // Ensure the medical record belongs to the current patient
            $query->where('patient_id', $user->patient->user_id);
        })
            // Filter to ONLY show lab results on this specific page
            ->where('attachment_type', AttachmentType::Lab_Result->value)
            ->orderBy('uploaded_at', 'desc')
            ->get();

        // Map the database models to match the Vue component's required props
        $testResults = $rawAttachments->map(function ($attachment) {

            // Format the enum value (e.g., 'lab_result' -> 'Lab Result')
            $formattedCategory = ucwords(str_replace('_', ' ', $attachment->attachment_type->value));

            return [
                'id' => $attachment->id,
                'name' => $attachment->attachment_name ?? 'Unnamed Test',
                'status' => $attachment->test_result_status->value ?? 'Pending',
                'date' => $attachment->uploaded_at ? $attachment->uploaded_at->format('Y-m-d') : null,
                // Replacing 'lab' with the formatted category as requested
                'lab' => $formattedCategory,
            ];
        });

        return Inertia::render('PatientDashboard/TestResults', [
            'testResults' => $testResults,
        ]);
    }

    public function show(Request $request, string $id)
    {
        $user = $request->user();

        // Find the specific attachment and ensure it belongs to the logged-in patient
        $attachment = MedicalAttachment::whereHas('medicalRecord', function ($query) use ($user) {
            $query->where('patient_id', $user->patient->user_id);
        })
            ->findOrFail($id);

        // Here, you would typically return a view to show details,
        // OR return a file download response if they are just downloading the PDF.
        // For now, I'll set up a placeholder Inertia render assuming you have a details page.

        $formattedCategory = ucwords(str_replace('_', ' ', $attachment->attachment_type->value));

        return Inertia::render('PatientDashboard/TestResultDetails', [
            'testResult' => [
                'id' => $attachment->id,
                'name' => $attachment->attachment_name,
                'status' => $attachment->test_result_status->value,
                'date' => $attachment->uploaded_at ? $attachment->uploaded_at->format('Y-m-d') : null,
                'lab' => $formattedCategory,
                'notes' => $attachment->notes,
                'file_url' => asset('storage/'.$attachment->file_path),
                'mime_type' => $attachment->mime_type,
            ],
        ]);
    }
}
