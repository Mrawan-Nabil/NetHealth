<script setup lang="ts">
defineProps<{
    title: string;
    subtitle?: string;
}>();
</script>

<template>
    <section
        class="dash-card rounded-2xl border border-[#E5E7EB] bg-white p-6 shadow-[var(--shadow-card)] transition-all duration-200 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <header class="mb-5 flex items-start justify-between gap-3">
            <div>
                <h3 class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ title }}</h3>
                <p v-if="subtitle" class="mt-1 text-xs text-[#94A3B8] dark:text-[#64748B]">{{ subtitle }}</p>
            </div>
            <slot name="header-right" />
        </header>
        <slot />
    </section>
</template>
