<?php

use App\Enums\AccountStatus;
use App\Http\Controllers\Auth\ClinicController;
use App\Http\Controllers\Auth\DoctorController;
use App\Http\Controllers\Auth\PatientController;
use App\Http\Controllers\Auth\PharmacyController;
use App\Http\Controllers\Auth\SessionController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome');
})->name('test');

Route::get('/home', function () {
    return Inertia::render('Home');
})->name('home');

Route::get('/waiting-approval', function () {
    $user = auth()->user();

    $status = $user->account_status;
    $statusValue = $status instanceof AccountStatus ? $status->value : $status;

    if ($statusValue === AccountStatus::Active->value) {
        // pass the 'role' parameter here!
        return redirect()->route('dashboard', ['role' => $user->role]);
    }

    return Inertia::render('Auth/WaitingApproval');
})->name('waiting.approval')->middleware('auth');

Route::middleware('guest')->group(function () {

    Route::get('/login', [SessionController::class, 'create'])->name('login');
    Route::post('/login', [SessionController::class, 'store']);

    Route::get('/register', function () {
        return Inertia::render('RegisterRole');
    })->name('registerRole');

    Route::prefix('/register')->group(function () {

        Route::get('/patient', [PatientController::class, 'create'])->name('patientRegister');
        Route::post('/patient', [PatientController::class, 'store']);

        Route::get('/doctor', [DoctorController::class, 'create'])->name('doctorRegister');
        Route::post('/doctor', [DoctorController::class, 'store']);

        Route::get('/pharmacy', [PharmacyController::class, 'create'])->name('pharmacyRegister');
        Route::post('/pharmacy', [PharmacyController::class, 'store']);

        Route::get('/clinic', [ClinicController::class, 'create'])->name('clinicRegister');
        Route::post('/clinic', [ClinicController::class, 'store']);
    });

});

Route::middleware('auth')->group(function () {
    Route::get('/logout', [SessionController::class, 'destroy'])->name('logout');
});

Route::middleware(['auth', 'active'])->group(function () {
    //    Route::get('/dashboard/{role}', [PatientController::class, 'index'])->name('profile.show');
    //    Route::get('/dashboard/{role}/profile', [PatientController::class, 'show'])->name('profile.edit');
    //    Route::patch('/dashboard/{role}/profile', [PatientController::class, 'update'])->name('profile.update');
    // ... all other real features ...

    // ==========================================
    // PATIENT DASHBOARD ROUTES
    // ==========================================

    // Main Dashboard
    // Note: Make sure PatientController@index returns Inertia::render('PatientDashboard/Dashboard', [...]);
    Route::get('/dashboard/patient', [PatientController::class, 'index'])->name('dashboard.patient');

    // Profile Settings
    Route::get('/profile', [PatientController::class, 'show'])->name('profile.edit');
    Route::patch('/profile', [PatientController::class, 'update'])->name('profile.update');

    // Notifications
    Route::get('/notifications', function () {
        return Inertia::render('PatientDashboard/Notifications');
    })->name('notifications.index');

    // ==========================================
    // APPOINTMENTS MODULE
    // ==========================================

    Route::get('/appointments', function () {
        return Inertia::render('PatientDashboard/Appointments');
    })->name('appointments.index');

    Route::get('/appointments/create', function () {
        return Inertia::render('PatientDashboard/CreateAppointment');
    })->name('appointments.create');

    Route::get('/doctor/{id}', function ($id) {
        return Inertia::render('PatientDashboard/DoctorProfile');
    })->name('doctor.profile');

    // ==========================================
    // MEDICAL RECORDS MODULE
    // ==========================================

    // Main Medical Records Hub
    Route::get('/medical-records', function () {
        return Inertia::render('PatientDashboard/MedicalRecords');
    })->name('records.index');

    // Visit History
    Route::get('/visit-history', function () {
        return Inertia::render('PatientDashboard/VisitHistory');
    })->name('records.visit-history');

    // Prescriptions
    Route::get('/prescription/{id}', function ($id) {
        return Inertia::render('PatientDashboard/PrescriptionDetails', ['id' => $id]);
    })->name('records.prescription');

    // Test Results
    Route::get('/test-results', function () {
        return Inertia::render('PatientDashboard/TestResults');
    })->name('records.test-results.index');

    Route::get('/test-results/{id}', function ($id) {
        return Inertia::render('PatientDashboard/TestResultDetails', ['id' => $id]);
    })->name('records.test-results.show');

    // Imaging Records
    Route::get('/imaging', function () {
        return Inertia::render('PatientDashboard/ImagingRecords');
    })->name('records.imaging.index');

    Route::get('/imaging/{id}', function ($id) {
        return Inertia::render('PatientDashboard/ImagingDetail', ['id' => $id]);
    })->name('records.imaging.show');

});
