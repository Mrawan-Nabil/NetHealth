<?php

namespace App\Enums;

enum PharmacyStaffRole: string
{
    case Admin = 'admin';
    case Assistant = 'assistant';
    case Pharmacist = 'pharmacist';
}
