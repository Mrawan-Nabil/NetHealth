<template>
  <div class="form-group">
    <label v-if="label" :for="inputId" class="block text-sm font-medium text-slate-700 mb-2">
      {{ label }}
      <span v-if="required" class="text-red-500 ml-1">*</span>
    </label>
    <div class="relative">
      <select
        :id="inputId"
        :value="modelValue"
        @change="$emit('update:modelValue', $event.target.value)"
        @blur="$emit('blur')"
        @focus="handleFocus"
        :required="required"
        :disabled="disabled"
        :class="[
          'w-full px-4 py-3 pr-10 rounded-xl border transition-all duration-300 appearance-none',
          'focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary',
          'bg-white cursor-pointer',
          error 
            ? 'border-red-300 bg-red-50/50 focus:border-red-500 focus:ring-red-500/20' 
            : 'border-slate-200 hover:border-slate-300',
          disabled && 'opacity-50 cursor-not-allowed bg-slate-50',
          isFocused && !error && 'scale-[1.01] shadow-lg shadow-primary/10',
          !modelValue && 'text-slate-400'
        ]"
      >
        <option v-for="option in options" :key="option.value" :value="option.value">
          {{ option.label }}
        </option>
      </select>
      <div class="absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-slate-400">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
        </svg>
      </div>
    </div>
    <transition name="error-slide">
      <p v-if="error" class="mt-2 text-sm text-red-600 flex items-center gap-1">
        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
        </svg>
        {{ error }}
      </p>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  modelValue: {
    type: [String, Number],
    default: ''
  },
  label: {
    type: String,
    default: ''
  },
  options: {
    type: Array,
    required: true,
    default: () => []
  },
  error: {
    type: String,
    default: ''
  },
  required: {
    type: Boolean,
    default: false
  },
  disabled: {
    type: Boolean,
    default: false
  }
})

defineEmits(['update:modelValue', 'blur'])

const isFocused = ref(false)
const inputId = computed(() => `select-${Math.random().toString(36).substr(2, 9)}`)

const handleFocus = () => {
  isFocused.value = true
  setTimeout(() => {
    isFocused.value = false
  }, 300)
}
</script>

<style scoped>
.error-slide-enter-active,
.error-slide-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.error-slide-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.error-slide-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}
</style>
