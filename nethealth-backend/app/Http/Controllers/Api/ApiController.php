<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponse;

class ApiController extends Controller
{
    // This gives all API controllers access to successResponse(), errorResponse(), etc.
    use ApiResponse;

    protected function baseUserRules(): array
    {
        return [
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'phone' => 'required|string',
            'gender' => 'required|in:male,female',
            'birth_date' => 'required|date',
            'governorate' => 'required|string',
            'national_id' => 'required|string|unique:users',
        ];
    }
}
