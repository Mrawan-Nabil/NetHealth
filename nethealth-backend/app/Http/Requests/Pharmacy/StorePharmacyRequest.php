<?php

namespace App\Http\Requests\Pharmacy;

use App\Http\Requests\Auth\RegisterRequest;
use App\Rules\ValidNationalId;
use Illuminate\Foundation\Http\FormRequest;

class StorePharmacyRequest extends FormRequest
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
            'pharmacy_name' => 'required|string|max:255|min:3',
            'license_number' => 'required|string|unique:pharmacies,license_number',
            'pharmacy_phone' => ['required', 'regex:/^\+?[0-9]{10,15}$/'],
            'pharmacy_address' => 'required|string|min:5|max:500',
            'pharmacy_governorate' => 'required|string',
            'commercial_registration_number' => 'required|string|unique:pharmacies,commercial_registration_number',
            'tax_id' => 'required|string|unique:pharmacies,tax_id',
        ]);
    }
}
