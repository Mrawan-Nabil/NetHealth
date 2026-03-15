<?php

namespace Database\Seeders;

use App\Enums\UserRole;
use App\Models\Appointment;
use App\Models\Clinic;
use App\Models\ClinicStaff;
use App\Models\Diagnosis;
use App\Models\Doctor;
use App\Models\MedicalAttachment;
use App\Models\MedicalRecord;
use App\Models\Medicine;
use App\Models\Patient;
use App\Models\Pharmacy;
use App\Models\PharmacyStaff;
use App\Models\Prescription;
use App\Models\PrescriptionItem;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Tier 1 (Master Admin): Create 1 User with UserRole::Admin->value.
        User::factory()->create([
            'full_name' => 'Mrawan Nabil',
            'email' => 'mrawan@gmail.com',
            'phone' => '01093973915',
            'national_id' => '30503211205217',
            'role' => UserRole::Admin->value,
        ]);

        // Tier 2 (Base Profiles): Call the factories. Note: Inline User Creation handles roles.
        // Save to collection for later use.
        $doctors = Doctor::factory(5)->create();
        $patients = Patient::factory(20)->create();
        $pharmacies = Pharmacy::factory(5)->create();
        $clinics = Clinic::factory(5)->create();
        
        $medicines = Medicine::factory(20)->create();

        foreach ($clinics as $clinic) {
            ClinicStaff::factory(2)->create([
                'clinic_id' => $clinic->id,
            ]);
        }

        foreach ($pharmacies as $pharmacy) {
            PharmacyStaff::factory(2)->create([
                'pharmacy_id' => $pharmacy->id,
            ]);
        }

        // Tier 3 (Transactions): Create appointments.
        $appointments = [];
        for ($i = 0; $i < 20; $i++) {
            $appointments[] = Appointment::factory()->create([
                'patient_id' => $patients->random()->user_id,
                'doctor_id' => $doctors->random()->user_id,
                'clinic_id' => $clinics->random()->id,
            ]);
        }

        // Tier 4 (1-to-1 Nested Records): 
        // Avoid Factory Resolution Memory Trap on unique constraints by looping and assigning explicitly.
        foreach ($appointments as $appointment) {
            $medicalRecord = MedicalRecord::factory()->create([
                'appointment_id' => $appointment->id,
                'patient_id' => $appointment->patient_id,
                'doctor_id' => $appointment->doctor_id,
            ]);

            Diagnosis::factory(2)->create([
                'medical_record_id' => $medicalRecord->id,
            ]);

            MedicalAttachment::factory(1)->create([
                'medical_record_id' => $medicalRecord->id,
            ]);

            if (fake()->boolean(80)) {
                $prescription = Prescription::factory()->create([
                    'medical_record_id' => $medicalRecord->id,
                    'pharmacy_id' => $pharmacies->random()->id,
                ]);

                PrescriptionItem::factory(fake()->numberBetween(1, 4))->create([
                    'prescription_id' => $prescription->id,
                    'medicine_id' => $medicines->random()->id,
                ]);
            }
        }
    }
}
