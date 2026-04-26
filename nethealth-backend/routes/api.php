<?php

use App\Http\Controllers\Api\Auth\ClinicRegistrationController;
use App\Http\Controllers\Api\Auth\DoctorRegistrationController;
use App\Http\Controllers\Api\Auth\PatientRegistrationController;
use App\Http\Controllers\Api\Auth\PharmacyRegistrationController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\Patient\DashboardApiController;
use App\Http\Controllers\Api\Patient\DoctorApiController;
use App\Http\Controllers\Api\Patient\PatientAppointmentApiController;
use App\Http\Controllers\Api\Patient\PatientPrescriptionApiController;
use App\Http\Controllers\Api\Patient\PatientTestResultApiController;
use App\Http\Controllers\Api\Patient\PatientImagingApiController;
use App\Http\Controllers\Api\Patient\PatientVisitHistoryApiController;
use App\Http\Controllers\Api\Patient\PatientNotificationApiController;
use App\Http\Controllers\Api\Patient\PatientProfileApiController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::prefix('v1')->group(function () {

    // =============================================
    // PUBLIC ROUTES (No token required)
    // =============================================
    Route::prefix('auth')->group(function () {
        // Login
        Route::post('/login', [AuthController::class, 'login']);

        // Registration
        Route::post('/register/patient', [PatientRegistrationController::class, 'store']);
        Route::post('/register/doctor', [DoctorRegistrationController::class, 'store']);
        Route::post('/register/clinic', [ClinicRegistrationController::class, 'store']);
        Route::post('/register/pharmacy', [PharmacyRegistrationController::class, 'store']);
    });

    // =============================================
    // PROTECTED ROUTES (Sanctum token required)
    // =============================================
    Route::middleware(['auth:sanctum'])->group(function () {

        // Auth management
        Route::prefix('auth')->group(function () {
            Route::get('/me', [AuthController::class, 'me']);
            Route::post('/logout', [AuthController::class, 'logout']);
        });

        // Common / Shared routes
        Route::get('/doctors', [DoctorApiController::class, 'index']);

        // ---------------------------------------------
        // PATIENT ROUTES
        // ---------------------------------------------
        // We add a role middleware check to ensure only patients can access these!
        Route::middleware(['role:patient', 'active'])->prefix('patient')->group(function () {

            // Profile
            Route::get('/profile', [PatientProfileApiController::class, 'show']);
            Route::patch('/profile', [PatientProfileApiController::class, 'update']);
            Route::post('/profile/avatar', [PatientProfileApiController::class, 'updateAvatar']);
            Route::post('/profile/password', [PatientProfileApiController::class, 'changePassword']);

            // We will add the Dashboard, Appointments, and Medical Records routes here next!
            Route::get('/dashboard', [DashboardApiController::class, 'index']);

            Route::get('/appointments', [PatientAppointmentApiController::class, 'index']);
            Route::get('/appointments/{id}', [PatientAppointmentApiController::class, 'show']);
            Route::delete('/appointments/{id}', [PatientAppointmentApiController::class, 'destroy']);
            Route::post('/appointments', [PatientAppointmentApiController::class, 'store']);

            // Medical Records
            Route::get('/prescriptions', [PatientPrescriptionApiController::class, 'index']);
            Route::get('/prescriptions/{id}', [PatientPrescriptionApiController::class, 'show']);

            Route::get('/test-results', [PatientTestResultApiController::class, 'index']);
            Route::get('/test-results/{id}', [PatientTestResultApiController::class, 'show']);

            Route::get('/imaging', [PatientImagingApiController::class, 'index']);
            Route::get('/imaging/{id}', [PatientImagingApiController::class, 'show']);

            Route::get('/visit-history', [PatientVisitHistoryApiController::class, 'index']);

            // Notifications (ghost — returns empty list until the feature is built)
            Route::get('/notifications', [PatientNotificationApiController::class, 'index']);
            Route::patch('/notifications/{id}/read', [PatientNotificationApiController::class, 'markAsRead']);
        });

        // (Future: You can add Doctor, Clinic, and Pharmacy route groups here later)
    });
});
