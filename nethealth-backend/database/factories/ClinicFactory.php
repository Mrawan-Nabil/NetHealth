<?php

namespace Database\Factories;

use App\Enums\UserRole;
use App\Models\Clinic;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Clinic>
 */
class ClinicFactory extends Factory
{
    protected $model = Clinic::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'license_number' => fake()->unique()->randomNumber(6),
            'is_verified' => fake()->boolean(),
            'clinic_name' => fake()->company() . ' Clinic',
            'user_id' => User::factory()->create(['role' => UserRole::Clinic->value])->id,
            'clinic_address' => fake()->address(),
            'clinic_governorate' => fake()->city(),
            'clinic_phone' => fake()->phoneNumber(),
            'clinic_type' => fake()->word(),
            'commercial_registration_number' => fake()->numerify('######'),
            'tax_id' => fake()->numerify('######'),
            'verification_documents' => [],
        ];
    }
}
