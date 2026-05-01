<?php

namespace App\Http\Resources\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class PatientProfileResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $user = $this->user;

        return [
            'full_name' => $user->full_name,
            'email' => $user->email,
            'phone' => $user->phone,
            'national_id' => $user->national_id,
            'gender' => $user->gender->value ?? $user->gender,
            'birth_date' => $user->birth_date ? $user->birth_date->format('Y-m-d') : null,
            'governorate' => $user->governorate,
            'blood_type' => $this->blood_type->value ?? $this->blood_type,
            'allergies' => $this->allergies ?? [],
            'chronic_conditions' => $this->chronic_conditions,
            'emergency_contact' => [
                'name' => $this->emergency_contact_name,
                'phone' => $this->emergency_contact_phone,
                'relationship' => $this->emergency_contact_relationship,
            ],
            'avatar_url' => $user->avatar
                ? (str_starts_with($user->avatar, 'http') ? $user->avatar : asset('storage/' . $user->avatar))
                : 'https://ui-avatars.com/api/?name=' . urlencode($user->full_name) . '&background=14B8A6&color=fff',
        ];
    }
}
