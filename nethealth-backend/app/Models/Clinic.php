<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Clinic extends Model
{
    protected $fillable = [
        'license_number',
        'is_verified',
        'clinic_name',
        'user_id',
        'clinic_address',
        'clinic_governorate',
        'clinic_phone',
    ];

    protected $casts = [
        'is_verified' => 'boolean',
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
