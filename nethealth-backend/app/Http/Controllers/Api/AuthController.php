<?php

namespace App\Http\Controllers\Api;

use App\Http\Resources\Api\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends ApiController // it extends ApiController!
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            return $this->errorResponse('The provided credentials are incorrect.', null, 401);
        }

        // If suspended, reject immediately
        $status = $user->account_status->value ?? $user->account_status;
        if ($status === 'suspended') {
            return $this->errorResponse('Your account has been suspended. Please contact support.', null, 403);
        }

        $token = $user->createToken('flutter-app')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Logged in successfully',
            'token' => $token,
            'token_type' => 'Bearer',
            // Send the user data through our new strict Resource filter
            'user' => new UserResource($user),
        ]);
    }

    public function me(Request $request)
    {
        // Load the patient relationship just in case the app needs it later
        $user = $request->user()->load('patient');

        return $this->successResponse(
            new UserResource($user),
            'Profile retrieved successfully'
        );
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return $this->successResponse(null, 'Logged out successfully');
    }
}
