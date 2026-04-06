<?php

namespace Database\Factories;

use App\Enums\AttachmentType;
use App\Enums\TestResultStatus;
use App\Models\MedicalAttachment;
use App\Models\MedicalRecord;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\MedicalAttachment>
 */
class MedicalAttachmentFactory extends Factory
{
    protected $model = MedicalAttachment::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        // Step 1: Select attachment type first
        $type = fake()->randomElement(AttachmentType::cases())->value;

        // Step 2: Category-aware data mapping
        $attachmentData = [
            AttachmentType::Imaging->value => [
                'names' => [
                    'Chest X-Ray',
                    'Brain MRI',
                    'Abdominal CT Scan',
                    'Pelvic Ultrasound',
                    'Doppler Ultrasound (Lower Limb)',
                    'Mammography Screening',
                ],
                'notes' => [
                    'No acute abnormalities detected.',
                    'Mild inflammation observed in the region.',
                    'Findings suggest possible infection.',
                    'Normal radiological appearance.',
                    'Suspicious lesion requires further evaluation.',
                ],
            ],

            AttachmentType::Lab_Result->value => [
                'names' => [
                    'Complete Blood Count (CBC)',
                    'Liver Function Test',
                    'Kidney Function Test',
                    'HbA1c Test',
                    'Lipid Profile',
                    'Thyroid Function Test',
                ],
                'notes' => [
                    'Values within normal range.',
                    'Elevated levels detected, follow-up required.',
                    'Mild deviation from normal limits.',
                    'Critical values observed, urgent attention needed.',
                    'Results consistent with patient history.',
                ],
            ],

            AttachmentType::Clinical_Document->value => [
                'names' => [
                    'Discharge Summary',
                    'Medical Report',
                    'Doctor Notes',
                    'Progress Notes',
                    'Referral Letter',
                ],
                'notes' => [
                    'Patient shows steady improvement.',
                    'Condition stable under current treatment.',
                    'Follow-up visit recommended in two weeks.',
                    'Symptoms partially resolved.',
                    'Detailed clinical observations recorded.',
                ],
            ],

            AttachmentType::Prescription->value => [
                'names' => [
                    'Prescription - Antibiotics',
                    'Prescription - Pain Management',
                    'Prescription - Hypertension',
                    'Prescription - Diabetes Control',
                    'Prescription - Post-Surgery Care',
                ],
                'notes' => [
                    'Take medications as prescribed.',
                    'Dosage adjusted based on patient condition.',
                    'Monitor for side effects.',
                    'Continue medication for 7 days.',
                    'Review after completion of course.',
                ],
            ],
        ];

        // Step 3: Select name + notes based on type
        $attachment_name = fake()->randomElement($attachmentData[$type]['names']);
        $notes = fake()->randomElement($attachmentData[$type]['notes']);

        // Step 4: Match MIME type with category
        $mimeType = match ($type) {
            AttachmentType::Imaging->value => fake()->randomElement([
                'image/jpeg',
                'image/png',
            ]),
            default => 'application/pdf',
        };

        // Step 5: Match extension with MIME type
        $extension = match ($mimeType) {
            'application/pdf' => 'pdf',
            'image/jpeg' => 'jpg',
            'image/png' => 'png',
        };

        return [
            'medical_record_id' => MedicalRecord::factory(),
            'attachment_type' => $type,
            'attachment_name' => $attachment_name,
            'file_path' => 'medical_records/attachments/test_result_'.Str::random(10).'.'.$extension,
            'mime_type' => $mimeType,
            'test_result_status' => fake()->randomElement(TestResultStatus::cases())->value,
            'notes' => $notes,
            'uploaded_by' => User::factory(),
            'uploaded_at' => fake()->dateTimeThisYear(),
        ];
    }
}
