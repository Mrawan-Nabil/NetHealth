<script setup>
defineProps({
    title: { type: String, required: true },
    icon: { type: String, required: true },
    notes: { type: Array, default: () => [] }
});
</script>

<template>
    <section
        class="rounded-2xl border border-[#E5E7EB] bg-white p-6 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0,0,0,0.04);"
    >
        <h4 class="mb-4 inline-flex items-center gap-2 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">
            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-violet-50 text-violet-600 dark:bg-violet-500/10 dark:text-violet-300">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" :d="icon" />
                </svg>
            </span>
            {{ title }}
        </h4>

        <div class="rounded-xl bg-[#F8FAFC] p-4 dark:bg-[#0F172A]">
            <div v-if="notes.length > 0" class="space-y-4">
                <div
                    v-for="(note, index) in notes"
                    :key="index"
                    :class="{ 'border-t border-[#E5E7EB] pt-4 dark:border-[#334155]': index > 0 }"
                >
                    <p class="text-sm leading-relaxed text-[#64748B] dark:text-[#94A3B8]">
                        {{ note.text }}
                    </p>
                    <p class="mt-1.5 text-[11px] font-medium tracking-wide text-[#9CA3AF] dark:text-[#64748B]">
                        {{ note.date }}
                    </p>
                </div>
            </div>

            <p v-else class="text-sm italic text-[#9CA3AF] dark:text-[#64748B]">
                No special medical notes on file.
            </p>
        </div>
    </section>
</template>
