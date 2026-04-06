<?php

namespace App\Enums;

enum AttachmentType: string
{
    case Imaging = 'imaging';
    case Lab_Result = 'lab_result';
    case Clinical_Document = 'clinical_document';

    case Prescription = 'prescription';
}
