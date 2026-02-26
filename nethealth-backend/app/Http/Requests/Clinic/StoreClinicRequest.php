<?php

namespace App\Http\Requests\Clinic;

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
        return [
            'name' => 'required|string|max:255|min:5',
            'license_number' => 'required|string|unique:clinics,license_number',
            'phone' => ['required', 'regex:/^[0-9]{10,11}$/'],
            'address' => 'required|string|min:5|max:500',
            'governorate' => 'required|string',
        ];
    }
}
