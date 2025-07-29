<script setup lang="ts">
import { XMarkIcon } from '@heroicons/vue/24/outline'

defineProps<{
  show: boolean
  message: string
  type?: 'success' | 'error' | 'info'
}>()

const emit = defineEmits(['close'])

const bgColor = {
  success: 'bg-green-50',
  error: 'bg-red-50',
  info: 'bg-blue-50',
}

const textColor = {
  success: 'text-green-800',
  error: 'text-red-800',
  info: 'text-blue-800',
}

const iconColor = {
  success: 'text-green-400',
  error: 'text-red-400',
  info: 'text-blue-400',
}
</script>

<template>
  <transition
    enter-active-class="transform ease-out duration-300 transition"
    enter-from="translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2"
    enter-to="translate-y-0 opacity-100 sm:translate-x-0"
    leave-active-class="transition ease-in duration-100"
    leave-from="opacity-100"
    leave-to="opacity-0"
  >
    <div 
      v-if="show"
      :class="[bgColor[type || 'info']]"
      class="rounded-lg p-4 shadow-lg fixed bottom-4 right-4 max-w-sm w-full z-50"
    >
      <div class="flex">
        <div class="flex-shrink-0">
          <svg 
            :class="[iconColor[type || 'info']]"
            class="h-5 w-5" 
            viewBox="0 0 20 20" 
            fill="currentColor"
          >
            <path 
              v-if="type === 'success'"
              fill-rule="evenodd" 
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" 
              clip-rule="evenodd" 
            />
            <path 
              v-else-if="type === 'error'"
              fill-rule="evenodd" 
              d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" 
              clip-rule="evenodd" 
            />
            <path 
              v-else
              fill-rule="evenodd" 
              d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h2a1 1 0 100-2v-3a1 1 0 00-1-1H9z" 
              clip-rule="evenodd" 
            />
          </svg>
        </div>
        <div class="ml-3">
          <p :class="[textColor[type || 'info']]" class="text-sm font-medium">
            {{ message }}
          </p>
        </div>
        <div class="ml-auto pl-3">
          <div class="-mx-1.5 -my-1.5">
            <button
              type="button"
              :class="[textColor[type || 'info']]"
              class="inline-flex rounded-md p-1.5 focus:outline-none focus:ring-2 focus:ring-offset-2"
              @click="$emit('close')"
            >
              <XMarkIcon class="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
