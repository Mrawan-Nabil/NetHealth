<?php

namespace App\Enums;

enum AppointmentType: string
{
    case Physical = 'physical';
    case Remote = 'remote';
    case Emergency = 'emergency';
}
