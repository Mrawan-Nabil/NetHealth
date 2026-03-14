<?php

namespace Database\Factories;

use App\Enums\UserRole;
use App\Models\Pharmacy;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Pharmacy>
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
            'pharmacy_name' => fake()->company().' Pharmacy',
            'pharmacy_phone' => fake()->phoneNumber(),
            'pharmacy_address' => fake()->address(),
            'pharmacy_governorate' => fake()->randomElement([
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
            'tax_id' => fake()->numerify('######'),
            'verification_documents' => [],
        ];
    }
}
