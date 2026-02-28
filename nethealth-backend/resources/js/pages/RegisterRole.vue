<script setup>
import { router } from '@inertiajs/vue3';
import AuthLayout from '@/layouts/AuthLayout.vue';

const roles = [
    {
        id: 'patient',
        title: 'Patient',
        subtitle: 'Book appointments, view records, and manage your health.',
        routeName: '/register/patient',
    },
    {
        id: 'doctor',
        title: 'Doctor',
        subtitle: 'Manage your practice, appointments, and patient care.',
        routeName: '/register/doctor',
    },
    {
        id: 'clinic',
        title: 'Clinic',
        subtitle: 'Register your clinic and manage staff and services.',
        routeName: '/register/clinic',
    },
    {
        id: 'pharmacy',
        title: 'Pharmacy',
        subtitle: 'Manage inventory, prescriptions, orders and your staff workflow.',
        routeName: '/register/pharmacy',
    },
];

function selectRole(routeName) {
    router.get(routeName);
}
</script>

<template>
    <AuthLayout>
        <Transition name="fade-slide" appear>
            <div class="space-y-6">
                <!-- Header -->
                <div class="animate-stagger text-center">
                    <h1 class="text-2xl font-bold text-gray-900">Create an Account</h1>
                    <p class="mt-1 text-sm text-gray-600">Select your account type to get started</p>
                </div>

                <!-- Roles -->
                <ul class="animate-stagger flex flex-col gap-3" role="list">
                    <li v-for="role in roles" :key="role.id">
                        <button
                            type="button"
                            class="flex w-full items-center gap-4 rounded-xl border-2 border-gray-200 bg-white p-4 text-left transition-all duration-300 hover:scale-[1.02] hover:border-primary hover:bg-gray-50/50 hover:shadow-md focus:outline-none focus-visible:ring-2 focus-visible:ring-primary/30 active:scale-95"
                            @click="selectRole(role.routeName)"
                        >
                            <!-- Patient -->
                            <svg
                                v-if="role.id === 'patient'"
                                class="h-8 w-8 shrink-0 text-primary"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="1.5"
                                    d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                                />
                            </svg>

                            <!-- Doctor -->
                            <svg
                                v-else-if="role.id === 'doctor'"
                                class="h-8 w-8 shrink-0 text-primary"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="1.5"
                                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                                />
                            </svg>

                            <!-- Clinic -->
                            <svg
                                v-else-if="role.id === 'clinic'"
                                class="h-8 w-8 shrink-0 text-primary"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="1.5"
                                    d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                                />
                            </svg>

                            <!-- Pharmacy -->
                            <svg
                                v-else-if="role.id === 'pharmacy'"
                                class="h-8 w-8 shrink-0 text-primary"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="1.5"
                                    d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"
                                />
                            </svg>

                            <!-- Text -->
                            <div class="min-w-0 flex-1">
                                <span class="font-bold text-gray-900">
                                    {{ role.title }}
                                </span>
                                <p class="mt-0.5 text-sm text-gray-600">
                                    {{ role.subtitle }}
                                </p>
                            </div>
                        </button>
                    </li>
                </ul>
            </div>
        </Transition>
    </AuthLayout>
</template>

<style scoped>
/* Page entrance animation */
.fade-slide-enter-from {
    opacity: 0;
    transform: translateY(20px);
}
.fade-slide-enter-active {
    transition: all 0.5s ease;
}
.fade-slide-enter-to {
    opacity: 1;
    transform: translateY(0);
}

