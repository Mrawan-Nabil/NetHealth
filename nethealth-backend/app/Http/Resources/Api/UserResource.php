<?php

namespace App\Http\Resources\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'full_name' => $this->full_name,
            'email' => $this->email,
            'role' => $this->role->value ?? $this->role,
            'account_status' => $this->account_status->value ?? $this->account_status,
            // Automatically resolve the full URL for the Flutter app
            'avatar_url' => $this->avatar
                ? (str_starts_with($this->avatar, 'http') ? $this->avatar : asset('storage/'.$this->avatar))
                : 'https://ui-avatars.com/api/?name='.urlencode($this->full_name).'&background=14B8A6&color=fff',
        ];
    }
}
