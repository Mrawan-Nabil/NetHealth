<?php

namespace App\Models;

use Database\Factories\DoctorFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
class Doctor extends Model
{
    /** @use HasFactory<DoctorFactory> */
    use HasFactory, Notifiable;

    protected $primaryKey = 'user_id';

    public $incrementing = false;

    protected $fillable = [
        'user_id',
        'medical_license',
        'specialty',
        'professional_title',
        'syndicate_id',
        'consultation_fee',
        'experience',
        'qualifications',
        'syndicate_id',
        'verification_documents',
    ];

    protected $casts = [
        'verification_documents' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function appointments()
    {
        // Explicitly define the foreign key (doctor_id) and local key (user_id)
        return $this->hasMany(Appointment::class, 'doctor_id', 'user_id');
    }

    public function medicalRecords()
    {
        // Explicitly define the foreign key and local key here as well
        return $this->hasMany(MedicalRecord::class, 'doctor_id', 'user_id');
    }
}
