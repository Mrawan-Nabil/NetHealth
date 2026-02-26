<script setup>
import { ref, watch } from 'vue'
import BaseInput from './BaseInput.vue'
import BaseSelect from './BaseSelect.vue'

const COUNTRY_CODES = [
  { value: '+20', label: '+20 (EG)' },
  { value: '+1', label: '+1' },
  { value: '+44', label: '+44 (UK)' },
  { value: '+33', label: '+33 (FR)' },
  { value: '+49', label: '+49 (DE)' },
  { value: '+966', label: '+966 (SA)' },
  { value: '+971', label: '+971 (AE)' },
  { value: '+965', label: '+965 (KW)' },
  { value: '+974', label: '+974 (QA)' },
  { value: '+973', label: '+973 (BH)' },
  { value: '+968', label: '+968 (OM)' },
]

// Sort by code length descending so we match +966 before +96, and +20 before +2
const CODES_SORTED = [...COUNTRY_CODES].sort((a, b) => b.value.length - a.value.length)

const props = defineProps({
  modelValue: { type: String, default: '' },
  label: { type: String, default: 'Phone' },
  placeholder: { type: String, default: '' },
  error: { type: String, default: '' },
})

const emit = defineEmits(['update:modelValue'])

const countryCode = ref('+20')
const number = ref('')

function parseModelValue(val) {
  if (!val || typeof val !== 'string') return { code: '+20', number: '' }
  const trimmed = val.startsWith('+') ? val : `+${val}`
  for (const { value: code } of CODES_SORTED) {
    if (trimmed.startsWith(code)) {
      return { code, number: trimmed.slice(code.length).replace(/\D/g, '') }
    }
  }
  return { code: '+20', number: trimmed.replace(/\D/g, '') }
}

function syncFromModel() {
  const { code, number: num } = parseModelValue(props.modelValue)
  countryCode.value = code
  number.value = num
}

function emitValue() {
  const combined = number.value ? `${countryCode.value}${number.value}` : ''
  emit('update:modelValue', combined)
}

watch(
  () => props.modelValue,
  () => syncFromModel(),
  { immediate: true }
)

function onCodeChange(val) {
  countryCode.value = val
  emitValue()
}

function onNumberInput(val) {
  number.value = val.replace(/\D/g, '')
  emitValue()
}
</script>

<template>
  <div class="w-full">
    <label v-if="label" class="mb-1.5 block text-sm font-medium text-gray-700">
      {{ label }}
    </label>
    <div class="flex gap-2">
      <div class="w-28 shrink-0">
        <BaseSelect
          :model-value="countryCode"
          :placeholder="'+20'"
          :error="undefined"
          @update:model-value="onCodeChange"
        >
          <option
            v-for="opt in COUNTRY_CODES"
            :key="opt.value"
            :value="opt.value"
          >
            {{ opt.label }}
          </option>
        </BaseSelect>
      </div>
      <div class="min-w-0 flex-1">
        <BaseInput
          :model-value="number"
          type="tel"
          :placeholder="placeholder"
          :error="undefined"
          @update:model-value="onNumberInput"
        />
      </div>
    </div>
    <span v-if="error" class="mt-1 block text-sm text-red-500">{{ error }}</span>
  </div>
</template>
