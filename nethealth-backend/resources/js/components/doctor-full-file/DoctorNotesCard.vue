<script setup lang="ts">
import BaseButton from './BaseButton.vue';
const notes = defineModel<string>({ default: '' });
defineProps<{ saved?: boolean }>();
defineEmits<{ (event: 'submit'): void }>();
</script>
<template>
    <section
        class="rounded-2xl border border-[#F1F5F9] bg-white p-6 dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <h4 class="mb-4 inline-flex items-center gap-2 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">
            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]"><svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M7 8h10M7 12h10M7 16h6M5.5 4.5h13A1.5 1.5 0 0 1 20 6v12a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 4 18V6a1.5 1.5 0 0 1 1.5-1.5Z" /></svg></span>
            Doctor's Notes
        </h4>
        <div class="rounded-xl bg-[#F8FAFC] p-3 dark:bg-[#0F172A]">
            <textarea v-model="notes" rows="6" placeholder="Write your notes or diagnosis here..." class="min-h-[180px] w-full resize-none border-l-2 border-[#14B8A6] bg-transparent px-3 py-2 text-sm text-[#0F172A] outline-none placeholder:text-[#9CA3AF] dark:text-[#F1F5F9] dark:placeholder:text-[#475569]" />
        </div>
        <div class="mt-3 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
            <p class="min-h-4 text-xs font-medium text-[#14B8A6] dark:text-[#2DD4BF]">{{ saved ? 'Notes saved.' : '' }}</p>
            <BaseButton variant="primary" size="sm" :disabled="notes.trim().length === 0" @click="$emit('submit')">Submit Notes</BaseButton>
        </div>
    </section>
</template>
