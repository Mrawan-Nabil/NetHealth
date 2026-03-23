<?php

namespace Database\Factories;

use App\Enums\PharmacyStaffRole;
use App\Enums\UserRole;
use App\Models\Pharmacy;
use App\Models\PharmacyStaff;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\PharmacyStaff>
 */
class PharmacyStaffFactory extends Factory
{
    protected $model = PharmacyStaff::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'pharmacy_id' => Pharmacy::factory(),
            'user_id' => User::factory()->create(['role' => UserRole::Pharmacy->value])->id,
            'staff_role' => fake()->randomElement([
                PharmacyStaffRole::Admin->value,
                PharmacyStaffRole::Assistant->value,
                PharmacyStaffRole::Pharmacist->value,
            ]),
        ];
    }
}
