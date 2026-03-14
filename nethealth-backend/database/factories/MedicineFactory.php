<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class MedicineFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => $this->faker->randomElement(['Amoxicillin', 'Panadol', 'Lipitor', 'Metformin']),
            'category' => $this->faker->randomElement(['Antibiotic', 'Analgesic', 'Statin', 'Antidiabetic']),
            'strength' => $this->faker->randomElement(['500mg', '1000mg', '20mg']),
        ];
    }
}
