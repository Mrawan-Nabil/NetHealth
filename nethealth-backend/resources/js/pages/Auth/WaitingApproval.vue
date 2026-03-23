<script setup>
import { Link } from '@inertiajs/vue3';
import netHealthLogo from '../../assets/logo.png';
import AuthLayout from '../../layouts/AuthLayout.vue';
</script>

<template>
    <AuthLayout>
        <Transition name="page-fade" appear>
            <div class="mx-auto max-w-md space-y-6 p-4">

                <div class="text-center">
                    <img
                        :src="netHealthLogo"
                        class="heart-pulse-hover mx-auto mb-2 h-36 w-36 transition-transform duration-300 hover:scale-105"
                        alt="NetHealth logo"
                    />
                    <h1 class="text-2xl font-bold text-gray-900">Account Under Review</h1>
                    <p class="mt-1 text-sm text-gray-500">Just one more step before you can start!</p>
                </div>

                <div class="rounded-xl border border-gray-100 bg-white p-6 text-center shadow-sm">
                    <div class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-primary">
                        <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>

                    <h2 class="mb-2 text-lg font-semibold text-gray-800">Verifying Your Documents</h2>
                    <p class="text-sm text-gray-600 leading-relaxed">
                        Our administration team is currently reviewing your uploaded medical licenses and registration documents to ensure patient safety.
                    </p>
                    <p class="mt-3 text-sm font-medium text-gray-800">
                        We will notify you via email as soon as your account is activated.
                    </p>
                </div>

                <div class="pt-2">
                    <Link
                        href="/logout"
                        method="post"
                        as="button"
                        class="w-full rounded-lg border border-gray-200 bg-gray-50 py-2.5 font-medium text-gray-700 transition-all hover:bg-gray-100 hover:scale-[1.02] active:scale-95 focus:ring-2 focus:ring-primary/30 focus:outline-none"
                    >
                        Log Out for Now
                    </Link>
                </div>

                <div class="border-t border-gray-200 pt-6">
                    <p class="flex items-center justify-center gap-2 text-xs text-gray-500">
                        <svg class="h-4 w-4 shrink-0 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                            />
                        </svg>
                        Your medical data is encrypted and securely protected
                    </p>
                </div>

            </div>
        </Transition>
    </AuthLayout>
</template>

<style scoped>
.page-fade-enter-active {
    transition:
        opacity 0.5s ease,
        transform 0.5s ease;
}
.page-fade-enter-from {
    opacity: 0;
    transform: translateY(20px);
}
</style>
