<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Create the Workspace (Clinic)
        Schema::create('clinics', function (Blueprint $table) {
            $table->id();

            // Basic Info
            $table->string('clinic_name');
            $table->string('clinic_type');

            $table->string('clinic_phone');
            $table->string('clinic_address');
            $table->string('clinic_governorate');

            // Legal & Verification (MANDATORY)
            $table->string('license_number')->unique();
            $table->string('commercial_registration_number')->unique();
            $table->string('tax_id')->unique();

            // Verification Uploads
            $table->json('verification_documents')->nullable(); // Stores PDF paths
            $table->boolean('is_verified')->default(false);

            $table->timestamps();
        });

    }

    public function down(): void
    {
        Schema::dropIfExists('clinics');
    }
};
