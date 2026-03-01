<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\Enums\AccountStatus;
use App\Enums\Gender;
use App\Enums\UserRole;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasFactory, Notifiable;

    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    protected $fillable = [
        'full_name',
        'email',
        'phone',
        'gender',
        'birth_date',
        'governorate',
        'role',
        'is_verified',
        'account_status',
        'national_id',
        'password',
    ];
    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'gender' => Gender::class,
            'role' => UserRole::class,
            'account_status' => AccountStatus::class,
            'is_verified' => 'boolean',
            'birth_date' => 'date',
        ];
    }


    // One to One
    public function patient()
    {
        return $this->hasOne(Patient::class);
    }

    public function doctor()
    {
        return $this->hasOne(Doctor::class);
    }

    // Staff relations
    public function clinicStaff()
    {
        return $this->hasMany(ClinicStaff::class);
    }

    public function pharmacyStaff()
    {
        return $this->hasMany(PharmacyStaff::class);
    }
}
