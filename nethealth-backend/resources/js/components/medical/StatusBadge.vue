<script setup>
import { computed } from 'vue';

const props = defineProps({
    status: {
        type: String,
        required: true,
    },
    isDark: {
        type: Boolean,
        default: false,
    },
});

const badgeClasses = computed(() => {
    const statusLower = props.status.toLowerCase();

    if (statusLower === 'reviewed') {
        return props.isDark ? 'bg-emerald-500/10 text-[#22C55E]' : 'bg-emerald-100 text-emerald-600';
    } else if (statusLower === 'pending') {
        return props.isDark ? 'bg-orange-500/10 text-[#F59E0B]' : 'bg-orange-100 text-orange-600';
    } else if (statusLower === 'processing') {
        return props.isDark ? 'bg-blue-500/10 text-[#3B82F6]' : 'bg-blue-100 text-blue-600';
    }

    return props.isDark ? 'bg-gray-500/10 text-[#94A3B8]' : 'bg-gray-100 text-gray-600';
});
</script>

<template>
    <span :class="['inline-block rounded-full px-3 py-1 text-xs font-medium uppercase', badgeClasses]">
        {{ status }}
    </span>
</template>
