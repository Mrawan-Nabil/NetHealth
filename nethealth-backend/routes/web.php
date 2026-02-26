<?php

use App\Http\Controllers\Auth\ClinicController;
use App\Http\Controllers\Auth\DoctorController;
use App\Http\Controllers\Auth\PatientController;
use App\Http\Controllers\Auth\PharmacyController;
use App\Http\Controllers\Auth\SessionController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome');
})->name('home');

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
