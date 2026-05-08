<script setup>
import { ref } from 'vue';

defineProps({
    avatar: { type: String, required: true },
    name: { type: String, required: true },
    doctorId: { type: String, required: true },
});

const emit = defineEmits(['change-photo', 'remove-photo']);

const fileInput = ref(null);

const openFileDialog = () => {
    fileInput.value?.click();
};
</script>

<template>
    <section
        class="rounded-2xl border border-[#F1F5F9] bg-white p-6 dark:border-[#1E293B] dark:bg-[#1E293B]"
        style="box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04)"
    >
        <div class="mb-1 flex items-center gap-2">
            <h3 class="text-sm font-semibold text-[#0F172A] dark:text-[#F1F5F9]">Profile Picture</h3>
        </div>
        <p class="mb-5 text-xs text-[#9CA3AF] dark:text-[#64748B]">JPG, PNG or WebP. Maximum size 10 MB.</p>

        <div class="flex flex-wrap items-center gap-5">
            <div class="relative">
                <img
                    :src="avatar"
                    :alt="name"
                    class="h-20 w-20 rounded-2xl object-cover ring-4 ring-[#F1F5F9] dark:ring-[#1E293B]"
                />
                <button
                    type="button"
                    @click="openFileDialog"
                    class="absolute -right-1.5 -bottom-1.5 flex h-7 w-7 items-center justify-center rounded-full bg-[#14B8A6] shadow-lg shadow-teal-500/30 transition-transform duration-200 hover:scale-110"
                >
                    <svg class="h-3.5 w-3.5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                </button>
            </div>

            <div>
                <p class="mb-0.5 font-semibold text-[#0F172A] dark:text-[#F1F5F9]">{{ name }}</p>
                <p class="mb-4 text-xs text-[#9CA3AF] dark:text-[#64748B]">Doctor ID: {{ doctorId || '—' }}</p>

                <div class="flex flex-wrap gap-2">
                    <input
                        ref="fileInput"
                        type="file"
                        accept="image/png,image/jpeg,image/webp"
                        class="hidden"
                        @change="emit('change-photo', $event)"
                    />

                    <button
                        type="button"
                        @click="openFileDialog"
                        class="rounded-xl border border-[#E5E7EB] px-4 py-2 text-xs font-semibold text-[#374151] transition-all duration-200 hover:bg-[#F9FAFB] dark:border-[#334155] dark:text-[#94A3B8] dark:hover:bg-[#334155]/60"
                    >
                        Change Photo
                    </button>
                    <button
                        type="button"
                        @click="emit('remove-photo')"
                        class="rounded-xl border border-red-200 px-4 py-2 text-xs font-semibold text-red-500 transition-all duration-200 hover:bg-red-50 dark:border-red-500/30 dark:text-red-400 dark:hover:bg-red-500/8"
                    >
                        Remove
                    </button>
                </div>
            </div>
        </div>
    </section>
</template>
