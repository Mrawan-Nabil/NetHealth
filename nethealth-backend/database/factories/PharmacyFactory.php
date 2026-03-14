<?php

namespace Database\Factories;

use App\Enums\UserRole;
use App\Models\Pharmacy;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Pharmacy>
 */
class PharmacyFactory extends Factory
{
    protected $model = Pharmacy::class;

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
            'user_id' => User::factory()->create(['role' => UserRole::Pharmacy->value])->id,
            'commercial_registration_number' => fake()->numerify('######'),
            'pharmacy_name' => fake()->company() . ' Pharmacy',
            'pharmacy_phone' => fake()->phoneNumber(),
            'pharmacy_address' => fake()->address(),
            'pharmacy_governorate' => fake()->city(),
            'tax_id' => fake()->numerify('######'),
            'verification_documents' => [],
        ];
    }
}
