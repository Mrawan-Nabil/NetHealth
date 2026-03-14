<?php

namespace App\Http\Requests\Patient;

use App\Enums\Gender;
use App\Rules\ValidNationalId;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

class UpdateProfileRequest extends FormRequest
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
            // users table
            'full_name' => 'required|string|max:255',
            'email' => 'required|email',
            'phone' => ['required', 'regex:/^\+?[0-9]{10,15}$/'],
            'national_id' => [
                'required',
                'unique:users,national_id',
                new ValidNationalId,
            ],
            'date_of_birth' => 'nullable|date',
            'gender' => ['required', new Enum(Gender::class)],
            'governorate' => 'nullable|string|max:100',

            // patient table
            'emergency_contact_name' => 'nullable|string|min:3',
            'emergency_contact_phone' => ['nullable', 'regex:/^\+?[0-9]{10,15}$/'],
            'emergency_contact_relationship' => 'nullable|string|max:50',
        ];
    }
}
