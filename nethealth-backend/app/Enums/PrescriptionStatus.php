<?php

namespace App\Enums;

enum PrescriptionStatus: string
{
    case Pending = 'Pending';
    case Issued = 'Issued';
    case Dispensed = 'Dispensed';
    case Cancelled = 'Cancelled';
}
