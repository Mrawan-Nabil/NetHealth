<?php

namespace App\Http\Requests\Clinic;

use App\Http\Requests\Auth\RegisterRequest;
use App\Rules\ValidNationalId;
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
            'national_id' => [
                'required',
                'unique:users,national_id',
                new ValidNationalId,
            ],

            'clinic_name' => 'required|string|max:255|min:5',
            'license_number' => 'required|string|unique:clinics,license_number',
            'clinic_phone' => ['required', 'regex:/^\+?[0-9]{10,15}$/'],
            'clinic_address' => 'required|string|min:5|max:500',
            'clinic_governorate' => 'required|string',
        ]);
    }
}
