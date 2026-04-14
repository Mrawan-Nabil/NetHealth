<?php

namespace App\Http\Requests\Patient;

use App\Enums\Gender;
use App\Rules\ValidNationalId;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Enum;

class UpdateProfileRequest extends FormRequest
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
        return [
            // users table
            'first_name' => 'required|string|max:100',
            'last_name' => 'required|string|max:100',
            'email' => 'required|email',
            'phone' => ['required', 'regex:/^\+?[0-9]{10,15}$/'],
            'national_id' => [
                'required',
                Rule::unique('users', 'national_id')->ignore($this->user()?->id),
                new ValidNationalId,
            ],
            'date_of_birth' => 'nullable|date',
            'gender' => ['required', new Enum(Gender::class)],
            'governorate' => 'nullable|string|max:100',
            'current_password' => 'nullable|string',
            'password' => 'nullable|string|min:8|confirmed',

            // patient table
            'emergency_contact_name' => 'nullable|string|min:3',
            'emergency_contact_phone' => ['nullable', 'regex:/^\+?[0-9]{10,15}$/'],
            'emergency_contact_relationship' => 'nullable|string|max:50',
        ];
    }
}
