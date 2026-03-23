<?php

namespace Database\Factories;

use App\Enums\UserRole;
use App\Models\Pharmacy;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Pharmacy>
 */
class PharmacyFactory extends Factory
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
            'user_id' => User::factory()->create(['role' => UserRole::Pharmacy->value])->id,
            'commercial_registration_number' => fake()->unique()->numerify('######'),
            'pharmacy_name' => fake()->company() . ' Pharmacy',
            'pharmacy_phone' => fake()->unique()->numerify('01#########'),
            'pharmacy_address' => fake()->address(),
            'pharmacy_governorate' => fake()->randomElement([
                'alexandria', 'assiut', 'aswan', 'beheira', 'beni_suef', 'cairo',
                'daqahlia', 'damietta', 'fayoum', 'gharbia', 'giza', 'ismailia',
                'kafr_el_sheikh', 'luxor', 'matrouh', 'menoufia', 'minya', 'new_valley',
                'north_sinai', 'port_said', 'qalyubia', 'qena', 'red_sea', 'sharqia',
                'sohag', 'south_sinai', 'suez',
            ]),
            'tax_id' => fake()->unique()->numerify('######'),
            'verification_documents' => [
                'verification_documents/pharmacies/license_' . Str::random(10) . '.pdf',
                'verification_documents/pharmacies/tax_' . Str::random(10) . '.pdf',
                'verification_documents/pharmacies/commercial_reg_' . Str::random(10) . '.pdf',
            ],
        ];
    }
}
