<?php

namespace Database\Factories;

use App\Enums\BloodType;
use App\Enums\UserRole;
use App\Models\Patient;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Patient>
 */
class PatientFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory()->create(['role' => UserRole::Patient->value])->id,
            'blood_type' => fake()->randomElement([
                BloodType::APositive->value,
                BloodType::ANegative->value,
                BloodType::BPositive->value,
                BloodType::BNegative->value,
                BloodType::ABPositive->value,
                BloodType::ABNegative->value,
                BloodType::OPositive->value,
                BloodType::ONegative->value,
            ]),
            'allergies' => fake()->randomElements([
                'Penicillin', 'Peanuts', 'Latex', 'Aspirin', 'Dust Mites', 'Pollen', 'Shellfish', 'Dairy', 'Soy', 'Tree Nuts'
            ], fake()->numberBetween(0, 3)),
            'chronic_conditions' => fake()->randomElement([
                'Type 2 Diabetes', 'Hypertension', 'Asthma', 'None', 'Thyroid Disorder', 'Arthritis', 'Chronic Migraine', 'High Cholesterol'
            ]),
            'emergency_contact_name' => fake()->name(),
            'emergency_contact_phone' => fake()->unique()->numerify('01#########'),
            'emergency_contact_relationship' => fake()->randomElement([
                'Parent',
                'Spouse',
                'Sibling',
                'Friend',
                'Child',
            ]),
        ];
    }
}
