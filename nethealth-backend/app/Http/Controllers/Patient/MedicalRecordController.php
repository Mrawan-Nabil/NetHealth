<?php

namespace App\Http\Controllers\Patient;

use App\Http\Controllers\Controller;
use Inertia\Inertia;

class MedicalRecordController extends Controller
{
    public function index()
    {
        return Inertia::render('PatientDashboard/MedicalRecords', [
            'prescriptions',
            'notifications',
            'currentUser',

        ]);
    }
}
