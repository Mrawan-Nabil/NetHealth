<script setup lang="ts">
defineProps<{ title: string; icon: string; content: string }>();
</script>
<template>
    <section
        class="rounded-2xl border border-[#E5E7EB] bg-white p-6 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <h4 class="mb-4 inline-flex items-center gap-2 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">
            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-violet-50 text-violet-600 dark:bg-violet-500/10 dark:text-violet-300"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" :d="icon" /></svg></span>{{ title }}
        </h4>
        <div class="rounded-xl bg-[#F8FAFC] p-4 text-sm leading-relaxed text-[#64748B] dark:bg-[#0F172A] dark:text-[#94A3B8]">
            {{ content }}
        </div>
    </section>
</template>
