<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{
  categories: string[]
  modelValue?: string
}>()

const emit = defineEmits(['update:modelValue'])

const selectedCategory = ref<string>('')

watch(selectedCategory, (newVal) => {
  emit('update:modelValue', newVal)
})

// Initialize with first category if available
watch(
  () => props.categories,
  (newCategories) => {
    if (newCategories.length > 0 && !selectedCategory.value) {
      selectedCategory.value = newCategories[0]
    }
  },
  { immediate: true }
)
</script>

<template>
  <div class="border-b border-gray-200">
    <nav class="-mb-px flex space-x-8 overflow-x-auto">
      <button
        v-for="category in categories"
        :key="category"
        @click="selectedCategory = category"
        :class="[
          selectedCategory === category
            ? 'border-amber-500 text-amber-600'
            : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300',
          'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm'
        ]"
      >
        {{ category }}
      </button>
    </nav>
  </div>
</template>
