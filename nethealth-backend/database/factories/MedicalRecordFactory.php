<?php

namespace Database\Factories;

use App\Enums\RecordStatus;
use App\Models\Appointment;
use App\Models\MedicalRecord;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<MedicalRecord>
 */
class MedicalRecordFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $appointment = Appointment::doesntHave('medicalRecord')->inRandomOrder()->first() ?? Appointment::factory()->create();

        return [
            'appointment_id' => $appointment->id,
            'patient_id' => $appointment->patient_id,
            'doctor_id' => $appointment->doctor_id,
            'diagnosis_notes' => fake()->paragraphs(3, true),
            'record_status' => fake()->randomElement(RecordStatus::cases())->value,
        ];
    }
}
