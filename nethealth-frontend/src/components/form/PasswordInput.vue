<template>
  <div class="form-group">
    <label v-if="label" :for="inputId" class="block text-sm font-medium text-slate-700 mb-2">
      {{ label }}
      <span class="text-red-500 ml-1">*</span>
    </label>
    <div class="relative">
      <input
        :id="inputId"
        :type="showPassword ? 'text' : 'password'"
        :value="modelValue"
        @input="handleInput"
        @blur="$emit('blur')"
        @focus="handleFocus"
        placeholder="••••••••"
        required
        :class="[
          'w-full px-4 py-3 pr-12 rounded-xl border transition-all duration-300',
          'focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary',
          'placeholder:text-slate-400',
          error 
            ? 'border-red-300 bg-red-50/50 focus:border-red-500 focus:ring-red-500/20' 
            : 'border-slate-200 bg-white hover:border-slate-300',
          isFocused && !error && 'scale-[1.01] shadow-lg shadow-primary/10'
        ]"
      />
      <button
        type="button"
        @click="showPassword = !showPassword"
        class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors p-1"
      >
        <svg v-if="!showPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
        </svg>
        <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
        </svg>
      </button>
    </div>

    <!-- Password Strength Indicator -->
    <transition name="strength-fade">
      <div v-if="showStrength && modelValue && !error" class="mt-3">
        <div class="flex items-center gap-2 mb-1">
          <div class="flex-1 h-1.5 bg-slate-100 rounded-full overflow-hidden">
            <div 
              :class="[
                'h-full transition-all duration-500 rounded-full',
                strengthColor
              ]"
              :style="{ width: `${strength * 25}%` }"
            ></div>
          </div>
          <span :class="['text-xs font-medium', strengthTextColor]">
            {{ strengthText }}
          </span>
        </div>
        <p class="text-xs text-slate-500">
          Use 8+ characters with a mix of letters, numbers & symbols
        </p>
      </div>
    </transition>

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
import { ref, computed, watch } from 'vue'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  label: {
    type: String,
    default: ''
  },
  error: {
    type: String,
    default: ''
  },
  showStrength: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['update:modelValue', 'blur', 'strength-change'])

const showPassword = ref(false)
const isFocused = ref(false)
const inputId = computed(() => `password-${Math.random().toString(36).substr(2, 9)}`)

const strength = computed(() => {
  const password = props.modelValue
  if (!password) return 0

  let score = 0
  
  // Length
  if (password.length >= 8) score++
  if (password.length >= 12) score++
  
  // Complexity
  if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++
  if (/\d/.test(password)) score++
  if (/[^a-zA-Z0-9]/.test(password)) score++
  
  return Math.min(score, 4)
})

const strengthText = computed(() => {
  const texts = ['Weak', 'Fair', 'Good', 'Strong']
  return texts[strength.value - 1] || 'Weak'
})

const strengthColor = computed(() => {
  const colors = [
    'bg-red-500',
    'bg-orange-500',
    'bg-yellow-500',
    'bg-green-500'
  ]
  return colors[strength.value - 1] || 'bg-red-500'
})

const strengthTextColor = computed(() => {
  const colors = [
    'text-red-600',
    'text-orange-600',
    'text-yellow-600',
    'text-green-600'
  ]
  return colors[strength.value - 1] || 'text-red-600'
})

const handleInput = (event) => {
  emit('update:modelValue', event.target.value)
}

const handleFocus = () => {
  isFocused.value = true
  setTimeout(() => {
    isFocused.value = false
  }, 300)
}

watch(strength, (newStrength) => {
  emit('strength-change', newStrength)
})
</script>

<style scoped>
.error-slide-enter-active,
.error-slide-leave-active,
.strength-fade-enter-active,
.strength-fade-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.error-slide-enter-from,
.strength-fade-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.error-slide-leave-to,
.strength-fade-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}
</style>
