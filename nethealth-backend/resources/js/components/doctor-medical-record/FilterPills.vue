<script setup lang="ts">
defineProps<{ pills: Array<{ key: string; label: string }>; activeFilter: string }>();
defineEmits<{ (event: 'change', value: string): void }>();
</script>
<template>
    <div class="flex flex-wrap items-center gap-2">
        <button
            v-for="pill in pills"
            :key="pill.key"
            class="rounded-xl border px-3 py-2 text-sm font-semibold transition-all duration-200 focus-visible:ring-2 focus-visible:ring-[#14B8A6]/30 focus-visible:outline-none"
            :class="
                activeFilter === pill.key
                    ? 'border-[#14B8A6] bg-[#14B8A6] text-white shadow-sm shadow-teal-500/20'
                    : 'border-[#E5E7EB] bg-white text-[#64748B] hover:bg-[#F8FAFC] hover:border-[#14B8A6]/40 dark:border-[#334155] dark:bg-[#1E293B] dark:text-[#94A3B8] dark:hover:bg-[#334155]/60 dark:hover:border-[#14B8A6]/40'
            "
            @click="$emit('change', pill.key)"
        >
            {{ pill.label }}
        </button>
    </div>
</template>
