<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pharmacies', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('pharmacy_name');
            $table->string('pharmacy_phone');
            $table->string('pharmacy_governorate');
            $table->string('pharmacy_address');
            $table->string('license_number')->unique();
            $table->string('commercial_registration_number')->unique();
            $table->string('tax_id')->unique();
            $table->boolean('is_verified')->default(false);

            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('updated_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
