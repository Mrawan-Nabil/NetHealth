<?php

use App\Enums\AccountStatus;
use App\Http\Controllers\Auth\ClinicController;
use App\Http\Controllers\Auth\DoctorController;
use App\Http\Controllers\Auth\PatientController;
use App\Http\Controllers\Auth\PharmacyController;
use App\Http\Controllers\Auth\SessionController;
use App\Http\Controllers\Patient\AppointmentController;
use App\Http\Controllers\Patient\DashboardController;
use App\Http\Controllers\Patient\ImagingController;
use App\Http\Controllers\Patient\MedicalRecordController;
use App\Http\Controllers\Patient\NotificationController;
use App\Http\Controllers\Patient\PrescriptionController;
use App\Http\Controllers\Patient\ProfileController;
use App\Http\Controllers\Patient\TestResultController;
use App\Http\Controllers\Patient\VisitHistoryController;
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
        $routeName = 'dashboard.'.strtolower($user->role->value);

        return redirect()->route($routeName);
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

    // ==========================================
    // THE TRAFFIC CONTROLLER (Fixes the login redirect crash)
    // ==========================================
    Route::get('/dashboard', function () {
        $user = auth()->user();

        $statusValue = $user->account_status instanceof AccountStatus
            ? $user->account_status->value
            : $user->account_status;

        if ($statusValue !== AccountStatus::Active->value) {
            return redirect()->route('waiting.approval');
        }

        return redirect()->route('dashboard.'.strtolower($user->role->value));

    })->name('dashboard'); // <-- Laravel requires this exact name by default!
});

// Combine all three middleware to perfectly secure the Patient Dashboard
Route::middleware(['auth', 'active', 'role:patient'])->group(function () {

    // ==========================================
    // PATIENT DASHBOARD ROUTES
    // ==========================================

    // Main Dashboard (Name MUST remain 'dashboard.patient' for the login redirect)
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // Profile Settings
    Route::get('/profile', [ProfileController::class, 'show'])->name('profile.edit');
    Route::patch('/profile/update', [ProfileController::class, 'update'])->name('profile.update');
    Route::post('/profile/avatar', [ProfileController::class, 'updateAvatar'])->name('profile.avatar.update');
    // Notifications
    Route::get('/notifications', [NotificationController::class, 'index'])->name('notifications.index');

    // ==========================================
    // APPOINTMENTS MODULE
    // ==========================================

    Route::get('/appointments', [AppointmentController::class, 'index'])->name('appointments.index');
    Route::get('/appointments/create', [AppointmentController::class, 'create'])->name('appointments.create');
    // Viewing the doctor's profile to book
    Route::get('/doctor/{id}', [AppointmentController::class, 'showDoctor'])->name('doctor.show');
    // Submitting the booking form
    Route::post('/appointments', [AppointmentController::class, 'store'])->name('appointments.store');

    // ==========================================
    // MEDICAL RECORDS MODULE
    // ==========================================

    Route::get('/medical-records', [MedicalRecordController::class, 'index'])->name('records.index');

    // Note: Kept as closure until you create a PrescriptionController
    Route::get('/prescription', [PrescriptionController::class, 'index'])->name('records.prescription');
    Route::get('/prescription/{id}', [PrescriptionController::class, 'show'])->name('records.prescription');

    // Test Results
    Route::get('/test-results', [TestResultController::class, 'index'])->name('records.test-results.index');
    Route::get('/test-results/{id}', [TestResultController::class, 'show'])->name('records.test-results.show');

    // Imaging Records
    Route::get('/imaging', [ImagingController::class, 'index'])->name('records.imaging.index');
    Route::get('/imaging/{id}', [ImagingController::class, 'show'])->name('records.imaging.show');

    Route::get('/visit-history', [VisitHistoryController::class, 'index'])->name('records.visit-history');

});
