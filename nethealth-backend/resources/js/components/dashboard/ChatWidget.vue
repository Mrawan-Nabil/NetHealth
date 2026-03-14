<template>
  <Teleport to="body">
    <Transition name="slide">
      <div v-if="isOpen" class="fixed bottom-6 right-6 z-50 w-96 h-[600px] bg-white rounded-2xl shadow-2xl flex flex-col">
        <!-- Header -->
        <div class="bg-gradient-to-r from-teal-500 to-teal-600 px-6 py-4 rounded-t-2xl flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center">
              <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
            </div>
            <div>
              <h3 class="text-white font-semibold">AI Health Assistant</h3>
              <p class="text-teal-100 text-xs">Online</p>
            </div>
          </div>
          <button @click="close" class="p-2 hover:bg-white/10 rounded-lg transition-colors">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <!-- Messages -->
        <div ref="messagesContainer" class="flex-1 overflow-y-auto p-4 space-y-4">
          <div v-for="(message, index) in messages" :key="index" :class="message.sender === 'user' ? 'flex justify-end' : 'flex justify-start'">
            <div :class="message.sender === 'user' ? 'bg-teal-500 text-white' : 'bg-gray-100 text-gray-800'" class="max-w-[80%] px-4 py-3 rounded-2xl">
              <p class="text-sm">{{ message.text }}</p>
              <p :class="message.sender === 'user' ? 'text-teal-100' : 'text-gray-500'" class="text-xs mt-1">
                {{ message.time }}
              </p>
            </div>
          </div>
          
          <!-- Typing Indicator -->
          <div v-if="isTyping" class="flex justify-start">
            <div class="bg-gray-100 px-4 py-3 rounded-2xl">
              <div class="flex gap-1">
                <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0ms"></div>
                <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 150ms"></div>
                <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 300ms"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Quick Actions -->
        <div v-if="showQuickActions" class="px-4 pb-2">
          <p class="text-xs text-gray-500 mb-2">Quick Actions</p>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="action in quickActions"
              :key="action"
              @click="sendQuickAction(action)"
              class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs rounded-full transition-colors"
            >
              {{ action }}
            </button>
          </div>
        </div>

        <!-- Input -->
        <div class="border-t border-gray-200 p-4">
          <div class="flex gap-2">
            <input 
              v-model="inputMessage"
              @keyup.enter="sendMessage"
              type="text"
              placeholder="Type your message..."
              class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500"
            />
            <button 
              @click="sendMessage"
              :disabled="!inputMessage.trim()"
              :class="inputMessage.trim() ? 'bg-teal-500 hover:bg-teal-600' : 'bg-gray-300 cursor-not-allowed'"
              class="px-4 py-3 text-white rounded-lg transition-colors"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, nextTick, watch } from 'vue'

const props = defineProps({
  isOpen: Boolean
})

const emit = defineEmits(['close'])

const messages = ref([
  {
    sender: 'bot',
    text: 'Hello! I\'m your AI Health Assistant. How can I help you today?',
    time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  }
])

const inputMessage = ref('')
const isTyping = ref(false)
const messagesContainer = ref(null)
const showQuickActions = ref(true)

const quickActions = [
  'Book appointment',
  'View prescriptions',
  'Check symptoms',
  'Find doctors'
]

const sendMessage = () => {
  if (!inputMessage.value.trim()) return

  const userMessage = {
    sender: 'user',
    text: inputMessage.value,
    time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  }

  messages.value.push(userMessage)
  inputMessage.value = ''
  showQuickActions.value = false

  scrollToBottom()
  simulateBotResponse(userMessage.text)
}

const sendQuickAction = (action) => {
  inputMessage.value = action
  sendMessage()
}

const simulateBotResponse = (userText) => {
  isTyping.value = true

  setTimeout(() => {
    isTyping.value = false

    let botResponse = ''
    const lowerText = userText.toLowerCase()

    if (lowerText.includes('appointment') || lowerText.includes('book')) {
      botResponse = 'I can help you book an appointment. Would you like to see available doctors and time slots?'
    } else if (lowerText.includes('prescription')) {
      botResponse = 'You have 1 active prescription. Would you like me to show you the details or request a refill?'
    } else if (lowerText.includes('symptom')) {
      botResponse = 'I can help you understand your symptoms. Please describe what you\'re experiencing, and I\'ll provide some guidance.'
    } else if (lowerText.includes('doctor')) {
      botResponse = 'We have many qualified doctors available. What specialty are you looking for?'
    } else {
      botResponse = 'I understand. Is there anything specific about your health or appointments I can help you with?'
    }

    messages.value.push({
      sender: 'bot',
      text: botResponse,
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    })

    scrollToBottom()
  }, 1500)
}

const scrollToBottom = () => {
  nextTick(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
    }
  })
}

const close = () => emit('close')

watch(() => props.isOpen, (newVal) => {
  if (newVal) {
    scrollToBottom()
  }
})
</script>

<style scoped>
.slide-enter-active,
.slide-leave-active {
  transition: all 0.3s ease;
}

.slide-enter-from {
  transform: translateY(100%);
  opacity: 0;
}

.slide-leave-to {
  transform: translateY(100%);
  opacity: 0;
}
</style>
