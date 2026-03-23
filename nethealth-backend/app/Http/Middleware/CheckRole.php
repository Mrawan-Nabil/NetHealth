<?php

namespace App\Http\Middleware;

use App\Enums\UserRole;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $role): Response
    {
        $user = $request->user();

        // Safety check: Is the user even logged in?
        if (! $user) {
            return redirect()->route('login');
        }

        // Handle Enum casting if your model uses it
        $actualRole = $user->role instanceof UserRole ? $user->role->value : $user->role;

        // If the user's role doesn't match the route's required role, bounce them!
        if ($actualRole !== $role) {
            // Send them back to the smart traffic controller to route them correctly
            return redirect('/dashboard');
        }

        return $next($request);
    }
}
