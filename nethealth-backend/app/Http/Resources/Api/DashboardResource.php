<?php

namespace App\Http\Resources\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class DashboardResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'health_overview' => [
                'blood_type' => $this->patient->blood_type,
                'allergies' => $this->patient->allergies ?? [],
                'chronic_conditions' => $this->patient->chronic_conditions,
                'primary_doctor' => $this->primary_doctor ? [
                    'full_name' => 'Dr. '.$this->primary_doctor->user->full_name,
                    'specialty' => $this->primary_doctor->specialty,
                    'avatar_url' => $this->primary_doctor->user->avatar
                        ? Storage::disk('public')->url($this->primary_doctor->user->avatar)
                        : 'https://ui-avatars.com/api/?name='.urlencode($this->primary_doctor->user->full_name),
                ] : null,
            ],

            'stats' => $this->stats,

            'next_appointment' => $this->next_appointment ? [
                'id' => $this->next_appointment->id,
                'appointment_time' => $this->next_appointment->appointment_time->toIso8601String(),
                'appointment_type' => $this->next_appointment->appointment_type,
                'doctor' => [
                    'full_name' => 'Dr. '.$this->next_appointment->doctor->user->full_name,
                    'specialty' => $this->next_appointment->doctor->specialty,
                ],
                'clinic' => [
                    'id' => $this->next_appointment->clinic->id ?? null,
                    'clinic_name' => $this->next_appointment->clinic->clinic_name ?? 'Main Clinic',
                    'clinic_address' => $this->next_appointment->clinic->clinic_address ?? '',
                ],
            ] : null,

            'recent_records' => $this->recent_records->map(function ($record) {
                return [
                    'appointment_id' => $record->appointment_id,
                    'doctor_full_name' => 'Dr. '.$record->doctor->user->full_name,
                    'appointment_time' => $record->appointment ? $record->appointment->appointment_time->toIso8601String() : $record->created_at->toIso8601String(),
                    'status' => $record->record_status,
                ];
            }),
        ];
    }
}
