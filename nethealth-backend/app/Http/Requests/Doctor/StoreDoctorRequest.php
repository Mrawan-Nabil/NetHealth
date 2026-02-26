<?php

namespace App\Http\Requests\Doctor;

use App\Http\Requests\Auth\RegisterRequest;
use Illuminate\Foundation\Http\FormRequest;

class StoreDoctorRequest extends FormRequest
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
            'medical_license' => 'required|string|max:50|unique:doctors,medical_license',
            'specialty' => 'required|string|max:255',
            'experience' => 'nullable|string|max:255',
            'qualifications' => 'nullable|string|max:255',
        ]);

    }
}
