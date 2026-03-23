<?php

namespace Database\Factories;

use App\Models\Medicine;
use App\Models\Prescription;
use App\Models\PrescriptionItem;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\PrescriptionItem>
 */
class PrescriptionItemFactory extends Factory
{
    protected $model = PrescriptionItem::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'prescription_id' => Prescription::factory(),
            'medicine_id' => Medicine::factory(),
            'dosage' => fake()->randomElement(['1 tablet', '2 tablets', '1 capsule', '5ml', '10ml']),
            'frequency' => fake()->randomElement(['Once daily', 'Twice daily', 'Three times a day', 'As needed', 'Every 8 hours']),
            'duration_days' => fake()->numberBetween(3, 30),
        ];
    }
}
