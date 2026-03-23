<?php

namespace Database\Factories;

use App\Enums\UserRole;
use App\Models\Clinic;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Clinic>
 */
class ClinicFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'license_number' => fake()->unique()->randomNumber(6),
            'clinic_name' => fake()->company() . ' Clinic',
            'user_id' => User::factory()->create(['role' => UserRole::Clinic->value])->id,
            'clinic_address' => fake()->address(),
            'clinic_governorate' => fake()->randomElement([
                'alexandria', 'assiut', 'aswan', 'beheira', 'beni_suef', 'cairo',
                'daqahlia', 'damietta', 'fayoum', 'gharbia', 'giza', 'ismailia',
                'kafr_el_sheikh', 'luxor', 'matrouh', 'menoufia', 'minya', 'new_valley',
                'north_sinai', 'port_said', 'qalyubia', 'qena', 'red_sea', 'sharqia',
                'sohag', 'south_sinai', 'suez',
            ]),
            'clinic_phone' => fake()->unique()->numerify('01#########'),
            'clinic_type' => fake()->randomElement([
                'Dental', 'Orthopedic', 'Pediatric', 'Cardiology', 'General Practice',
                'Dermatology', 'Neurology', 'Ophthalmology', 'ENT', 'Psychiatry'
            ]),
            'commercial_registration_number' => fake()->unique()->numerify('######'),
            'tax_id' => fake()->unique()->numerify('######'),
            'verification_documents' => [
                'verification_documents/clinics/license_' . Str::random(10) . '.pdf',
                'verification_documents/clinics/tax_' . Str::random(10) . '.pdf',
                'verification_documents/clinics/commercial_reg_' . Str::random(10) . '.pdf',
            ],
        ];
    }
}
