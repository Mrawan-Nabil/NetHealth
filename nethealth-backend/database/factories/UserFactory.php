<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\User>
 */
class UserFactory extends Factory
{
    /**
     * The current password being used by the factory.
     */
    protected static ?string $password;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'full_name' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'phone' => fake()->unique()->numerify('010########'),
            'national_id' => fake()->unique()->numerify('##############'),
            'gender' => fake()->randomElement(['male', 'female']),
            'birth_date' => fake()->date(),
            'governorate' => fake()->city(),
            'password' => Hash::make('12345678'),
            'role' => fake()->randomElement(['doctor', 'patient']),
            'email_verified' => true,
            'account_status' => 'Active',
        ];
    }

    /**
     * Indicate that the model's email address should be unverified.
     */
    public function unverified(): static
    {
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}
