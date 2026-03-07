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
        // Tell PhpStorm exactly which User model we are using!
        $user = auth()->user();

        // Now PhpStorm knows $user is YOUR model, and the warning goes away
        if ($user && $user->account_status !== AccountStatus::Active) {

            // Allow them to see the 'waiting' page and logout, but nothing else
            if (! $request->is('waiting-approval') && ! $request->is('logout')) {
                return redirect()->route('waiting.approval');
            }
        }

        return $next($request);
    }
}
