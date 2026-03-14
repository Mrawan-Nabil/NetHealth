<?php

namespace Database\Factories;

use App\Enums\BloodType;
use App\Enums\UserRole;
use App\Models\Patient;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Patient>
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
            'blood_type' => fake()->randomElement(BloodType::cases())->value,
            'allergies' => [fake()->word(), fake()->word()],
            'chronic_conditions' => fake()->optional()->sentence(),
            'emergency_contact_name' => fake()->name(),
            'emergency_contact_phone' => fake()->phoneNumber(),
        ];
    }
}
