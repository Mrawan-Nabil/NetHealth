<?php

namespace Database\Factories;

use App\Models\Medicine;
use App\Models\Prescription;
use App\Models\PrescriptionItem;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class PrescriptionItemsFactory extends Factory
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
            'prescription_id' => Prescription::inRandomOrder()->value('id') ?? Prescription::factory(),
            'medicine_id' => Medicine::inRandomOrder()->value('id') ?? Medicine::factory(),
            'dosage' => '1 tablet',
            'frequency' => 'Twice daily',
            'duration_days' => 7,
        ];
    }
}
