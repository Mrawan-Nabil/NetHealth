<?php

namespace App\Http\Requests\Clinic;

use App\Http\Requests\Auth\RegisterRequest;
use Illuminate\Foundation\Http\FormRequest;

class StoreClinicRequest extends FormRequest
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

            'clinic_name' => 'required|string|max:255|min:5',
            'clinic_type' => ['required', 'string', 'in:single_specialty,polyclinic,specialized_center'],
            'license_number' => 'required|string|unique:clinics,license_number',
            'clinic_phone' => ['required', 'regex:/^\+?[0-9]{10,15}$/'],
            'clinic_address' => 'required|string|min:5|max:500',
            'clinic_governorate' => 'required|string',
            'commercial_registration_number' => 'required|string|unique:clinics,commercial_registration_number',
            'tax_id' => 'required|string|unique:pharmacies,tax_id',
            'verification_documents' => 'nullable|array',
            'verification_documents.*' => 'file|mimes:pdf,jpg,jpeg,png|max:10240',
        ]);
    }
}
