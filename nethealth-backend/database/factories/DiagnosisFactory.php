<?php

namespace Database\Factories;

use App\Models\Diagnosis;
use App\Models\MedicalRecord;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Diagnosis>
 */
class DiagnosisFactory extends Factory
{
    protected $model = Diagnosis::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'medical_record_id' => MedicalRecord::factory(),
            'description' => fake()->randomElement([
                'Acute bronchitis', 'Type 2 Diabetes Mellitus', 'Essential hypertension', 'Common cold', 'Migraine', 'Allergic rhinitis', 'Asthma'
            ]),
        ];
    }
}
