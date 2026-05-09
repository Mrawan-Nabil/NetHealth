<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue';
import AppointmentTypeCard from './AppointmentTypeCard.vue';
import BaseButton from './BaseButton.vue';
import BaseCheckbox from './BaseCheckbox.vue';
import BaseTimeInput from './BaseTimeInput.vue';
import QuickPresetButton from './QuickPresetButton.vue';
import ScheduleDayRow from './ScheduleDayRow.vue';
import TimeOptionGroup from './TimeOptionGroup.vue';

const props = defineProps({
    open: { type: Boolean, required: true },
    schedule: { type: Object, required: true },
});

const emit = defineEmits(['close', 'save']);

const modalRef = ref(null);

const makeCopy = (source) => ({
    days: source.days.map((day) => ({ ...day })),
    duration: source.duration,
    breakBetweenSlots: source.breakBetweenSlots,
    selectedPreset: source.selectedPreset,
    appointmentTypes: { ...source.appointmentTypes },
    labReviewOptions: { ...source.labReviewOptions },
});

const localSchedule = ref(makeCopy(props.schedule));

const presetMap = {
    morning: { from: '09:00 AM', to: '02:00 PM' },
    evening: { from: '05:00 PM', to: '10:00 PM' },
};

const presetButtons = [
    { key: 'morning', label: 'Morning Shift', range: '9:00 AM - 2:00 PM' },
    { key: 'evening', label: 'Evening Shift', range: '5:00 PM - 10:00 PM' },
];

const errors = computed(() =>
    localSchedule.value.days.flatMap((day) => {
        if (!day.enabled) return [];
        if (!day.from || !day.to) return [`${day.name} requires both start and end times.`];
        if (day.from === day.to) return [`${day.name} must have different start and end times.`];
        return [];
    }),
);

const closeModal = () => emit('close');

const onKeydown = (event) => {
    if (!props.open) return;

    if (event.key === 'Escape') {
        event.preventDefault();
        closeModal();
        return;
    }

    if (event.key === 'Tab' && modalRef.value) {
        const focusables = modalRef.value.querySelectorAll(
            'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])',
        );
        if (!focusables.length) return;

        const first = focusables[0];
        const last = focusables[focusables.length - 1];
        const active = document.activeElement;

        if (event.shiftKey && active === first) {
            event.preventDefault();
            last.focus();
        } else if (!event.shiftKey && active === last) {
            event.preventDefault();
            first.focus();
        }
    }
};

const applyPreset = (presetKey) => {
    const preset = presetMap[presetKey];
    localSchedule.value.selectedPreset = presetKey;
    localSchedule.value.days = localSchedule.value.days.map((day) =>
        day.enabled ? { ...day, from: preset.from, to: preset.to } : day,
    );
};

const saveSchedule = () => {
    if (errors.value.length) return;
    emit('save', makeCopy(localSchedule.value));
};

watch(
    () => props.schedule,
    (value) => {
        localSchedule.value = makeCopy(value);
    },
    { deep: true },
);

watch(
    () => props.open,
    async (value) => {
        if (value) {
            localSchedule.value = makeCopy(props.schedule);
            await nextTick();
            const firstFocusable = modalRef.value?.querySelector('button, input, select, textarea');
            firstFocusable?.focus();
        }
    },
);

onMounted(() => document.addEventListener('keydown', onKeydown));
onBeforeUnmount(() => document.removeEventListener('keydown', onKeydown));
</script>

