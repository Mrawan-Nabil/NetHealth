<script setup>
import { Link, router } from '@inertiajs/vue3';
import { toTypedSchema } from '@vee-validate/zod';
import { useForm, useField } from 'vee-validate';
import { ref } from 'vue';
import { z } from 'zod';
import AuthLayout from '@/layouts/AuthLayout.vue';
import BaseInput from '../components/base/BaseInput.vue';

const netHealthLogo = '/images/logo.png';

const loginSchema = z.object({
    email: z.string({ required_error: 'Email is required' }).min(1, 'Email is required').email('Please enter a valid email address'),
    password: z.string({ required_error: 'Password is required' }).min(1, 'Password is required').min(6, 'Password must be at least 6 characters'),
});

// 1. Added setErrors here to handle backend responses
const { handleSubmit, setErrors } = useForm({
    validationSchema: toTypedSchema(loginSchema),
    initialValues: { email: '', password: '' },
});

const { value: email, errorMessage: emailError } = useField('email', undefined, {
    validateOnBlur: true,
    validateOnValueUpdate: false,
});
const { value: password, errorMessage: passwordError } = useField('password', undefined, {
    validateOnBlur: true,
    validateOnValueUpdate: false,
});

const showPassword = ref(false);
const rememberMe = ref(false);

// 2. Added onError to map Laravel errors to the form fields
const onSubmit = handleSubmit((values) => {
    router.post(
        '/login',
        {
            email: values.email,
            password: values.password,
            rememberMe: rememberMe.value,
        },
        {
            onError: (errors) => {
                setErrors(errors);
            },
        },
    );
});
</script>

<template>
    <AuthLayout>
        <div class="space-y-6">
            <!-- Header -->
            <div class="mb-8 flex flex-col items-center">
                <img :src="netHealthLogo" alt="NetHealth Logo" class="mb-2 h-16 w-16" style="width: 180px; height: 180px; margin: -10px" />

                <h1 class="mt-2 text-3xl font-extrabold text-gray-900" style="font-size: 25px">Welcome</h1>
                <p class="mt-1 text-sm text-gray-500">Your health, managed in one secure place</p>
            </div>

            <!-- Form -->
            <form class="space-y-4" @submit.prevent="onSubmit" novalidate>
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
                        <input v-model="rememberMe" type="checkbox" class="h-4 w-4 rounded border-gray-300 text-primary focus:ring-primary/30" />
                        <span class="text-sm text-gray-700">Remember me</span>
                    </label>
                    <Link href="/forgot-password" class="text-sm font-medium text-primary hover:underline"> Forgot password? </Link>
                </div>

                <button
                    type="submit"
                    class="w-full rounded-lg bg-primary py-2 font-medium text-white transition-opacity hover:opacity-95 focus:ring-2 focus:ring-primary/30 focus:ring-offset-2 focus:outline-none"
                >
                    Login
                </button>
            </form>

            <div class="space-y-4 border-t border-gray-200 pt-6">
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
                <p class="text-center text-sm text-gray-600">
                    Don't have an account?
                    <Link href="/register" class="font-medium text-primary hover:underline"> Register </Link>
                </p>
            </div>
        </div>
    </AuthLayout>
</template>
