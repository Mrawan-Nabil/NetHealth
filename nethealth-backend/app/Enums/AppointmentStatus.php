<?php

namespace App\Enums;

enum AppointmentStatus: string
{
    case Scheduled = 'Scheduled';
    case Cancelled = 'Cancelled';
    case Completed = 'Completed';

}
