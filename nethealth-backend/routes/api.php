<?php

use App\Http\Controllers\Api\Auth\ClinicRegistrationController;
use App\Http\Controllers\Api\Auth\DoctorRegistrationController;
use App\Http\Controllers\Api\Auth\PatientRegistrationController;
use App\Http\Controllers\Api\Auth\PharmacyRegistrationController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\Patient\DashboardApiController;
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

        // ---------------------------------------------
        // DOCTORS — available to any authenticated user (for booking flow)
        // ---------------------------------------------
        Route::get('/doctors', [\App\Http\Controllers\Api\DoctorApiController::class, 'index']);

        // ---------------------------------------------
        // PATIENT ROUTES
        // ---------------------------------------------
        // We add a role middleware check to ensure only patients can access these!
        Route::middleware(['role:patient', 'active'])->prefix('patient')->group(function () {

            // Dashboard
            Route::get('/dashboard', [DashboardApiController::class, 'index']);

            // Appointments — index, store, destroy
            Route::get('/appointments',         [\App\Http\Controllers\Api\Patient\PatientAppointmentApiController::class, 'index']);
            Route::post('/appointments',        [\App\Http\Controllers\Api\Patient\PatientAppointmentApiController::class, 'store']);
            Route::delete('/appointments/{id}', [\App\Http\Controllers\Api\Patient\PatientAppointmentApiController::class, 'destroy']);

        });

        // (Future: You can add Doctor, Clinic, and Pharmacy route groups here later)
    });
});
