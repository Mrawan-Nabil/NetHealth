<?php

namespace App\Http\Requests\Appointment;

use App\Enums\AppointmentStatus;
use App\Enums\AppointmentType;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

class StoreAppointmentRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'patient_id' => 'required|exists:patients,user_id',
            'doctor_id' => 'required|exists:doctors,user_id',
            'clinic_id' => 'required|exists:clinics,id',
            'appointment_time' => 'required|date|after:now',
            'appointment_status' => ['nullable',  new Enum(AppointmentStatus::class)], // pending
            'appointment_type' => ['required', new Enum(AppointmentType::class)],
            'visit_reason' => 'nullable|string',
        ];
    }
}
