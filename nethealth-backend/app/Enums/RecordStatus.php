<?php

namespace App\Enums;

enum RecordStatus: string
{
    case Open = 'open';
    case Closed = 'closed';
    case Archived = 'archived';
}
