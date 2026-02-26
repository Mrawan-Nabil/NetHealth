<?php

namespace App\Http\Requests\Auth;

use App\Enums\Gender;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

class RegisterRequest extends FormRequest
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
            'full_name' => 'required|string|max:255|min:8',
            'email' => 'required|email|unique:users,email',
            'phone' => ['required', 'regex:/^\+?[0-9]{10,15}$/', 'unique:users,phone'],
            'password' => 'required|string|min:8|confirmed',
            'gender' => ['required', new Enum(Gender::class)],
            'date_of_birth' => 'nullable|date|before:today',
            'governorate' => 'nullable|string|max:255',
        ];
    }
}
