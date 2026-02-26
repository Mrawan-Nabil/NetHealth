<?php

namespace App\Http\Requests\Patient;

use App\Enums\BloodType;
use App\Http\Requests\Auth\RegisterRequest;
use App\Rules\ValidNationalId;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

class StorePatientRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $registerRules = app(RegisterRequest::class)->rules();

        return array_merge($registerRules, [
            'national_id' => [
                'required',
                'unique:patients,national_id',
                new ValidNationalId,
            ],
            'blood_type' => ['nullable', new Enum(BloodType::class)],
            'allergies' => 'nullable|string',
            'chronic_conditions' => 'nullable|string',
            'emergency_contact_name' => 'nullable|string|min:3',
            'emergency_contact_phone' => ['nullable', 'regex:/^\+?[0-9]{10,15}$/'],
        ]);
    }
}
