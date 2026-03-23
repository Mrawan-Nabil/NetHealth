<?php

namespace Database\Factories;

use App\Models\Medicine;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Medicine>
 */
class MedicineFactory extends Factory
{
    protected $model = Medicine::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->randomElement(['Amoxicillin', 'Panadol', 'Lipitor', 'Metformin', 'Ibuprofen', 'Lisinopril', 'Amlodipine', 'Omeprazole']),
            'category' => fake()->randomElement(['Antibiotic', 'Analgesic', 'Statin', 'Antidiabetic', 'NSAID', 'ACE Inhibitor', 'Calcium Channel Blocker', 'PPI']),
            'strength' => fake()->randomElement(['10mg', '20mg', '50mg', '100mg', '200mg', '500mg', '1g']),
        ];
    }
}
