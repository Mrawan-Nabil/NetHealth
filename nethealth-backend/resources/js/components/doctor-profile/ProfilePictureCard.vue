<script setup>
import { ref } from 'vue';
import BaseButton from './BaseButton.vue';

defineProps({
    avatar: { type: String, required: true },
    name: { type: String, required: true },
    doctorId: { type: String, required: true },
});

// 1. Removed the TypeScript <{...}> syntax
const emit = defineEmits(['change-photo', 'remove-photo']);

// 2. Removed the <HTMLInputElement | null> generic
const fileInput = ref(null);

const handleFileChange = (event) => {
    // 3. Removed the "as HTMLInputElement" assertion
    const file = event.target.files?.[0];
    if (file) emit('change-photo', file);
};

const openFileDialog = () => {
    fileInput.value?.click();
};
</script>

<template>
    <section
        class="rounded-xl border border-[#E5E7EB] bg-white p-5 dark:border-[#334155] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04)"
    >
        <header class="mb-4">
            <h3 class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">Profile Picture</h3>
            <p class="mt-0.5 text-xs text-[#9CA3AF] dark:text-[#64748B]">JPG, PNG or WebP. Maximum size 10 MB.</p>
        </header>

        <div class="flex flex-col gap-3.5 sm:flex-row sm:items-center sm:justify-between">
            <div class="flex items-center gap-3">
                <img :src="avatar" :alt="name" class="h-16 w-16 rounded-lg object-cover ring-2 ring-[#F1F5F9] dark:ring-[#334155]" />
                <div>
                    <p class="mb-0.5 font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ name }}</p>
                    <p class="text-xs text-[#9CA3AF] dark:text-[#64748B]">Doctor ID: {{ doctorId }}</p>
                </div>
            </div>

            <div class="flex flex-wrap gap-2">
                <input ref="fileInput" type="file" accept="image/png,image/jpeg,image/webp" class="hidden" @change="handleFileChange" />
                <BaseButton variant="secondary" size="sm" @click="openFileDialog">
                    <svg class="mr-1 h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M12 16V5m0 0 4 4m-4-4-4 4M4 16.5v2A1.5 1.5 0 0 0 5.5 20h13a1.5 1.5 0 0 0 1.5-1.5v-2"
                        />
                    </svg>
                    Change Photo
                </BaseButton>
                <BaseButton variant="danger" size="sm" @click="$emit('remove-photo')">Remove Photo</BaseButton>
            </div>
        </div>
    </section>
</template>
