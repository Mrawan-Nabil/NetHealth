<?php

namespace App\Http\Requests\Prescription;

use App\Enums\PrescriptionStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

class StorePrescriptionRequest extends FormRequest
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
            'medical_record_id' => 'required|exists:medical_records,id',
            'pharmacy_id' => 'nullable|exists:pharmacies,id',
            'prescription_status' => ['required', new Enum(PrescriptionStatus::class)],
            'notes' => 'nullable|string',
        ];
    }
}
