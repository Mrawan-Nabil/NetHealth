<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Clinic extends Model
{
    protected $fillable = [
        'name',
        'license_number',
        'phone',
        'address',
        'governorate',
        'is_verified',
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
