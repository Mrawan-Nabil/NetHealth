<?php

namespace Database\Factories;

use App\Enums\RecordStatus;
use App\Models\Appointment;
use App\Models\Doctor;
use App\Models\MedicalRecord;
use App\Models\Patient;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\MedicalRecord>
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
        return [
            'appointment_id' => Appointment::factory(),
            'patient_id' => Patient::factory(),
            'doctor_id' => Doctor::factory(),
            'diagnosis_notes' => fake()->randomElement([
                'Patient presents with typical symptoms of seasonal allergies. Prescribed antihistamines.',
                'Routine physical examination shows normal vitals. Patient advises continuing current dietary plan.',
                'Mild elevated blood pressure. Advised lifestyle changes and scheduled follow-up in 3 months.',
                'Symptoms indicative of mild upper respiratory infection. Advised rest and hydration.',
            ]),
            'record_status' => fake()->randomElement([
                RecordStatus::Open->value,
                RecordStatus::Closed->value,
                RecordStatus::Archived->value,
            ]),
        ];
    }
}
