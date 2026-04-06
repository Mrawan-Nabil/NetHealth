<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Medicine extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'category',
        'strength',
    ];

    public $timestamps = false;
    public function prescriptionItems(): Medicine|\Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(PrescriptionItem::class);
    }
}
