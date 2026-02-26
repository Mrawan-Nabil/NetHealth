<?php

namespace App\Http\Requests\MedicalRecord;

use App\Enums\RecordStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

class StoreMedicalRecordRequest extends FormRequest
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
            'appointment_id' => 'required|exists:appointments,id|unique:medical_records,appointment_id',
            'patient_id' => 'required|exists:patients,user_id',
            'doctor_id' => 'required|exists:doctors,user_id',
            'diagnosis_notes' => 'nullable|string',
            'record_status' => ['required', new Enum(RecordStatus::class)],
        ];
    }
}
