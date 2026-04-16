<?php

namespace App\Http\Controllers\Api;

use App\Models\User;
use Illuminate\Http\Request;

class DoctorApiController extends ApiController
{
    /**
     * Return all approved doctors for the booking flow.
     * Each entry contains the user + doctor profile data the Flutter
     * client needs to display the selection list.
     */
    public function index(Request $request)
    {
        $doctors = User::where('role', 'doctor')
            ->where('account_status', 'active')
            ->with('doctor') // eager-load the Doctor profile
            ->get()
            ->map(function (User $user) {
                $doctor = $user->doctor;

                return [
                    'id'                 => $user->id,
                    'full_name'          => $user->full_name,
                    'email'              => $user->email,
                    'avatar_url'         => $user->avatar_url ?? null,
                    'specialty'          => $doctor?->specialty ?? '',
                    'professional_title' => $doctor?->professional_title ?? 'dr',
                    'consultation_fee'   => $doctor?->consultation_fee ?? null,
                    'experience'         => $doctor?->experience ?? null,
                    'qualifications'     => $doctor?->qualifications ?? null,
                    'medical_license'    => $doctor?->medical_license ?? null,
                ];
            });

        return $this->successResponse($doctors, 'Doctors retrieved successfully.');
    }
}
