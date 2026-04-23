<script setup>
defineProps({
    modelValue: { type: String, required: true },
    options: { type: Array, required: true },
});

defineEmits(['update:modelValue']);
</script>

<template>
    <div class="flex flex-wrap gap-2">
        <button
            v-for="option in options"
            :key="option"
            type="button"
            class="rounded-xl border px-4 py-2 text-sm font-medium transition-all duration-200"
            :class="
                modelValue === option
                    ? 'border-teal-200 bg-[#F0FDFA] text-[#0F766E] shadow-sm dark:border-teal-500/20 dark:bg-teal-500/8 dark:text-teal-400'
                    : 'border-[#E5E7EB] bg-white text-[#64748B] hover:bg-[#F8FAFC] dark:border-[#334155] dark:bg-[#1E293B] dark:text-[#94A3B8] dark:hover:bg-[#334155]/60'
            "
            @click="$emit('update:modelValue', option)"
        >
            {{ option }}
        </button>
    </div>
</template>
