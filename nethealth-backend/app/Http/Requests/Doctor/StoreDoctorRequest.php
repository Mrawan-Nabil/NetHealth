<?php

namespace App\Http\Requests\Doctor;

use App\Http\Requests\Auth\RegisterRequest;
use App\Rules\ValidNationalId; // Added this import!
use Illuminate\Contracts\Validation\ValidationRule;
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
     * @return array<string, ValidationRule|array|string>
     */
    public function rules(): array
    {
        $registerRules = app(RegisterRequest::class)->rules();

        return array_merge($registerRules, [
            'national_id' => [
                'required',
                'unique:doctors,national_id',
                new ValidNationalId,
            ],
            'medical_license_number' => 'required|string|max:50|unique:doctors,medical_license',
            'specialty' => 'required|string|max:255',
            'experience' => 'nullable|string|max:255',
            'qualifications' => 'nullable|string|max:255',
            'verification_documents' => 'nullable|array',
            'verification_documents.*' => 'file|mimes:pdf,jpg,jpeg,png|max:10240', // Max 10MB
        ]);
    }
}
