<?php

namespace App\Http\Middleware;

use App\Enums\AccountStatus;
use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureAccountIsActive
{
    public function handle(Request $request, Closure $next): Response
    {
        /** @var User|null $user */
        $user = $request->user();

        // Check if the user exists and their account is NOT active
        if ($user && $user->account_status !== AccountStatus::Active) {

            // 1. API / FLUTTER HANDLING
            // If it's an API request, return a 403 JSON response
            if ($request->expectsJson() || $request->is('api/*')) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Your account is currently pending admin approval.',
                    'account_status' => $user->account_status->value ?? $user->account_status,
                ], 403);
            }

            // 2. WEB / INERTIA HANDLING
            // Allow them to see the 'waiting' page and logout, but nothing else
            if (! $request->is('waiting-approval') && ! $request->is('logout')) {
                return redirect()->route('waiting.approval');
            }
        }

        return $next($request);
    }
}
