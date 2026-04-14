<?php

namespace App\Traits;

use App\Enums\AccountStatus;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

trait RegistersUsers
{
    /**
     * Extract the common user creation logic.
     */
    protected function createBaseUser(array $data, string $role)
    {
        return User::create([
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'gender' => $data['gender'],
            'birth_date' => $data['birth_date'],
            'governorate' => $data['governorate'],
            'national_id' => $data['national_id'],
            'password' => Hash::make($data['password']),
            'role' => $role,
            'account_status' => AccountStatus::Pending->value,
        ]);
    }
}
