<?php

namespace App\Http\Requests\Doctor;

use App\Enums\ProfessionalTitle;
use App\Http\Requests\Auth\RegisterRequest;
// Added this import!
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

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
            'medical_license_number' => 'required|string|max:50|unique:doctors,medical_license',
            'specialty' => 'required|string|max:255',
            'professional_title' => ['required', new Enum(ProfessionalTitle::class)],
            'syndicate_id' => 'required|string|unique:doctors,syndicate_id|max:50',
            'consultation_fee' => 'required|integer|min:0',
            'experience' => 'nullable|string|max:255',
            'qualifications' => 'nullable|string|max:255',
            'verification_documents' => 'nullable|array',
            'verification_documents.*' => 'file|mimes:pdf,jpg,jpeg,png|max:10240',
        ]);
    }
}
