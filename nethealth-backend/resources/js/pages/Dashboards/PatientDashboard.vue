<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { computed } from 'vue';
import netHealthLogo3 from '../../assets/logo3.png';

// Access the data we passed from the controller
const page = usePage();
const userData = computed(() => page.props.userData || {});

const handleLogout = () => {
    // Standard Laravel logout must be a POST request
    router.post('/logout');
};
</script>

<template>
    <Head title="Patient Dashboard" />

    <div class="flex h-screen bg-[#F8FAFC] font-sans text-slate-900">
        <aside class="flex w-64 shrink-0 flex-col justify-between border-r border-slate-200 bg-white md:flex">
            <div>
                <div class="flex h-20 items-center gap-2 px-8 text-xl font-bold text-emerald-500">
                    <Link href="/home" class="heart-pulse-hover flex shrink-0 items-center gap-2 transition-transform duration-300 hover:scale-105">
                        <img
                            :src="netHealthLogo3"
                            alt="NetHealth Logo"
                            class="mb-2 h-16 w-16"
                            style="width: 155px; height: 150px; margin-bottom: -50px; margin-top: -50px"
                        />
                    </Link>
                </div>

                <div class="px-6 py-4">
                    <div class="relative">
                        <svg class="absolute top-3 left-3 h-4 w-4 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                            ></path>
                        </svg>
                        <input
                            type="text"
                            placeholder="Search"
                            class="w-full rounded-full border border-emerald-400 bg-white py-2 pr-4 pl-9 text-sm text-emerald-600 placeholder-emerald-400 focus:ring-1 focus:ring-emerald-500 focus:outline-none"
                        />
                    </div>
                </div>

                <nav class="mt-2 space-y-1 px-4">
                    <div class="mb-2 px-4 text-xs font-semibold tracking-wider text-slate-400 uppercase">General</div>

                    <Link
                        href="#"
                        class="flex items-center gap-3 rounded-xl bg-emerald-50 px-4 py-3 text-sm font-medium text-emerald-600 transition-colors"
                    >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
                            ></path>
                        </svg>
                        Home
                    </Link>
                    <Link
                        href="#"
                        class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-medium text-slate-500 transition-colors hover:bg-slate-50"
                    >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                            ></path>
                        </svg>
                        Profile
                    </Link>
                    <Link
                        href="#"
                        class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-medium text-slate-500 transition-colors hover:bg-slate-50"
                    >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                            ></path>
                        </svg>
                        Medical Record
                    </Link>
                    <Link
                        href="#"
                        class="flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-medium text-slate-500 transition-colors hover:bg-slate-50"
                    >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                            ></path>
                        </svg>
                        Appointments
                    </Link>
                </nav>
            </div>

            <div class="space-y-6 border-t border-slate-100 px-6 py-6">
                <button
                    @click="handleLogout"
                    class="flex w-full items-center gap-3 px-2 text-left text-sm font-medium text-red-500 transition-colors hover:text-red-600"
                >
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
                        ></path>
                    </svg>
                    Logout
                </button>
            </div>
        </aside>

        <main class="flex flex-1 flex-col overflow-hidden">
            <header class="flex h-20 shrink-0 items-center justify-between border-b border-slate-200 bg-white px-8">
                <h2 class="text-xl font-bold text-slate-800">Home</h2>

                <div class="flex items-center gap-6">
                    <button class="relative p-2 text-slate-400 transition hover:text-slate-600">
                        <svg class="h-6 w-6 rounded-full border border-slate-200 p-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                            ></path>
                        </svg>
                        <span
                            class="absolute top-0 right-0 flex h-4 w-4 items-center justify-center rounded-full border-2 border-white bg-red-500 text-[10px] font-bold text-white"
                            >3</span
                        >
                    </button>

                    <div class="flex cursor-pointer items-center gap-3 border-l border-slate-200 pl-4">
                        <img :src="userData.avatar" alt="Avatar" class="h-9 w-9 rounded-full object-cover shadow-sm" />
                        <div class="hidden text-left md:block">
                            <p class="text-sm leading-tight font-semibold text-slate-800">{{ userData.fullName }}</p>
                            <p class="text-xs text-slate-400">{{ userData.handle }}</p>
                        </div>
                    </div>
                </div>
            </header>

            <div class="flex-1 overflow-auto p-8">
                <div class="mb-8">
                    <h1 class="flex items-center gap-2 text-3xl font-bold text-slate-900">
                        Welcome back, {{ userData.name }} <span class="text-2xl">👋</span>
                    </h1>
                    <p class="mt-1 text-slate-500">Here's your health overview for today.</p>
                </div>

                <div class="mb-8 grid grid-cols-1 gap-6 md:grid-cols-4">
                    <div class="grid grid-cols-1 gap-6 md:col-span-3 md:grid-cols-2">
                        <div class="flex items-center justify-between rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                            <div>
                                <h3 class="text-3xl font-bold text-slate-800">3</h3>
                                <p class="mt-1 text-sm text-slate-500">Upcoming Appointments</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 text-emerald-500">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                                    ></path>
                                </svg>
                            </div>
                        </div>

                        <div class="flex items-center justify-between rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
                            <div>
                                <h3 class="text-3xl font-bold text-slate-800">1</h3>
                                <p class="mt-1 text-sm text-slate-500">Latest Prescription</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-orange-50 text-orange-400">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"
                                    ></path>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="flex flex-col justify-between rounded-3xl bg-linear-to-br from-emerald-400 to-teal-500 p-6 text-white shadow-lg">
                        <div>
                            <h3 class="mb-2 text-lg font-semibold">Need Help?</h3>
                            <p class="mb-4 text-sm leading-relaxed text-emerald-50">
                                Ask our AI Medical Assistant for quick answers about your health.
                            </p>
                        </div>
                        <button class="w-full rounded-xl bg-white py-2 font-semibold text-emerald-600 transition hover:bg-emerald-50">Ask Now</button>
                    </div>
                </div>

                <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
                    <div class="space-y-8 lg:col-span-2">
                        <section class="rounded-3xl border border-slate-100 bg-white p-6 shadow-sm">
                            <h3 class="mb-6 text-lg font-bold text-slate-800">Next Appointment</h3>

                            <div class="flex items-start justify-between">
                                <div class="flex gap-4">
                                    <img
                                        src="https://ui-avatars.com/api/?name=Sarah+Johnson&background=random"
                                        alt="Doctor"
                                        class="h-12 w-12 rounded-full object-cover"
                                    />
                                    <div>
                                        <h4 class="font-bold text-slate-800">Dr. Sarah Johnson</h4>
                                        <p class="text-sm text-slate-500">Cardiologist</p>
                                        <p class="mt-1 text-sm text-slate-500">Tomorrow, 2:30 PM</p>
                                        <p class="text-sm text-slate-500">City Medical Center</p>
                                    </div>
                                </div>
                                <div class="flex flex-col items-end gap-3">
                                    <span class="rounded-full bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-600">Confirmed</span>
                                    <div class="mt-4 flex gap-2">
                                        <button
                                            class="rounded-xl bg-emerald-500 px-4 py-2 text-sm font-medium text-white transition hover:bg-emerald-600"
                                        >
                                            View Details
                                        </button>
                                        <button
                                            class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-600 transition hover:bg-slate-50"
                                        >
                                            Reschedule
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="rounded-3xl border border-slate-100 bg-white p-6 shadow-sm">
                            <div class="mb-6 flex items-center justify-between">
                                <h3 class="text-lg font-bold text-slate-800">Recent Medical Records</h3>
                                <Link href="#" class="text-sm font-medium text-emerald-500 hover:underline">View Full Records</Link>
                            </div>

                            <div class="space-y-4">
                                <div
                                    class="flex cursor-pointer items-center justify-between rounded-2xl bg-slate-50 p-4 transition hover:bg-slate-100"
                                >
                                    <div class="flex items-center gap-4">
                                        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-orange-100 text-orange-400">
                                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-linejoin="round"
                                                    stroke-width="2"
                                                    d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"
                                                ></path>
                                            </svg>
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-slate-800">Latest Prescription</h4>
                                            <p class="text-xs text-slate-500">Dr. Michael Chen • Jan 20, 2025</p>
                                        </div>
                                    </div>
                                    <span class="text-sm font-medium text-emerald-500">Active</span>
                                </div>

                                <div
                                    class="flex cursor-pointer items-center justify-between rounded-2xl bg-slate-50 p-4 transition hover:bg-slate-100"
                                >
                                    <div class="flex items-center gap-4">
                                        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-100 text-blue-500">
                                            <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                                                <path
                                                    fill-rule="evenodd"
                                                    d="M7 2a1 1 0 00-.707 1.707L7 4.414v3.758a1 1 0 01-.293.707l-4 4C.817 14.769 2.156 18 4.828 18h10.343c2.673 0 4.012-3.231 2.122-5.121l-4-4A1 1 0 0113 8.172V4.414l.707-.707A1 1 0 0013 2H7zm2 6.172V4h2v4.172a3 3 0 00.879 2.12l1.027 1.028a4 4 0 00-2.171.102l-.47.156a4 4 0 01-2.53 0l-.563-.187a1.993 1.993 0 00-.114-.035l1.063-1.063A3 3 0 009 8.172z"
                                                    clip-rule="evenodd"
                                                ></path>
                                            </svg>
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-slate-800">Blood Test Results</h4>
                                            <p class="text-xs text-slate-500">Lab Services • Jan 18, 2025</p>
                                        </div>
                                    </div>
                                    <span class="text-sm font-medium text-blue-500">Available</span>
                                </div>

                                <div
                                    class="flex cursor-pointer items-center justify-between rounded-2xl bg-slate-50 p-4 transition hover:bg-slate-100"
                                >
                                    <div class="flex items-center gap-4">
                                        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-emerald-100 text-emerald-500">
                                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-linejoin="round"
                                                    stroke-width="2"
                                                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                                                ></path>
                                            </svg>
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-slate-800">Visit Summary</h4>
                                            <p class="text-xs text-slate-500">Dr. Sarah Johnson • Jan 15, 2025</p>
                                        </div>
                                    </div>
                                    <span class="text-sm font-medium text-slate-500">Completed</span>
                                </div>
                            </div>
                        </section>
                    </div>

                    <div class="space-y-8">
                        <section class="rounded-3xl border border-slate-100 bg-white p-6 shadow-sm">
                            <h3 class="mb-6 text-lg font-bold text-slate-800">Health Overview</h3>

                            <ul class="mb-6 space-y-4">
                                <li class="flex items-center justify-between border-b border-slate-50 pb-4">
                                    <span class="text-sm text-slate-500">Blood Type</span>
                                    <span class="text-sm font-semibold text-slate-800">A+</span>
                                </li>
                                <li class="flex items-center justify-between border-b border-slate-50 pb-4">
                                    <span class="text-sm text-slate-500">Allergies</span>
                                    <span class="text-sm font-semibold text-slate-800">Penicillin</span>
                                </li>
                                <li class="flex items-center justify-between">
                                    <span class="text-sm text-slate-500">Chronic Conditions</span>
                                    <span class="text-sm font-semibold text-slate-800">Hypertension</span>
                                </li>
                            </ul>

                            <div class="border-t border-slate-100 pt-4">
                                <p class="mb-3 text-xs text-slate-400">Primary Doctor</p>
                                <div class="flex items-center gap-3">
                                    <img
                                        src="https://ui-avatars.com/api/?name=Sarah+Johnson&background=random"
                                        alt="Doctor"
                                        class="h-10 w-10 rounded-full object-cover"
                                    />
                                    <div>
                                        <h4 class="text-sm font-bold text-slate-800">Dr. Sarah Johnson</h4>
                                        <p class="text-xs text-slate-500">Cardiologist</p>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="rounded-3xl border border-slate-100 bg-white p-6 shadow-sm">
                            <h3 class="mb-6 text-lg font-bold text-slate-800">Recent Activity</h3>

                            <div class="relative ml-3 space-y-6 border-l-2 border-slate-100">
                                <div class="relative pl-6">
                                    <div class="absolute top-1 -left-[7px] h-3 w-3 rounded-full border-2 border-white bg-emerald-500 shadow-sm"></div>
                                    <p class="text-sm font-medium text-slate-800">Appointment confirmed</p>
                                    <p class="mt-1 text-xs text-slate-400">2 hours ago</p>
                                </div>

                                <div class="relative pl-6">
                                    <div class="absolute top-1 -left-[7px] h-3 w-3 rounded-full border-2 border-white bg-blue-500 shadow-sm"></div>
                                    <p class="text-sm font-medium text-slate-800">Test result uploaded</p>
                                    <p class="mt-1 text-xs text-slate-400">1 day ago</p>
                                </div>

                                <div class="relative pl-6">
                                    <div class="absolute top-1 -left-[7px] h-3 w-3 rounded-full border-2 border-white bg-purple-500 shadow-sm"></div>
                                    <p class="text-sm font-medium text-slate-800">Prescription updated</p>
                                    <p class="mt-1 text-xs text-slate-400">3 days ago</p>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>
