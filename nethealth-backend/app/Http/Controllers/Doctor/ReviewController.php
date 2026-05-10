<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Models\MedicalRecord;
use App\Traits\AvatarResolver;
use App\Traits\DoctorPropBuilder;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ReviewController extends Controller
{
    use AvatarResolver;
    use DoctorPropBuilder;

    /**
     * Display the Doctor's Patient Reviews List.
     */
    public function index(Request $request)
    {
        $user = $request->user();
        $doctorId = $user->id;

        // 1. Construct Doctor Profile Prop
        $doctorProfile = $this->buildDoctorProp($user);

        // 2. Fetch records that have attachments, ordered by newest first
        $rawRecords = MedicalRecord::with(['patient.user', 'attachments'])
            ->where('doctor_id', $doctorId)
            ->whereHas('attachments') // Only fetch records that actually have files to review
            ->orderBy('created_at', 'desc')
            ->get();

        // 3. Map to the exact Vue data contract
        $reviews = $rawRecords->map(function ($record) {
            $name = $record->patient?->user?->full_name ?? 'Unknown Patient';
            $initials = collect(explode(' ', $name))->map(fn ($n) => substr($n, 0, 1))->take(2)->implode('');

            // Determine status: If ANY file in this record is pending, the whole record is Pending
            $hasPendingFiles = $record->attachments->contains(function ($attachment) {
                return $attachment->test_result_status?->value === 'pending' || $attachment->test_result_status === 'pending';
            });

            // Use the date of the most recently uploaded attachment for the UI timestamp
            $latestAttachment = $record->attachments->sortByDesc('uploaded_at')->first();
            $displayDate = $latestAttachment ? $latestAttachment->uploaded_at : $record->created_at;

            return [
                'id' => $record->id,
                'patientId' => $record->patient_id,
                'patientName' => $name,
                'initials' => strtoupper($initials),
                'filesCount' => $record->attachments->count(),
                'date' => $displayDate->format('M d, Y'),
                'time' => $displayDate->format('h:i A'),
                'status' => $hasPendingFiles ? 'Pending' : 'Reviewed',
            ];
        });

        // 4. Return to Inertia
        return Inertia::render('DoctorDashboard/Reviews', [
            'doctor' => $doctorProfile,
            'reviews' => $reviews,
        ]);
    }
}
