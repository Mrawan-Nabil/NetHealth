<script setup>
defineOptions({ inheritAttrs: false });

defineProps({
    title: {
        type: String,
        required: true,
    },
    subtitle: {
        type: String,
        required: true,
    },
});
</script>

<template>
    <section
        v-bind="$attrs"
        class="rounded-xl border border-[#E5E7EB] bg-white p-5 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04)"
    >
        <header class="mb-5">
            <h3 class="mb-0.5 text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ title }}</h3>
            <p v-if="subtitle" class="text-xs text-[#9CA3AF] dark:text-[#64748B]">{{ subtitle }}</p>
        </header>
        <slot />
    </section>
</template>
