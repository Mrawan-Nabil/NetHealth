<?php

namespace Database\Factories;

use App\Enums\ClinicStaffRole;
use App\Enums\UserRole;
use App\Models\Clinic;
use App\Models\ClinicStaff;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\ClinicStaff>
 */
class ClinicStaffFactory extends Factory
{
    protected $model = ClinicStaff::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'clinic_id' => Clinic::factory(),
            'user_id' => User::factory()->create(['role' => UserRole::Clinic->value])->id,
            'staff_role' => fake()->randomElement([
                ClinicStaffRole::Admin->value,
                ClinicStaffRole::Receptionist->value,
                ClinicStaffRole::Nurse->value,
                ClinicStaffRole::Assistant->value,
                ClinicStaffRole::Pharmacist->value,
            ]),
        ];
    }
}
