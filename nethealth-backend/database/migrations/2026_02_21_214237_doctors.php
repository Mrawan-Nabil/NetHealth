<?php

use App\Enums\ProfessionalTitle;
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
        Schema::create('doctors', function (Blueprint $table) {
            $table->foreignId('user_id')
                ->primary()
                ->constrained('users')
                ->cascadeOnDelete();
            $table->string('medical_license')->unique();
            $table->string('specialty');
            $table->string('professional_title')
                ->default(ProfessionalTitle::Resident->value);
            $table->string('syndicate_id')->unique();
            $table->unsignedInteger('consultation_fee')
                ->default(0);
            $table->text('experience')->nullable();
            $table->text('qualifications')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('updated_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('doctors');
    }
};
