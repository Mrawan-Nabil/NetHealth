<?php

namespace Database\Seeders;

use App\Enums\UserRole;
use App\Models\Appointment;
use App\Models\Clinic;
use App\Models\Doctor;
use App\Models\MedicalRecord;
use App\Models\Patient;
use App\Models\Pharmacy;
use App\Models\Prescription;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Create YOUR master admin account first.
        User::factory()->create([
            'full_name' => 'Mrawan Nabil',
            'email' => 'mrawan@gmail.com',
            'phone' => '01093973915',
            'national_id' => '30503211205217',
            'role' => UserRole::Admin->value,
        ]);

        // 2. Infrastructure (Clinics & Pharmacies)
        Clinic::factory(5)->create();
        Pharmacy::factory(5)->create();

        // 3. Create 10 dummy Doctors (Automatically creates Users)
        Doctor::factory(10)->create();

        // 4. Create 50 random Patients (Automatically creates Users)
        Patient::factory(50)->create();

        // 5. Appointments
        $appointments = Appointment::factory(100)->create();

        // 6. Nested Data (Medical Records & Prescriptions)
        $completedAppointments = $appointments->random(60);

        foreach ($completedAppointments as $appointment) {
            $record = MedicalRecord::factory()->create([
                'appointment_id' => $appointment->id,
                'patient_id' => $appointment->patient_id,
                'doctor_id' => $appointment->doctor_id,
            ]);

            Prescription::factory(mt_rand(1, 3))->create([
                'medical_record_id' => $record->id,
            ]);
        }
    }
}
