<?php

namespace Database\Factories;

use App\Enums\PrescriptionStatus;
use App\Models\MedicalRecord;
use App\Models\Pharmacy;
use App\Models\Prescription;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Prescription>
 */
class PrescriptionFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'medical_record_id' => MedicalRecord::factory(),
            'pharmacy_id' => fake()->boolean(80) ? Pharmacy::factory() : null,
            'prescription_status' => fake()->randomElement([
                PrescriptionStatus::Pending->value,
                PrescriptionStatus::Issued->value,
                PrescriptionStatus::Dispensed->value,
                PrescriptionStatus::Cancelled->value,
            ]),
            'notes' => fake()->randomElement([
                'Take after meals.', 'Take on an empty stomach.', 'Avoid alcohol while on this medication.', 'Take before sleep.'
            ]),
        ];
    }
}
