<script setup>
import { Link } from '@inertiajs/vue3';

const providers = [
    {
        title: 'Patients',
        description: 'Book appointments, view records, and manage your health from one secure dashboard.',
        icon: 'patient',
        to: '/register',
    },
    {
        title: 'Doctors',
        description: 'Manage your practice, appointments, and patient care with tools built for providers.',
        icon: 'doctor',
        to: '/register',
    },
    {
        title: 'Clinics',
        description: 'Register your clinic, manage staff and services, and streamline daily operations.',
        icon: 'clinic',
        to: '/register',
    },
    {
        title: 'Pharmacies',
        description: 'Handle prescriptions, inventory, and orders with an integrated pharmacy workflow.',
        icon: 'pharmacy',
        to: '/register',
    },
];
</script>

<template>
    <section id="providers" class="bg-gray-50 py-16 sm:py-20 lg:py-24">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <h2 class="text-center text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
                Built for Every <span class="text-primary">Healthcare Provider</span>
            </h2>

            <div class="mt-12 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
                <article
                    v-for="(provider, index) in providers"
                    :key="index"
                    class="group flex flex-col rounded-xl bg-white p-6 text-center shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-all duration-500 ease-out hover:-translate-y-3 hover:bg-primary/5 hover:shadow-2xl sm:p-8"
                >
                    <div
                        class="mx-auto mb-4 flex h-14 w-14 items-center justify-center text-primary transition-all duration-500 group-hover:scale-125 group-hover:rotate-6"
                        aria-hidden="true"
                    >
                        <!-- Patient -->
                        <svg v-if="provider.icon === 'patient'" class="h-10 w-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="1.5"
                                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                            />
                        </svg>
                        <!-- Doctor -->
                        <svg v-else-if="provider.icon === 'doctor'" class="h-10 w-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="1.5"
                                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                            />
                        </svg>
                        <!-- Clinic -->
                        <svg v-else-if="provider.icon === 'clinic'" class="h-10 w-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="1.5"
                                d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                            />
                        </svg>
                        <!-- Pharmacy -->
                        <svg v-else-if="provider.icon === 'pharmacy'" class="h-10 w-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="1.5"
                                d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"
                            />
                        </svg>
                    </div>
                    <h3 class="text-lg font-bold text-gray-900">
                        {{ provider.title }}
                    </h3>
                    <p class="mt-2 flex-1 text-sm text-gray-600">
                        {{ provider.description }}
                    </p>
                    <Link
                        :href="provider.to"
                        class="mt-4 inline-flex items-center justify-center gap-1 text-sm font-medium text-primary hover:underline"
                    >
                        Learn More
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                        </svg>
                    </Link>
                </article>
            </div>
        </div>
    </section>
</template>
