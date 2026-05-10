<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Models\MedicalAttachment;
use App\Models\Patient;
use App\Traits\AvatarResolver;
use App\Traits\DoctorPropBuilder;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ReviewFileController extends Controller
{
    use AvatarResolver;
    use DoctorPropBuilder;

    /**
     * Display the list of files for a specific patient review.
     */
    public function index(Request $request)
    {
        $user = $request->user();
        $doctorId = $user->id;

        // 1. Validate the patient ID from the query string (?patient=X)
        $patientId = $request->query('patient');
        if (! $patientId) {
            abort(404, 'Patient ID is required.');
        }

        // 2. Construct Doctor Profile Prop
        $doctorProfile = $this->buildDoctorProp($user);

        // 3. Fetch Patient Data
        // Find the patient and ensure they actually exist
        $patientModel = Patient::with('user')->where('user_id', $patientId)->firstOrFail();
        $patientName = $patientModel->user->full_name ?? 'Unknown Patient';
        $initials = collect(explode(' ', $patientName))->map(fn ($n) => substr($n, 0, 1))->take(2)->implode('');

        // Calculate Age safely
        $age = $patientModel->user->birth_date
            ? Carbon::parse($patientModel->user->birth_date)->age
            : 'N/A';

        $patient = [
            'name' => $patientName,
            'initials' => strtoupper($initials),
            'rawId' => $patientModel->user_id,
            'age' => $age,
            'gender' => ucfirst($patientModel->user->gender?->value ?? $patientModel->user->gender ?? 'Unspecified'),
            'patientId' => 'PT-'.str_pad($patientModel->user_id, 5, '0', STR_PAD_LEFT), // e.g., PT-00142
        ];

        // 4. Fetch the Medical Files (Attachments)
        // We only want files linked to THIS doctor and THIS patient
        $rawFiles = MedicalAttachment::with('medicalRecord')
            ->whereHas('medicalRecord', function ($query) use ($doctorId, $patientId) {
                $query->where('doctor_id', $doctorId)
                    ->where('patient_id', $patientId);
            })
            ->orderBy('uploaded_at', 'desc')
            ->get();

        // 5. Map to the exact Vue data contract
        $files = $rawFiles->map(function ($file) {
            $isImaging = $file->attachment_type?->value === 'imaging';

            // Determine preview image (if it's an image, show it; if PDF, show a generic icon)
            // You can adjust this logic based on how you actually store files
            $previewImage = null;
            if ($isImaging && $file->file_path) {
                $previewImage = asset('storage/'.$file->file_path);
            }

            return [
                'id' => $file->id,
                'medicalRecordId' => $file->medical_record_id,
                'category' => $isImaging ? 'Imaging' : 'Lab Test',
                'title' => $file->attachment_name ?? ($isImaging ? 'Imaging Scan' : 'Lab Results'),
                'date' => $file->uploaded_at ? $file->uploaded_at->format('M d, Y') : 'Unknown Date',
                'previewImage' => $previewImage, // Pass null if it's a PDF/document
                'buttonText' => $isImaging ? 'View Scan' : 'View Full Report',
            ];
        });

        // 6. Return to Inertia
        return Inertia::render('DoctorDashboard/ReviewFiles', [
            'doctor' => $doctorProfile,
            'patient' => $patient,
            'files' => $files,
        ]);
    }

    /**
     * Display the full file viewer (Imaging or Lab).
     */
    public function show(Request $request)
    {
        $user = $request->user();

        // 1. Read the CRITICAL type prop, default to imaging
        $fileType = $request->query('type', 'imaging');

        // 2. We MUST have a file ID to know which file to fetch!
        $fileId = $request->query('file');
        if (! $fileId) {
            abort(404, 'A specific File ID is required to view the full report.');
        }

        // 3. Fetch Doctor Profile
        $doctorProfile = $this->buildDoctorProp($user);

        // 4. Fetch the Medical Attachment with its relationships
        $attachment = MedicalAttachment::with([
            'medicalRecord.doctor.user',
            'medicalRecord.patient.user',
        ])->findOrFail($fileId);

        // Initialize both as null to strictly satisfy the Vue contract
        $imagingData = null;
        $labData = null;

        // 5. Map Data Based on Type
        if ($fileType === 'imaging') {
            $imagingData = [
                'title' => $attachment->attachment_name ?? 'Imaging Scan',
                'subtitle' => 'Radiology Department — '.($attachment->uploaded_at ? $attachment->uploaded_at->format('M d, Y') : 'Unknown Date'),
                'metadata' => [
                    'Modality' => strtoupper($attachment->attachment_type?->value ?? $attachment->attachment_type ?? 'X-RAY'),
                    'Region' => $attachment->notes ?? 'Unspecified',
                    'Doctor' => 'Dr. '.($attachment->medicalRecord?->doctor?->user?->full_name ?? 'Unknown'),
                    'Date' => $attachment->uploaded_at ? $attachment->uploaded_at->format('M d, Y') : 'Unknown',
                    'Accession' => 'ACC-'.str_pad($attachment->id, 5, '0', STR_PAD_LEFT),
                ],
                'pages' => 1,
                'currentPage' => 1,
                'thumbnails' => [
                    // Provide the actual image path, or a fallback if missing
                    $attachment->file_path ? asset('storage/'.$attachment->file_path) : null,
                ],
            ];
        } else {
            // Because lab results are often stored differently (e.g., JSON columns or related tables),
            // we safely attempt to decode them, or provide an empty array fallback.
            $labRows = is_string($attachment->test_results)
                ? json_decode($attachment->test_results, true)
                : ($attachment->test_results ?? []);

            $labData = [
                'title' => $attachment->attachment_name ?? 'Complete Blood Count (CBC)',
                'subtitle' => 'Clinical Laboratory — '.($attachment->uploaded_at ? $attachment->uploaded_at->format('M d, Y') : 'Unknown Date'),
                'summary' => [
                    'testName' => $attachment->attachment_name ?? 'General Lab Test',
                    'laboratory' => 'NetHealth Clinical Lab',
                    'regId' => 'LAB-'.str_pad($attachment->id, 5, '0', STR_PAD_LEFT),
                    'doctor' => 'Dr. '.($attachment->medicalRecord?->doctor?->user?->full_name ?? 'Unknown'),
                    'specialty' => $attachment->medicalRecord?->doctor?->specialty ?? 'General Practice',
                    'reportDate' => $attachment->uploaded_at ? $attachment->uploaded_at->format('M d, Y') : 'Unknown',
                    'reportId' => 'RPT-'.str_pad($attachment->medical_record_id, 5, '0', STR_PAD_LEFT),
                ],
                'rows' => $labRows,
            ];
        }

        // 6. Return the perfectly shaped response to Inertia
        return Inertia::render('DoctorDashboard/ViewFullFile', [
            'doctor' => $doctorProfile,
            'fileType' => $fileType,
            'imaging' => $imagingData,
            'lab' => $labData,
        ]);
    }
}
