<?php

namespace Database\Factories;

use App\Enums\ProfessionalTitle;
use App\Enums\UserRole;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Doctor>
 */
class DoctorFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory()->create(['role' => UserRole::Doctor->value])->id,

            'medical_license' => fake()->unique()->randomNumber(6),
            'specialty' => fake()->randomElement([
                'cardiology',
                'dermatology',
                'neurology',
                'orthopedics',
                'pediatrics',
                'psychiatry',
                'radiology',
                'anesthesiology',
                'general_surgery',
                'internal_medicine',
                'family_medicine',
                'obstetrics_gynecology',
                'ophthalmology',
                'ent',
                'urology',
                'gastroenterology',
                'endocrinology',
                'pulmonology',
                'nephrology',
                'oncology',
                'hematology',
                'rheumatology',
                'infectious_disease',
                'emergency_medicine',
                'plastic_surgery',
                'neurosurgery',
                'cardiothoracic_surgery',
                'vascular_surgery',
                'pathology',
                'nuclear_medicine',
            ]),
            'professional_title' => fake()->randomElement([
                ProfessionalTitle::Consultant->value,
                ProfessionalTitle::Professor->value,
                ProfessionalTitle::Resident->value,
                ProfessionalTitle::Specialist->value]),
            'syndicate_id' => fake()->unique()->randomNumber(6),
            'consultation_fee' => fake()->numberBetween(1, 9999999),
            'experience' => fake()->randomElement([
                'Experienced physician with several years of practice in diagnosing and treating a wide range of medical conditions. Dedicated to providing patient-centered care and maintaining high professional standards.',

                'Skilled medical specialist with strong clinical experience in hospital and outpatient settings. Known for accurate diagnosis and effective treatment planning.',

                'Committed healthcare professional with extensive experience managing diverse patient cases. Focuses on delivering high-quality medical care and building trust with patients.',

                'Doctor with solid clinical background and experience working in multidisciplinary medical teams. Passionate about improving patient outcomes and staying updated with medical advancements.',

                'Compassionate physician experienced in treating patients with complex medical conditions. Emphasizes preventive care and clear communication with patients.',

                'Medical professional with strong expertise in clinical evaluation, treatment planning, and patient follow-up. Dedicated to continuous learning and evidence-based practice.',
            ]),
            'qualifications' => 'MBBS, '.fake()->randomElement([
                'MD',
                'MSc',
                'MD, PhD',
                'Diploma in Clinical Medicine',
                'Fellowship in Specialized Medicine',
                'MD (Internal Medicine)',
                'MD (Cardiology)',
                'MD (Dermatology)',
                'MD (Pediatrics)',
                'MD (Neurology)',
                'MD (Orthopedics)',
                'MS (General Surgery)',
                'MS (Orthopedic Surgery)',
                'MD (Radiology)',
                'MD (Anesthesiology)',
                'DNB',
                'DNB, Fellowship',
                'MSc (Public Health)',
                'Diploma in Emergency Medicine',
                'Fellowship in Cardiology',
                'Fellowship in Gastroenterology',
                'Fellowship in Endocrinology',
                'MD, Fellowship in Advanced Clinical Practice',
            ]),
            'verification_documents' => [
                'verification_documents/doctors/fake_license_'.Str::random(10).'.pdf',
                'verification_documents/doctors/fake_id_'.Str::random(10).'.jpg',
                'verification_documents/doctors/fake_MBBS_'.Str::random(10).'.pdf',
                'verification_documents/doctors/fake_specialization_'.Str::random(10).'.pdf',
            ],
        ];
    }
}
