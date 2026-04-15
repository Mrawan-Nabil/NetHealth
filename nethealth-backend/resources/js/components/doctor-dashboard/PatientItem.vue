<script setup lang="ts">
defineProps<{
    name: string;
    lastVisit: string;
    note: string;
    avatar: string;
}>();

defineEmits<{ (event: 'view-patient'): void }>();
</script>

<template>
    <article class="flex items-center justify-between gap-3 rounded-xl border border-transparent bg-[#F8FAFC] p-3.5 transition-colors duration-200 hover:border-[#E5E7EB] hover:bg-[#F1F5F9] dark:bg-[#0F172A] dark:hover:border-[#334155]/60 dark:hover:bg-[#334155]/40">
        <div class="flex min-w-0 items-center gap-3">
            <img :src="avatar" :alt="name" class="h-10 w-10 shrink-0 rounded-full object-cover" />
            <div class="min-w-0">
                <p class="truncate text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ name }}</p>
                <p class="truncate text-xs text-[#64748B] dark:text-[#94A3B8]">Last Visit: {{ lastVisit }} - {{ note }}</p>
            </div>
        </div>
        <button
            type="button"
            class="shrink-0 rounded-lg p-2 text-[#64748B] transition-colors duration-200 hover:bg-[#F1F5F9] hover:text-[#0F172A] focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none dark:text-[#94A3B8] dark:hover:bg-[#334155] dark:hover:text-[#F1F5F9]"
            @click="$emit('view-patient')"
        >
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M9 5l7 7-7 7" />
            </svg>
        </button>
    </article>
</template>
