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
            'patient_id' => Patient::factory(),
            'doctor_id' => Doctor::factory(),
            'clinic_id' => Clinic::factory(),
            'appointment_time' => fake()->dateTimeBetween('-1 month', '+1 month'),
            'appointment_status' => fake()->randomElement([
                AppointmentStatus::Scheduled->value,
                AppointmentStatus::Cancelled->value,
                AppointmentStatus::Completed->value,
            ]),
            'appointment_type' => fake()->randomElement([
                AppointmentType::Physical->value,
                AppointmentType::Remote->value,
                AppointmentType::Emergency->value,
            ]),
            'visit_reason' => fake()->randomElement([
                'Routine checkup', 'Severe headache', 'Back pain', 'Follow-up visit', 'Vaccination', 'Cold symptoms'
            ]),
        ];
    }
}
