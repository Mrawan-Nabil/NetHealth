<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Clinic extends Model
{
    use HasFactory;

    protected $fillable = [
        'license_number',
        'clinic_name',
        'user_id',
        'clinic_address',
        'clinic_governorate',
        'clinic_phone',
        'clinic_type',
        'commercial_registration_number',
        'tax_id',
        'verification_documents',
    ];

    protected $casts = [
        'verification_documents' => 'array',
    ];

    public function staff()
    {
        return $this->hasMany(ClinicStaff::class);
    }

    public function appointments()
    {
        return $this->hasMany(Appointment::class);
    }
}
