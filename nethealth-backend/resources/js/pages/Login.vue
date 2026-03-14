<script setup>
import { Link, router } from '@inertiajs/vue3';
import { toTypedSchema } from '@vee-validate/zod';
import { useForm, useField } from 'vee-validate';
import { ref } from 'vue';
import { z } from 'zod';
import netHealthLogo from '@/assets/logo.png';
import AuthLayout from '@/layouts/AuthLayout.vue';
import BaseInput from '../components/base/BaseInput.vue';

// 1. Define your strict frontend rules
const loginSchema = z.object({
    email: z.email('Please enter a valid email address'),
    password: z.string().min(1, 'Password is required'),
});

// 2. Extract isSubmitting alongside handleSubmit and setErrors
const { handleSubmit, setErrors, isSubmitting } = useForm({
    validationSchema: toTypedSchema(loginSchema),
    initialValues: { email: '', password: '' },
});

const { value: email, errorMessage: emailError } = useField('email');
const { value: password, errorMessage: passwordError } = useField('password');

const showPassword = ref(false);
const rememberMe = ref(false);

// 3. The crucial fix: Return a Promise inside handleSubmit
const onSubmit = handleSubmit((values) => {
    return new Promise((resolve) => {
        router.post(
            '/login',
            {
                email: values.email,
                password: values.password,
                rememberMe: rememberMe.value,
            },
            {
                // If Laravel rejects the data, map it to Vee-Validate
                onError: (errors) => {
                    setErrors(errors);
                    resolve(); // Tell Vee-Validate the network request is done
                },
                // If login succeeds, resolve so the UI can transition cleanly
                onSuccess: () => {
                    resolve();
                },
            },
        );
    });
});
</script>

<template>
    <AuthLayout>
        <Transition name="page-fade" appear>
            <div class="mx-auto max-w-md space-y-6 p-4">
                <!-- Logo & Header -->
                <div class="text-center">
                    <img
                        :src="netHealthLogo"
                        class="heart-pulse-hover mx-auto mb-2 h-36 w-36 transition-transform duration-300 hover:scale-105"
                        alt="NetHealth logo"
                    />
                    <h1 class="text-2xl font-bold">Welcome</h1>
                    <p class="text-sm text-gray-500">Your health, managed in one secure place</p>
                </div>

                <!-- Form -->
                <form @submit.prevent="onSubmit" class="space-y-4">
                    <BaseInput v-model="email" label="Email" type="email" placeholder="you@example.com" :error="emailError" />
                    <BaseInput
                        v-model="password"
                        :type="showPassword ? 'text' : 'password'"
                        label="Password"
                        placeholder="••••••••"
                        :error="passwordError"
                    >
                        <template #icon>
                            <button
                                type="button"
                                class="rounded p-1 text-gray-500 hover:text-gray-700 focus:ring-2 focus:ring-primary/30 focus:outline-none"
                                :aria-label="showPassword ? 'Hide password' : 'Show password'"
                                @click="showPassword = !showPassword"
                            >
                                <svg v-if="showPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"
                                    />
                                </svg>
                                <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                                    />
                                </svg>
                            </button>
                        </template>
                    </BaseInput>

                    <div class="flex items-center justify-between">
                        <label class="flex cursor-pointer items-center gap-2">
                            <input type="checkbox" v-model="rememberMe" class="h-4 w-4 rounded border-gray-300 text-primary focus:ring-primary/30" />
                            <span class="text-sm text-gray-700">Remember me</span>
                        </label>
                        <Link href="/forgot-password" class="text-sm text-primary hover:underline">Forgot password?</Link>
                    </div>

                    <button
                        type="submit"
                        :disabled="isSubmitting"
                        class="w-full rounded-lg bg-primary py-2 text-white transition-all hover:scale-[1.03] active:scale-95 disabled:cursor-not-allowed disabled:opacity-50"
                    >
                        <span v-if="isSubmitting">Logging in...</span>
                        <span v-else>Login</span>
                    </button>
                </form>

                <!-- Footer -->
                <div class="mt-6 text-center text-sm text-gray-600">
                    Don't have an account?
                    <Link href="/register" class="text-primary hover:underline">Register</Link>
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
