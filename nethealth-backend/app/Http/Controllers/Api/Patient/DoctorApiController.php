<?php

namespace App\Http\Controllers\Api\Patient;

use App\Http\Controllers\Api\ApiController;
use App\Models\Doctor;
use Illuminate\Http\JsonResponse;

class DoctorApiController extends ApiController
{
    /**
     * Display a listing of doctors.
     */
    public function index(): JsonResponse
    {
        $doctors = \App\Models\User::where('role', \App\Enums\UserRole::Doctor)
            ->with(['clinic', 'doctor'])
            ->get()
            ->map(function ($user) {
                return [
                    'id' => $user->id,
                    'full_name' => $user->full_name,
                    'specialty' => $user->doctor?->specialty,
                    'avatar_url' => $user->avatar_url,
                    'professional_title' => $user->doctor?->professional_title,
                    'consultation_fee' => $user->doctor?->consultation_fee,
                    'experience' => $user->doctor?->experience,
                    'qualifications' => $user->doctor?->qualifications,
                    'clinic' => $user->clinic,
                ];
            });

        return response()->json([
            'status' => 'success',
            'data' => $doctors
        ]);
    }
}
