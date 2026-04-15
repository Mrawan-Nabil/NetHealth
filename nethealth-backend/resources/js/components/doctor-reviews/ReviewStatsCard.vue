<script setup lang="ts">
defineProps<{ label: string; value: number; tone: 'total' | 'pending' | 'reviewed' }>();
</script>
<template>
    <article
        class="rounded-2xl border border-[#E5E7EB] bg-white p-5 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <div class="flex items-center justify-between">
            <div>
                <p class="text-xs font-medium text-[#94A3B8] dark:text-[#64748B]">{{ label }}</p>
                <p
                    class="text-3xl font-bold leading-none tracking-tight"
                    :class="
                        tone === 'pending'
                            ? 'text-amber-500'
                            : tone === 'reviewed'
                              ? 'text-[#14B8A6] dark:text-[#2DD4BF]'
                              : 'text-[#0F172A] dark:text-[#F1F5F9]'
                    "
                >
                    {{ value }}
                </p>
            </div>
            <span
                class="inline-flex h-10 w-10 items-center justify-center rounded-xl"
                :class="
                    tone === 'pending'
                        ? 'bg-amber-50 text-amber-600 dark:bg-amber-500/10 dark:text-amber-300'
                        : tone === 'reviewed'
                          ? 'bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]'
                          : 'bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]'
                "
            >
                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M5 4.5h9l5 5V19a1.5 1.5 0 0 1-1.5 1.5h-12A1.5 1.5 0 0 1 4 19V6A1.5 1.5 0 0 1 5.5 4.5Z" />
                </svg>
            </span>
        </div>
    </article>
</template>