/* Stagger effect */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(15px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.animate-stagger > * {
    opacity: 0;
    animation: fadeInUp 0.5s ease forwards;
}

.animate-stagger > *:nth-child(1) {
    animation-delay: 0.1s;
}
.animate-stagger > *:nth-child(2) {
    animation-delay: 0.2s;
}
.animate-stagger > *:nth-child(3) {
    animation-delay: 0.3s;
}
.animate-stagger > *:nth-child(4) {
    animation-delay: 0.4s;
}
</style>

<!--<div class="space-y-6">-->
<!--<div class="text-center">-->
<!--    <h1 class="text-2xl font-bold text-gray-900">Create an Account</h1>-->
<!--    <p class="mt-1 text-sm text-gray-600">Select your account type to get started</p>-->
<!--</div>-->

<!--<ul class="flex flex-col gap-3" role="list">-->
<!--    <li v-for="role in roles" :key="role.id">-->
<!--        <button-->
<!--            type="button"-->
<!--            class="flex w-full items-start gap-4 rounded-xl border-2 border-gray-200 bg-white p-4 text-left transition-colors hover:border-primary hover:bg-gray-50/50 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary/30 active:border-primary"-->
<!--            @click="selectRole(role.routeName)"-->
<!--        >-->
<!--            &lt;!&ndash; Patient icon &ndash;&gt;-->
<!--            <svg-->
<!--                v-if="role.id === 'patient'"-->
<!--                class="h-8 w-8 shrink-0 text-primary"-->
<!--                fill="none"-->
<!--                stroke="currentColor"-->
<!--                viewBox="0 0 24 24"-->
<!--                aria-hidden="true"-->
<!--            >-->
<!--                <path-->
<!--                    stroke-linecap="round"-->
<!--                    stroke-linejoin="round"-->
<!--                    stroke-width="1.5"-->
<!--                    d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"-->
<!--                />-->
<!--            </svg>-->
<!--            &lt;!&ndash; Doctor icon &ndash;&gt;-->
<!--            <svg-->
<!--                v-else-if="role.id === 'doctor'"-->
<!--                class="h-8 w-8 shrink-0 text-primary"-->
<!--                fill="none"-->
<!--                stroke="currentColor"-->
<!--                viewBox="0 0 24 24"-->
<!--                aria-hidden="true"-->
<!--            >-->
<!--                <path-->
<!--                    stroke-linecap="round"-->
<!--                    stroke-linejoin="round"-->
<!--                    stroke-width="1.5"-->
<!--                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"-->
<!--                />-->
<!--            </svg>-->
<!--            &lt;!&ndash; Clinic icon &ndash;&gt;-->
<!--            <svg-->
<!--                v-else-if="role.id === 'clinic'"-->
<!--                class="h-8 w-8 shrink-0 text-primary"-->
<!--                fill="none"-->
<!--                stroke="currentColor"-->
<!--                viewBox="0 0 24 24"-->
<!--                aria-hidden="true"-->
<!--            >-->
<!--                <path-->
<!--                    stroke-linecap="round"-->
<!--                    stroke-linejoin="round"-->
<!--                    stroke-width="1.5"-->
<!--                    d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"-->
<!--                />-->
<!--            </svg>-->
<!--            &lt;!&ndash; Pharmacy icon &ndash;&gt;-->
<!--            <svg-->
<!--                v-else-if="role.id === 'pharmacy'"-->
<!--                class="h-8 w-8 shrink-0 text-primary"-->
<!--                fill="none"-->
<!--                stroke="currentColor"-->
<!--                viewBox="0 0 24 24"-->
<!--                aria-hidden="true"-->
<!--            >-->
<!--                <path-->
<!--                    stroke-linecap="round"-->
<!--                    stroke-linejoin="round"-->
<!--                    stroke-width="1.5"-->
<!--                    d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"-->
<!--                />-->
<!--            </svg>-->
<!--            <div class="min-w-0 flex-1">-->
<!--                <span class="font-bold text-gray-900">{{ role.title }}</span>-->
<!--                <p class="mt-0.5 text-sm text-gray-600">-->
<!--                    {{ role.subtitle }}-->
<!--                </p>-->
<!--            </div>-->
<!--        </button>-->
<!--    </li>-->
<!--</ul>-->
<!--</div>-->
