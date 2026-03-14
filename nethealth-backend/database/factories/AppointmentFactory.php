<?php

namespace Database\Factories;

use App\Enums\AppointmentStatus;
use App\Enums\AppointmentType;
use App\Models\Appointment;
use App\Models\Clinic;
use App\Models\Doctor;
use App\Models\Patient;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Appointment>
 */
class AppointmentFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'patient_id' => Patient::inRandomOrder()->value('user_id') ?? Patient::factory(),
            'doctor_id' => Doctor::inRandomOrder()->value('user_id') ?? Doctor::factory(),
            'clinic_id' => Clinic::inRandomOrder()->value('id') ?? Clinic::factory(),
            'appointment_time' => fake()->dateTimeBetween('now', '+1 month'),
            'appointment_status' => fake()->randomElement(AppointmentStatus::cases())->value,
            'appointment_type' => fake()->randomElement(AppointmentType::cases())->value,
            'visit_reason' => fake()->sentence(),
        ];
    }
}
