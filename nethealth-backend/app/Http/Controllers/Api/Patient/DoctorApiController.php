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
        $doctors = Doctor::with(['user:id,full_name,avatar'])
            ->get()
            ->map(function ($doctor) {
                return [
                    'id' => $doctor->user_id,
                    'full_name' => $doctor->user->full_name,
                    'specialty' => $doctor->specialty,
                    'avatar_url' => $doctor->user->avatar_url,
                    'professional_title' => $doctor->professional_title,
                    'consultation_fee' => $doctor->consultation_fee,
                    'experience' => $doctor->experience,
                    'qualifications' => $doctor->qualifications,
                ];
            });

        return response()->json([
            'status' => 'success',
            'data' => $doctors
        ]);
    }
}
