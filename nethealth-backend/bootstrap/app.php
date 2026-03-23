<?php

use App\Http\Middleware\CheckRole;
use App\Http\Middleware\EnsureAccountIsActive;
use App\Http\Middleware\HandleInertiaRequests;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Exceptions\PostTooLargeException;
use Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets;
use Illuminate\Http\Request;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {

        // 1. Append Global Web Middleware (Inertia goes here!)
        $middleware->web(append: [
            HandleInertiaRequests::class,
            AddLinkHeadersForPreloadedAssets::class,
        ]);

        // 2. Register Middleware Aliases
        $middleware->alias([
            'active' => EnsureAccountIsActive::class,
            'role' => CheckRole::class,
        ]);

        // 3. The Login Redirect (Points to our smart Traffic Controller)
        $middleware->redirectUsersTo(function () {
            return '/dashboard';
        });

    })
    ->withExceptions(function (Exceptions $exceptions) {
        $exceptions->renderable(function (PostTooLargeException $e, Request $request) {
            return back()->withErrors([
                'verification_documents' => 'The total size of the uploaded files exceeds the server limit. Please upload smaller files.',
            ]);
        });
    })
    ->create();
