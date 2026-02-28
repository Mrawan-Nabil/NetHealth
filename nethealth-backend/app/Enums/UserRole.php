<?php

namespace App\Enums;

enum UserRole: string
{
    case Patient = 'patient';

    case Doctor = 'doctor';
    case Clinic = 'clinicAdmin';
    case Pharmacy = 'pharmacyAdmin';
    case Admin = 'admin';
}
