<?php

namespace App\Models;

use App\Enums\AttachmentType;
use App\Enums\TestResultStatus;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MedicalAttachment extends Model
{
    use HasFactory;

    const CREATED_AT = 'uploaded_at';
    const UPDATED_AT = null;
    /**
     * @var \Illuminate\Support\HigherOrderCollectionProxy|mixed
     */

    protected $fillable = [
        'medical_record_id',
        'attachment_type',
        'test_result_status',
        'notes',
        'file_path',
        'mime_type',
        'uploaded_by',
        'uploaded_at',
    ];

    protected $casts = [
        'test_result_status' => TestResultStatus::class,
        'attachment_type' => AttachmentType::class,
        'uploaded_at' => 'datetime',
    ];

    public function medicalRecord(): BelongsTo
    {
        return $this->belongsTo(MedicalRecord::class);
    }
}
