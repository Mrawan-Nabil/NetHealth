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
            'user_id' => User::factory()->create(['role' => UserRole::Clinic->value])->id,
            'license_number' => fake()->unique()->randomNumber(6),
            'clinic_name' => fake()->company().' Clinic',
            'clinic_address' => fake()->address(),
            'clinic_governorate' => fake()->randomElement([
                'alexandria',
                'assiut',
                'aswan',
                'beheira',
                'beni_suef',
                'cairo',
                'daqahlia',
                'damietta',
                'fayoum',
                'gharbia',
                'giza',
                'ismailia',
                'kafr_el_sheikh',
                'luxor',
                'matrouh',
                'menoufia',
                'minya',
                'new_valley',
                'north_sinai',
                'port_said',
                'qalyubia',
                'qena',
                'red_sea',
                'sharqia',
                'sohag',
                'south_sinai',
                'suez',
            ]),
            'clinic_phone' => fake()->phoneNumber(),
            'clinic_type' => fake()->word(),
            'commercial_registration_number' => fake()->numerify('######'),
            'tax_id' => fake()->numerify('######'),
            'verification_documents' => [],
        ];
    }
}
