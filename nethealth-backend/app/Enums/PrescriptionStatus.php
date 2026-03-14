<?php

namespace App\Enums;

enum PrescriptionStatus: string
{
    case Pending = 'pending';
    case Issued = 'issued'; // latest prescription   // active status
    case Dispensed = 'dispensed'; // dispensed
    case Cancelled = 'cancelled';
}
