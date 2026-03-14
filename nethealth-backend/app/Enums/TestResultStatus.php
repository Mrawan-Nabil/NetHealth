<?php

namespace App\Enums;

enum TestResultStatus: string
{
    case Pending = 'pending';
    case Reviewed = 'reviewed';
}
