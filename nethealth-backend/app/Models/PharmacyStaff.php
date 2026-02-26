<?php

namespace App\Models;

use App\Enums\PharmacyStaffRole;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PharmacyStaff extends Model
{
    protected $fillable = [
        'pharmacy_id',
        'user_id',
        'staff_role',
    ];

    protected $casts = [
        'staff_role' => PharmacyStaffRole::class,
    ];

    public function pharmacy(): BelongsTo
    {
        return $this->belongsTo(Pharmacy::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
