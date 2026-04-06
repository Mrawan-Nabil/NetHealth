<?php

use App\Enums\TestResultStatus;
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
        Schema::create('medical_attachments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('medical_record_id')
                ->constrained()
                ->cascadeOnDelete();
            $table->string('attachment_type');
            $table->string('attachment_name');
            $table->string('file_path');
            $table->string('mime_type');
            $table->string('test_result_status')->default(testResultStatus::Pending->value);
            $table->text('notes')->nullable();
            $table->foreignId('uploaded_by')->nullable()
                ->constrained('users')
                ->nullOnDelete();
            $table->timestamp('uploaded_at')->useCurrent();
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
