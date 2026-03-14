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
import { computed } from 'vue'

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
})

const emit = defineEmits(['update:step', 'next', 'previous', 'finish'])

const stepCount = computed(() => props.steps.length)
const currentStep = computed(() =>
  Math.max(0, Math.min(props.step, stepCount.value - 1))
)
const isFirst = computed(() => currentStep.value === 0)
const isLast = computed(() => currentStep.value === stepCount.value - 1)
const progressPercent = computed(() =>
  stepCount.value > 0 ? ((currentStep.value + 1) / stepCount.value) * 100 : 0
)

const slotProps = computed(() => ({
  stepIndex: currentStep.value,
  stepLabel: props.steps[currentStep.value] ?? '',
  isFirst: isFirst.value,
  isLast: isLast.value,
  totalSteps: stepCount.value,
}))

async function goNext() {
  if (props.validateStep) {
    const valid = await Promise.resolve(props.validateStep(currentStep.value))
    if (!valid) return
  }
  if (isLast.value) {
    emit('finish')
    return
  }
  const next = currentStep.value + 1
  emit('update:step', next)
  emit('next', next)
}

function goPrevious() {
  if (isFirst.value) return
  const prev = currentStep.value - 1
  emit('update:step', prev)
  emit('previous', prev)
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
                class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-sm font-semibold transition-all duration-200"
                :class="
                  index < currentStep
                    ? 'bg-white text-purple-600 shadow-lg'
                    : index === currentStep
                      ? 'border-2 border-white bg-white/10 text-white ring-2 ring-white/20 shadow-sm backdrop-blur-sm'
                      : 'border-2 border-white/30 bg-white/5 text-white/60 backdrop-blur-sm'
                "
              >
                {{ index + 1 }}
              </div>
              <span
                class="mt-1.5 hidden text-xs font-medium sm:block"
                :class="index <= currentStep ? 'text-white' : 'text-white/60'"
              >
                {{ label }}
              </span>
            </div>
            <div
              v-if="index < steps.length - 1"
              class="mx-1 h-0.5 flex-1 rounded transition-colors duration-200 sm:mx-2"
              :class="index < currentStep ? 'bg-white' : 'bg-white/30'"
            />
          </div>
        </template>
      </div>
      <!-- Progress bar (optional visual) -->
      <div class="mt-4 h-1.5 w-full overflow-hidden rounded-full bg-gray-200">
        <div
          class="h-full rounded-full bg-[#14B8A6] transition-all duration-300"
          :style="{ width: `${progressPercent}%` }"
        />
      </div>
    </div>

    <!-- Step content (slot) -->
    <div class="min-h-[200px]">
      <slot v-bind="slotProps" />
    </div>

    <!-- Navigation -->
    <div class="mt-8 flex items-center justify-between gap-4 border-t border-gray-200 pt-6">
      <button
        type="button"
        class="btn-secondary"
        :disabled="isFirst"
        @click="goPrevious"
      >
        Previous
      </button>
      <button
        type="button"
        class="btn-primary"
        @click="goNext"
      >
        {{ isLast ? 'Submit' : 'Next' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Button styling */
.btn-primary {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px -4px rgba(20, 184, 166, 0.3);
}

.btn-primary:active {
  transform: scale(0.98);
  transition-duration: 0.15s;
}

.btn-secondary {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn-secondary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px -2px rgba(0, 0, 0, 0.1);
}

.btn-secondary:active {
  transform: scale(0.98);
  transition-duration: 0.15s;
}
</style>
