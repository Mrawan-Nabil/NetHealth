<?php

namespace Database\Seeders;

use App\Enums\UserRole;
use App\Models\Appointment;
use App\Models\Doctor;
use App\Models\MedicalRecord;
use App\Models\Patient;
use App\Models\Pharmacy;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Create YOUR master admin account first.
        // We "override" the factory defaults by passing an array.
        User::factory()->create([
            'full_name' => 'Mrawan Nabil',
            'email' => 'mrawan@gmail.com',
            'phone' => '01093973915',
            'national_id' => '30503211205217',
            'role' => UserRole::Admin->value,
        ]);

        // 2. Create 5 dummy Doctors
        Doctor::factory(5)->create();

        Patient::factory(5)->create();

        // 3. Create 20 random Patients (Falls back to the Factory defaults)
        Patient::factory(20)->create();

        MedicalRecord::factory(20)->create();

        Pharmacy::factory(5)->create();

        Appointment::factory(20)->create();
    }
}
