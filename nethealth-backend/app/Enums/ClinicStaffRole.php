<?php

namespace App\Enums;

enum ClinicStaffRole: string
{
    case Admin = 'admin';
    case Receptionist = 'receptionist';
    case Nurse = 'nurse';
    case Assistant = 'assistant';
    case Pharmacist = 'pharmacist';
}
