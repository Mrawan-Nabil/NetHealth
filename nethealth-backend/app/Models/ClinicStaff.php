<?php

namespace App\Models;

use App\Enums\ClinicStaffRole;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ClinicStaff extends Model
{
    protected $fillable = [
        'clinic_id',
        'user_id',
        'staff_role',
    ];

    protected $casts = [
        'staff_role' => ClinicStaffRole::class,
    ];

    public function clinic(): BelongsTo
    {
        return $this->belongsTo(Clinic::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
