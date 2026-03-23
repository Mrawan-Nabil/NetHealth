<?php

namespace App\Models;

use App\Enums\AppointmentStatus;
use App\Enums\AppointmentType;
use Database\Factories\AppointmentFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Notifications\Notifiable;

class Appointment extends Model
{
    /** @use HasFactory<AppointmentFactory> */
    use HasFactory, Notifiable;

    protected $fillable = [
        'patient_id',
        'doctor_id',
        'clinic_id',
        'appointment_time',
        'appointment_status',
        'appointment_type',
        'visit_reason',
    ];

    protected $casts = [
        'appointment_status' => AppointmentStatus::class,
        'appointment_type' => AppointmentType::class,
        'appointment_time' => 'datetime',
    ];

    public function patient(): BelongsTo
    {
        return $this->belongsTo(Patient::class);
    }

    public function doctor(): BelongsTo
    {
        return $this->belongsTo(Doctor::class, 'doctor_id');
    }

    public function clinic(): BelongsTo
    {
        return $this->belongsTo(Clinic::class);
    }

    public function medicalRecord(): HasOne
    {
        return $this->hasOne(MedicalRecord::class);
    }
}
