<?php

namespace App\Enums;

enum ProfessionalTitle: string
{
    case Resident = 'resident';
    case Specialist = 'specialist';
    case Consultant = 'consultant';
    case Professor = 'professor';
}
