<script setup>
/**
 * MultiStepForm – reusable multi-step form with progress indicator and step-only validation.
 *
 * Usage with VeeValidate (validate only current step before Next):
 *   const { validateField } = useForm(...)
 *   const STEP_FIELDS = [['email', 'password'], ['firstName', 'lastName'], ['bio']]
 *   const validateStep = async (stepIndex) => {
 *     const fields = STEP_FIELDS[stepIndex] ?? []
 *     for (const name of fields) {
 *       const r = await validateField(name)
 *       if (!r.valid) return false
 *     }
 *     return true
 *   }
 *   <MultiStepForm v-model:step="currentStep" :steps="steps" :validate-step="validateStep">
 *     <template #default="{ stepIndex }">
 *       <div v-if="stepIndex === 0">...</div>
 *       <div v-else-if="stepIndex === 1">...</div>
 *     </template>
 *   </MultiStepForm>
 */
import { computed } from 'vue';

const props = defineProps({
    /** Step labels shown in the progress indicator */
    steps: {
        type: Array,
        default: () => [],
        validator: (steps) => steps.every((s) => typeof s === 'string'),
    },
    /** Current step index (0-based). Use v-model:step for two-way binding. */
    step: {
        type: Number,
        default: 0,
    },
    /**
     * Optional validator run before advancing to the next step.
     * Return true (or resolve to true) to allow "Next", false to block.
     * Use VeeValidate's validateField() for the current step's fields and return whether they are valid.
     */
    validateStep: {
        type: Function,
        default: null,
    },
});

const emit = defineEmits(['update:step', 'next', 'previous', 'finish']);

const stepCount = computed(() => props.steps.length);
const currentStep = computed(() => Math.max(0, Math.min(props.step, stepCount.value - 1)));
const isFirst = computed(() => currentStep.value === 0);
const isLast = computed(() => currentStep.value === stepCount.value - 1);
const progressPercent = computed(() => (stepCount.value > 0 ? ((currentStep.value + 1) / stepCount.value) * 100 : 0));

const slotProps = computed(() => ({
    stepIndex: currentStep.value,
    stepLabel: props.steps[currentStep.value] ?? '',
    isFirst: isFirst.value,
    isLast: isLast.value,
    totalSteps: stepCount.value,
}));

async function goNext() {
    if (props.validateStep) {
        const valid = await Promise.resolve(props.validateStep(currentStep.value));
        if (!valid) return;
    }
    if (isLast.value) {
        emit('finish');
        return;
    }
    const next = currentStep.value + 1;
    emit('update:step', next);
    emit('next', next);
}

function goPrevious() {
    if (isFirst.value) return;
    const prev = currentStep.value - 1;
    emit('update:step', prev);
    emit('previous', prev);
}
</script>

<template>
    <div class="multi-step-form">
        <!-- Step indicator -->
        <div v-if="steps.length" class="mb-8">
            <div class="flex items-center justify-between gap-2">
                <template v-for="(label, index) in steps" :key="index">
                    <div class="flex flex-1 items-center" :class="{ 'flex-none': index === steps.length - 1 }">
                        <div class="flex flex-col items-center">
                            <div
                                class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-sm font-medium transition-colors"
                                :class="
                                    index < currentStep
                                        ? 'bg-primary text-white'
                                        : index === currentStep
                                          ? 'border-2 border-primary bg-white text-primary ring-2 ring-primary/20'
                                          : 'border-2 border-gray-300 bg-white text-gray-400'
                                "
                            >
                                {{ index + 1 }}
                            </div>
                            <span
                                class="mt-1.5 hidden text-xs font-medium sm:block"
                                :class="index <= currentStep ? 'text-gray-700' : 'text-gray-400'"
                            >
                                {{ label }}
                            </span>
                        </div>
                        <div
                            v-if="index < steps.length - 1"
                            class="mx-1 h-0.5 flex-1 rounded transition-colors sm:mx-2"
                            :class="index < currentStep ? 'bg-primary' : 'bg-gray-200'"
                        />
                    </div>
                </template>
            </div>
            <!-- Progress bar (optional visual) -->
            <div class="mt-4 h-1.5 w-full overflow-hidden rounded-full bg-gray-200">
                <div class="h-full rounded-full bg-primary transition-all duration-300" :style="{ width: `${progressPercent}%` }" />
            </div>
        </div>

        <!-- Step content (slot) -->
        <div class="min-h-50">
            <slot v-bind="slotProps" />
        </div>

        <!-- Navigation -->
        <div class="mt-8 flex items-center justify-between gap-4 border-t border-gray-200 pt-6">
            <button
                type="button"
                class="rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition-all hover:scale-[1.03] hover:bg-gray-50 focus:ring-2 focus:ring-primary/30 focus:ring-offset-2 focus:outline-none active:scale-95 disabled:pointer-events-none disabled:opacity-50"
                :disabled="isFirst"
                @click="goPrevious"
            >
                Previous
            </button>
            <button
                type="button"
                class="rounded-lg bg-primary px-4 py-2 text-sm font-medium text-white transition-all hover:scale-[1.03] hover:opacity-95 focus:ring-2 focus:ring-primary/30 focus:ring-offset-2 focus:outline-none active:scale-95"
                @click="goNext"
            >
                {{ isLast ? 'Submit' : 'Next' }}
            </button>
        </div>
    </div>
</template>