<template>
    <transition name="fade">
        <div v-if="open" class="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/55 p-4 backdrop-blur-[2px]" @click.self="closeModal">
            <transition name="slide">
                <div
                    v-if="open"
                    ref="modalRef"
                    class="max-h-[92vh] w-full max-w-2xl overflow-y-auto rounded-2xl border border-[#E5E7EB] bg-white shadow-[var(--shadow-dropdown)] dark:border-[#334155] dark:bg-[#1E293B]"
                >
                    <div class="flex items-center justify-between border-b border-[#E5E7EB] px-6 py-4 dark:border-[#334155]">
                        <div class="flex items-center gap-2">
                            <span class="inline-flex h-9 w-9 items-center justify-center rounded-xl bg-[#CCFBF1] text-[#0D9488] dark:bg-[#14B8A6]/15 dark:text-[#2DD4BF]">
                                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 2v3m8-3v3M3.5 9.5h17M5 5.5h14a1.5 1.5 0 0 1 1.5 1.5v12A1.5 1.5 0 0 1 19 20.5H5A1.5 1.5 0 0 1 3.5 19V7A1.5 1.5 0 0 1 5 5.5Z" />
                                </svg>
                            </span>
                            <h3 class="text-base font-semibold text-[#0F172A] dark:text-[#F1F5F9]">Edit Schedule</h3>
                        </div>
                        <button type="button" class="rounded-xl p-2 text-[#94A3B8] transition-colors duration-200 hover:bg-[#F8FAFC] hover:text-[#0F172A] dark:text-[#64748B] dark:hover:bg-[#334155] dark:hover:text-[#F1F5F9]" @click="closeModal">
                            <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M18 6 6 18M6 6l12 12" />
                            </svg>
                        </button>
                    </div>

                    <div class="space-y-6 px-6 py-6">
                        <section class="space-y-3">
                            <p class="text-sm font-semibold text-[#14B8A6] dark:text-[#2DD4BF]">Quick Presets</p>
                            <div class="flex flex-wrap gap-3">
                                <QuickPresetButton
                                    v-for="preset in presetButtons"
                                    :key="preset.key"
                                    :label="preset.label"
                                    :time-range="preset.range"
                                    :selected="localSchedule.selectedPreset === preset.key"
                                    @click="applyPreset(preset.key)"
                                />
                            </div>
                        </section>

                        <section class="space-y-3">
                            <p class="text-sm font-semibold text-[#14B8A6] dark:text-[#2DD4BF]">Weekly Availability</p>
                            <div class="space-y-3">
                                <ScheduleDayRow
                                    v-for="(day, index) in localSchedule.days"
                                    :key="day.name"
                                    :day="day"
                                    @toggle="localSchedule.days[index].enabled = !localSchedule.days[index].enabled"
                                    @update:from="localSchedule.days[index].from = $event"
                                    @update:to="localSchedule.days[index].to = $event"
                                />
                            </div>
                        </section>

                        <section class="grid gap-5 md:grid-cols-2">
                            <div class="space-y-3">
                                <p class="text-sm font-semibold text-[#14B8A6] dark:text-[#2DD4BF]">Time Slot Setting</p>
                                <div>
                                    <p class="mb-2 text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">Appointment Duration</p>
                                    <TimeOptionGroup v-model="localSchedule.duration" :options="['15 min', '30 min', '45 min']" />
                                </div>
                            </div>
                            <div class="space-y-3 md:pt-7">
                                <p class="text-xs font-semibold text-[#374151] dark:text-[#94A3B8]">Break Between Slot</p>
                                <BaseTimeInput v-model="localSchedule.breakBetweenSlots" />
                            </div>
                        </section>

                        <section class="space-y-3">
                            <p class="text-sm font-semibold text-[#14B8A6] dark:text-[#2DD4BF]">Appointment Types</p>
                            <div class="space-y-3">
                                <AppointmentTypeCard
                                    v-model="localSchedule.appointmentTypes.inClinic"
                                    title="In-Clinic Visit"
                                    description="Standard in-person consultations"
                                    icon="M5 4.5h14A1.5 1.5 0 0 1 20.5 6v12a1.5 1.5 0 0 1-1.5 1.5H5A1.5 1.5 0 0 1 3.5 18V6A1.5 1.5 0 0 1 5 4.5Zm7 3v8m-4-4h8"
                                />
                                <AppointmentTypeCard
                                    v-model="localSchedule.appointmentTypes.followUp"
                                    title="Follow-up Visit"
                                    description="Patient follow-up and progress checks"
                                    icon="M12 8v4l3 2m6-2a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                                />
                                <AppointmentTypeCard
                                    v-model="localSchedule.appointmentTypes.labReview"
                                    title="Lab & Imaging Review"
                                    description="Review lab results and imaging reports"
                                    icon="M5 4.5h9l5 5V19a1.5 1.5 0 0 1-1.5 1.5h-12A1.5 1.5 0 0 1 4 19V6A1.5 1.5 0 0 1 5.5 4.5Z"
                                >
                                    <div v-if="localSchedule.appointmentTypes.labReview" class="mt-3 flex flex-col gap-2">
                                        <BaseCheckbox v-model="localSchedule.labReviewOptions.acceptLabTests" label="Accept Lab Tests" />
                                        <BaseCheckbox v-model="localSchedule.labReviewOptions.acceptXrayImages" label="Accept X-ray Images" />
                                    </div>
                                </AppointmentTypeCard>
                            </div>
                        </section>

                        <div v-if="errors.length" class="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-700 dark:border-red-500/30 dark:bg-red-500/10 dark:text-red-300">
                            <p v-for="error in errors" :key="error">{{ error }}</p>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 border-t border-[#E5E7EB] px-6 py-4 dark:border-[#334155]">
                        <BaseButton variant="secondary" @click="closeModal">Cancel</BaseButton>
                        <BaseButton variant="primary" :disabled="errors.length > 0" @click="saveSchedule">Save Changes</BaseButton>
                    </div>
                </div>
            </transition>
        </div>
    </transition>
</template>
