<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pharmacy extends Model
{
    use HasFactory;

    protected $fillable = [
        'license_number',
        'is_verified',
        'user_id',
        'commercial_registration_number',
        'pharmacy_name',
        'pharmacy_phone',
        'pharmacy_address',
        'pharmacy_governorate',
        'verification_documents',
        'tax_id',
        'verification_documents',
    ];


    protected $casts = [
        'verification_documents' => 'array',
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
