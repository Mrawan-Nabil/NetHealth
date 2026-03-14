<script setup>
import { Link } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import netHealthLogo3 from '../../assets/logo3.png';

const navLinks = [
    { label: 'Home', href: '#home' },
    { label: 'Features', href: '#features-section' },
    { label: 'About Us', href: '#cta-section' },
    { label: 'Contact', href: '#footer-section' },
];

const isScrolled = ref(false);

// Smooth scroll function
function handleSmoothScroll(href) {
    if (href === '#home') {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
        const targetId = href.replace('#', '');
        const targetElement = document.getElementById(targetId);
        if (targetElement) {
            targetElement.scrollIntoView({ behavior: 'smooth' });
        }
    }
}

onMounted(() => {
    const handleScroll = () => {
        isScrolled.value = window.scrollY > 20;
    };

    window.addEventListener('scroll', handleScroll);

    return () => {
        window.removeEventListener('scroll', handleScroll);
    };
});
</script>

<template>
    <header
        :class="[
            'sticky top-0 z-50 w-full transition-all duration-300',
            isScrolled
                ? 'border-b border-gray-200/20 bg-white/80 shadow-lg backdrop-blur-xl dark:border-gray-700/20 dark:bg-gray-900/80'
                : 'bg-transparent',
        ]"
    >
        <nav class="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
            <!-- Logo + brand -->
            <Link href="/home" class="heart-pulse-hover flex shrink-0 items-center gap-2 transition-transform duration-300">
                <img
                    :src="netHealthLogo3"
                    alt="NetHealth Logo"
                    class="mb-2 h-16 w-16"
                    style="width: 155px; height: 150px; margin-bottom: -50px; margin-top: -50px"
                />
            </Link>

            <!-- Center navigation -->
            <div class="hidden items-center space-x-8 md:flex">
                <a
                    v-for="link in navLinks"
                    :key="link.label"
                    @click.prevent="handleSmoothScroll(link.href)"
                    :class="[
                        'relative cursor-pointer text-sm font-medium text-gray-600 transition duration-300 after:absolute after:-bottom-1 after:left-0 after:h-0.5 after:w-0 after:bg-primary after:transition-all after:duration-300 hover:text-primary hover:after:w-full',
                        isScrolled
                            ? 'text-gray-700 hover:text-teal-600 dark:text-gray-300 dark:hover:text-teal-400'
                            : 'text-gray-600 hover:text-teal-600',
                    ]"
                >
                    {{ link.label }}
                    <span
                        class="absolute -bottom-1 left-0 h-0.5 w-0 bg-gradient-to-r from-teal-500 to-cyan-500 transition-all duration-250 group-hover:w-full"
                    ></span>
                </a>
            </div>

            <!-- Right: Auth buttons -->
            <div class="flex shrink-0 items-center space-x-3">
                <Link
                    href='/login'
                    :class="[
                        'rounded-lg px-4 py-2 text-sm font-medium transition-all duration-250',
                        isScrolled
                            ? 'text-gray-700 hover:bg-teal-50 hover:text-teal-600 dark:text-gray-300 dark:hover:bg-teal-900/20 dark:hover:text-teal-400'
                            : 'text-gray-700 hover:bg-white/10 hover:text-teal-600',
                    ]"
                >
                    Login
                </Link>
                <Link
                    href='/register'
                    class="btn-pill btn-primary-gradient transform text-white shadow-lg transition-all duration-250 hover:-translate-y-0.5 hover:shadow-xl"
                >
                    Get Started
                </Link>
            </div>
        </nav>
    </header>
</template>

<style scoped>
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

/* Enhanced glassmorphism effect */
header {
    animation: fadeDown 0.6s ease-out;
}

/* Logo hover effect */
.group:hover img {
    filter: drop-shadow(0 4px 8px rgba(20, 184, 166, 0.3));
}

/* Logo sizing constraints */
.group img {
    max-width: 240px;
    object-fit: contain;
    height: auto;
}

/* Navigation link hover effects */
.group:hover span {
    background: linear-gradient(90deg, #14b8a6, #06b6d4);
}

/* Button enhancements */
.btn-pill {
    border-radius: 50px;
    padding: 10px 20px;
    font-weight: 600;
    font-size: 14px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.btn-primary-gradient {
    background: linear-gradient(135deg, #14b8a6 0%, #0d9488 50%, #0f766e 100%);
    border: none;
    box-shadow: 0 4px 16px rgba(20, 184, 166, 0.3);
}

.btn-primary-gradient:hover {
    background: linear-gradient(135deg, #0d9488 0%, #0f766e 50%, #134e4a 100%);
    box-shadow: 0 8px 24px rgba(20, 184, 166, 0.4);
}

/* Mobile responsiveness */
@media (max-width: 768px) {
    .btn-pill {
        padding: 8px 16px;
        font-size: 13px;
    }
}
</style>
