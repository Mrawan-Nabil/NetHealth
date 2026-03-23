<?php

namespace Database\Factories;

use App\Enums\TestResultStatus;
use App\Models\MedicalAttachment;
use App\Models\MedicalRecord;
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
        return [
            'medical_record_id' => MedicalRecord::factory(),
            'test_result_status' => fake()->randomElement([
                TestResultStatus::Pending->value,
                TestResultStatus::Reviewed->value,
            ]),
            'file_path' => 'medical_records/attachments/test_result_' . Str::random(10) . '.pdf',
            'file_type' => fake()->randomElement(['pdf', 'jpg', 'png']),
            'uploaded_at' => fake()->dateTimeThisYear(),
        ];
    }
}
