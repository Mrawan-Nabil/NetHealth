<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pharmacy extends Model
{
    protected $fillable = [
        'license_number',
        'is_verified',
        'user_id',
        'commercial_registration_number',
        'pharmacy_name',
        'pharmacy_phone',
        'pharmacy_address',
        'pharmacy_governorate',
        'tax_id',
    ];

    protected $casts = [
        'is_verified' => 'boolean',
    ];

    public function staff()
    {
        return $this->hasMany(PharmacyStaff::class);
    }

    public function prescriptions()
    {
        return $this->hasMany(Prescription::class);
    }
}
