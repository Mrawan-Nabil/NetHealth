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
            $table->string('name');
            $table->string('phone');
            $table->string('address');
            $table->string('governorate');

            // Legal & Verification (MANDATORY)
            $table->string('license_number')->unique(); // MoH Clinic License
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
