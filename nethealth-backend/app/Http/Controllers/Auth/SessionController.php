<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class SessionController extends Controller
{
    public function create()
    {
        return Inertia::render('Login');
    }

    public function store(LoginRequest $request)
    {
        $credentials = $request->validated();

        // The second argument 'true' tells Laravel to set a long-lived cookie
        if (! Auth::attempt($credentials, $request->boolean('rememberMe'))) {
            return back()->withErrors([
                'email' => 'Invalid email or password.',
            ]);
        }

        $request->session()->regenerate();
        return redirect()->route('home')->with('success', 'You are now logged in!');
    }

    public function destroy()
    {
        Auth::logout();

        return redirect()->route('home');
    }
}
