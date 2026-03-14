<?php

namespace Database\Factories;

use App\Enums\AccountStatus;
use App\Enums\Gender;
use App\Enums\UserRole;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    public function definition(): array
    {
        return [
            'full_name' => fake()->name(),

            'email' => fake()->unique()->safeEmail(),

            'phone' => fake()->unique()->numerify('01#########'),

            // numerify() replaces '#' with random numbers. 14 digits is standard.
            'national_id' => fake()->unique()->numerify('##############'),

            'gender' => fake()->randomElement([Gender::Male->value, Gender::Female->value]),

            'birth_date' => fake()->dateTimeBetween('-60 years', '-18 years')->format('Y-m-d'),

            'governorate' => fake()->randomElement([
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

            // Your model's 'hashed' cast will automatically encrypt this!
            'password' => 'password',

            'role' => UserRole::Patient->value,

            'email_verified' => true, // Let's make our fake users already verified

            'account_status' => AccountStatus::Active->value,

            //            'remember_token' => Str::random(10),

        ];
    }


}
