<?php

namespace App\Http\Requests\Clinic;

use App\Enums\ClinicStaffRole;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Collection;
use Illuminate\Validation\Rules\Enum;

class StoreClinicStaffRequest extends FormRequest
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
            'clinic_id' => 'required|exists:clinics,id',
            'user_id' => 'required|exists:users,id',
            'staff_role' => ['required', new Enum(ClinicStaffRole::class)],
        ];
    }
}
