<?php

namespace App\Http\Controllers\Auth;

use App\Enums\AccountStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\Request;
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
        //        dd('is working');
        if (Auth::user()->account_status !== AccountStatus::Active) {
            return redirect()->route('waiting.approval');
        }

        return redirect()->route('dashboard', ['role' => Auth::user()->role])
            ->with('success', 'Welcome to your dashboard!');
    }

    public function destroy(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('home');
    }
}
