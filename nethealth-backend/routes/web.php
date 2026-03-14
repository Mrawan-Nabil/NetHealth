<?php

use App\Enums\AccountStatus;
use App\Http\Controllers\Auth\ClinicController;
use App\Http\Controllers\Auth\DoctorController;
use App\Http\Controllers\Auth\PatientController;
use App\Http\Controllers\Auth\PharmacyController;
use App\Http\Controllers\Auth\SessionController;
use App\Http\Controllers\DashBoard\DashboardController;
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
    Route::get('/dashboard/{role}', [DashboardController::class, 'create'])->name('dashboard');
    // ... all other real features ...
});


Route::get('/dashboard', [PatientController::class, 'index'])->name('profile.show');
Route::get('/profile', [PatientController::class, 'show'])->name('profile.edit');
Route::patch('/profile', [PatientController::class, 'update'])->name('profile.update');
