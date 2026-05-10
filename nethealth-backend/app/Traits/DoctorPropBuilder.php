<?php

namespace App\Traits;

use App\Models\User;

trait DoctorPropBuilder
{
    use AvatarResolver;
    /**
     * Builds the standard 'doctor' prop object expected by Inertia.
     */
    protected function buildDoctorProp(User $user): array
    {
        // Eager load the clinic relationship to prevent N+1 database queries
        $user->loadMissing('clinic');

        // Extract a short first name for the 'name' property
        $firstName = explode(' ', $user->full_name)[0] ?? 'Doctor';

        return [
            'id' => $user->id,
            'name' => 'Dr. '.$firstName,
            'fullName' => $user->full_name,
            'handle' => '@'.($user->username ?? strtolower($firstName).$user->id),
            'avatar' => $user->avatar ?? $this->resolveAvatarUrl(
                $user->avatar,
                $user->full_name ?? 'Doctor',
                '14B8A6'
            ),
            // Nested Clinic Object
            'clinic' => $user->clinic ? [
                'name' => $user->clinic->clinic_name, // adjust to match your db column (e.g., 'name')
                'address' => $user->clinic->clinic_address, // adjust to match your db column (e.g., 'address')
            ] : null,
        ];
    }
}
