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
            'medical_record_id' => MedicalRecord::inRandomOrder()->value('id') ?? MedicalRecord::factory(),
            'pharmacy_id' => fake()->boolean(80) ? (Pharmacy::inRandomOrder()->value('id') ?? Pharmacy::factory()) : null,
            'prescription_status' => fake()->randomElement(PrescriptionStatus::cases())->value,
            'notes' => fake()->sentence(),
        ];
    }
}
