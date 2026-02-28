<script setup>
import { Link } from '@inertiajs/vue3';
import netHealthLogo3 from '../../assets/logo3.png';

const navLinks = [
    { label: 'Home', href: '#home' },
    { label: 'Features', href: '#features' },
    { label: 'About Us', href: '#about' },
    { label: 'Contact', href: '#contact' },
];

// دالة التمرير السلس المعدلة
function handleSmoothScroll(href) {
    if (href === '#home') {
        // التمرير إلى أعلى الصفحة
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
        const targetId = href.replace('#', '');
        const targetElement = document.getElementById(targetId);
        if (targetElement) {
            targetElement.scrollIntoView({ behavior: 'smooth' });
        }
    }
}
</script>

<template>
    <header
        class="sticky top-0 z-50 w-full animate-[fadeDown_0.6s_ease-out] bg-white/90 shadow-[0_1px_3px_0_rgba(0,0,0,0.08)] backdrop-blur-md transition-all duration-500"
    >
        <nav class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
            <!-- Logo + brand -->
            <Link href="/home" class="heart-pulse-hover flex shrink-0 items-center gap-2 transition-transform duration-300 hover:scale-105">
                <img
                    :src="netHealthLogo3"
                    alt="NetHealth Logo"
                    class="mb-2 h-16 w-16"
                    style="width: 155px; height: 150px; margin-bottom: -50px; margin-top: -50px"
                />
            </Link>

            <!-- Center links -->
            <div class="hidden items-center gap-8 md:flex">
                <a
                    v-for="link in navLinks"
                    :key="link.label"
                    @click.prevent="handleSmoothScroll(link.href)"
                    class="relative cursor-pointer text-sm font-medium text-gray-600 transition duration-300 after:absolute after:-bottom-1 after:left-0 after:h-[2px] after:w-0 after:bg-primary after:transition-all after:duration-300 hover:text-primary hover:after:w-full"
                >
                    {{ link.label }}
                </a>
            </div>

            <!-- Right: Login + Register -->
            <div class="flex shrink-0 items-center gap-3">
                <Link
                    href="/login"
                    class="rounded-full bg-primary px-6 py-2 text-sm font-medium text-white transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-primary/30"
                >
                    Login
                </Link>
                <Link
                    href="/register"
                    class="rounded-full border border-primary px-6 py-2 text-sm font-medium text-primary transition-all duration-300 hover:-translate-y-1 hover:bg-primary hover:text-white hover:shadow-lg hover:shadow-primary/30"
                >
                    Register
                </Link>
            </div>
        </nav>
    </header>
</template>

<style>
@keyframes fadeDown {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
