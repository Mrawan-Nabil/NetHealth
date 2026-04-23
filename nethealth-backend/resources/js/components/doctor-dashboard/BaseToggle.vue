<script setup>
defineProps({ modelValue: { type: Boolean, required: true } });
defineEmits(['update:modelValue']);
</script>

<template>
    <button
        type="button"
        role="switch"
        :aria-checked="modelValue"
        class="relative inline-flex h-6 w-11 items-center rounded-full transition-colors duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#14B8A6]/40 focus-visible:ring-offset-2"
        :class="modelValue ? 'bg-[#14B8A6]' : 'bg-[#CBD5E1] dark:bg-[#334155]'"
        @click="$emit('update:modelValue', !modelValue)"
    >
        <span class="inline-block h-5 w-5 transform rounded-full bg-white shadow-sm transition-transform duration-200" :class="modelValue ? 'translate-x-5' : 'translate-x-0.5'" />
    </button>
</template>
