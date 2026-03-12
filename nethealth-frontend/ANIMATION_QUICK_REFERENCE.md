# 🎨 Animation Quick Reference Guide

## 🚀 Quick Start

### Import Animation Utilities:
```javascript
import { useAnimations, animationClasses } from '@/composables/useAnimations'
```

---

## 📚 CSS Animation Classes

### Fade Animations:
```html
<div class="animate-fade-in">Fade In</div>
<div class="animate-fade-in-up">Fade In Up</div>
<div class="animate-fade-in-down">Fade In Down</div>
<div class="animate-fade-in-left">Fade In Left</div>
<div class="animate-fade-in-right">Fade In Right</div>
```

### Scale & Slide:
```html
<div class="animate-scale-in">Scale In</div>
<div class="animate-slide-in-up">Slide Up</div>
<div class="animate-slide-in-down">Slide Down</div>
<div class="animate-slide-in-left">Slide Left</div>
<div class="animate-slide-in-right">Slide Right</div>
```

### Effects:
```html
<div class="animate-bounce">Bounce</div>
<div class="animate-shake">Shake</div>
<div class="animate-pulse-slow">Pulse</div>
<div class="animate-shimmer">Shimmer</div>
<div class="animate-spin">Spin</div>
<div class="animate-glow">Glow</div>
```

### Hover Effects:
```html
<div class="hover-lift">Lift on Hover</div>
<div class="hover-scale">Scale on Hover</div>
<div class="hover-glow">Glow on Hover</div>
<div class="card-interactive">Interactive Card</div>
```

### Stagger Delays:
```html
<div class="animate-fade-in-up stagger-1">Item 1</div>
<div class="animate-fade-in-up stagger-2">Item 2</div>
<div class="animate-fade-in-up stagger-3">Item 3</div>
```

---

## 🎯 JavaScript Functions

### Stagger Animation:
```javascript
const { staggerAnimation } = useAnimations()

onMounted(() => {
  staggerAnimation('.card', 100) // 100ms delay between items
})
```

### Scroll Reveal:
```javascript
const { scrollReveal } = useAnimations()

onMounted(() => {
  scrollReveal('.reveal-item', {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  })
})
```

### Ripple Effect:
```javascript
const { createRipple } = useAnimations()

<button @click="createRipple">Click Me</button>
```

### Smooth Scroll:
```javascript
const { smoothScrollTo } = useAnimations()

const scrollToSection = () => {
  smoothScrollTo('#section-id', 100) // 100px offset
}
```

### Number Counter:
```javascript
const count = ref(0)
const { animateNumber } = useAnimations()

const startCounter = () => {
  animateNumber(0, 100, 2000, (value) => {
    count.value = value
  })
}
```

### Shake Element:
```javascript
const { shake } = useAnimations()

const shakeButton = (event) => {
  shake(event.target)
}
```

### Pulse Element:
```javascript
const { pulse } = useAnimations()

const pulseCard = (element) => {
  pulse(element, 1000) // 1 second
}
```

### Cross Fade:
```javascript
const { crossFade } = useAnimations()

const switchContent = async () => {
  await crossFade(oldElement, newElement, 300)
}
```

### Slide Animation:
```javascript
const { slide } = useAnimations()

const slideElement = (element) => {
  slide(element, 'up', 300) // direction: up, down, left, right
}
```

### Page Transition:
```javascript
const { pageTransition } = useAnimations()

const navigateWithTransition = async () => {
  await pageTransition(async () => {
    await router.push('/new-page')
  })
}
```

---

## 🎨 Common Patterns

### Animated Card List:
```vue
<template>
  <div class="grid grid-cols-3 gap-4">
    <div 
      v-for="(item, index) in items" 
      :key="item.id"
      class="card-interactive hover-lift animate-fade-in-up"
      :class="`stagger-${Math.min(index + 1, 5)}`"
    >
      {{ item.name }}
    </div>
  </div>
</template>
```

### Loading Skeleton:
```vue
<template>
  <div v-if="loading" class="space-y-4">
    <div v-for="i in 3" :key="i" class="skeleton h-20 rounded-lg"></div>
  </div>
  <div v-else class="animate-fade-in">
    <!-- Content -->
  </div>
</template>
```

### Interactive Button:
```vue
<template>
  <button 
    class="btn-ripple hover-scale transition-all-smooth"
    @click="createRipple"
  >
    Click Me
  </button>
</template>

<script setup>
import { useAnimations } from '@/composables/useAnimations'
const { createRipple } = useAnimations()
</script>
```

### Modal with Animation:
```vue
<template>
  <Transition name="modal">
    <div v-if="isOpen" class="fixed inset-0 z-50">
      <div class="modal-backdrop" @click="close"></div>
      <div class="modal-content animate-scale-in">
        <!-- Modal content -->
      </div>
    </div>
  </Transition>
</template>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
</style>
```

### Stats Counter:
```vue
<template>
  <div class="text-4xl font-bold">{{ displayCount }}</div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useAnimations } from '@/composables/useAnimations'

const displayCount = ref(0)
const { animateNumber } = useAnimations()

onMounted(() => {
  animateNumber(0, 1234, 2000, (value) => {
    displayCount.value = value
  })
})
</script>
```

### Scroll Reveal Section:
```vue
<template>
  <section class="reveal-section">
    <h2>Section Title</h2>
    <p>Section content</p>
  </section>
</template>

<script setup>
import { onMounted } from 'vue'
import { useAnimations } from '@/composables/useAnimations'

const { scrollReveal } = useAnimations()

onMounted(() => {
  scrollReveal('.reveal-section')
})
</script>
```

---

## 🎯 Best Practices

### 1. Use Stagger for Lists:
```javascript
// Good
onMounted(() => {
  staggerAnimation('.list-item', 100)
})

// Better - with cleanup
onMounted(() => {
  const observer = scrollReveal('.list-item')
  
  onUnmounted(() => {
    observer.disconnect()
  })
})
```

### 2. Combine Animations:
```html
<div class="animate-fade-in-up hover-lift card-interactive">
  Combined animations
</div>
```

### 3. Respect User Preferences:
```css
/* Automatically handled in animations.css */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
  }
}
```

### 4. Use Transitions for State Changes:
```vue
<Transition name="fade">
  <div v-if="show">Content</div>
</Transition>
```

### 5. Optimize Performance:
```javascript
// Use requestAnimationFrame for smooth animations
const animate = () => {
  // Animation logic
  requestAnimationFrame(animate)
}
```

---

## 🔧 Customization

### Custom Animation Duration:
```html
<div 
  class="animate-fade-in-up" 
  style="animation-duration: 0.5s"
>
  Custom duration
</div>
```

### Custom Delay:
```html
<div 
  class="animate-fade-in-up" 
  style="animation-delay: 0.3s"
>
  Delayed animation
</div>
```

### Custom Easing:
```html
<div 
  class="animate-fade-in-up" 
  style="animation-timing-function: cubic-bezier(0.4, 0, 0.2, 1)"
>
  Custom easing
</div>
```

---

## 📱 Responsive Animations

### Mobile-First Approach:
```html
<!-- Animate only on larger screens -->
<div class="md:animate-fade-in-up">
  Content
</div>

<!-- Different animations for different screens -->
<div class="animate-fade-in md:animate-slide-in-right">
  Responsive animation
</div>
```

---

## 🎨 Theme-Aware Animations

### Dark Mode Glow:
```html
<div class="animate-glow dark:shadow-teal-500/50">
  Glowing element
</div>
```

### Theme-Based Skeleton:
```html
<div class="skeleton dark:skeleton-dark">
  Loading...
</div>
```

---

## ⚡ Performance Tips

1. **Use CSS animations** for simple effects (better performance)
2. **Use JavaScript animations** for complex interactions
3. **Avoid animating expensive properties** (width, height, top, left)
4. **Prefer transform and opacity** (GPU accelerated)
5. **Use will-change** sparingly for critical animations
6. **Debounce scroll events** for scroll-based animations
7. **Use IntersectionObserver** for scroll reveal
8. **Clean up observers** in onUnmounted

---

## 🐛 Troubleshooting

### Animation Not Working:
1. Check if CSS file is imported
2. Verify class name spelling
3. Check if element is visible
4. Inspect animation-fill-mode
5. Check for conflicting styles

### Performance Issues:
1. Reduce number of animated elements
2. Use CSS instead of JavaScript
3. Optimize animation duration
4. Use transform instead of position
5. Enable GPU acceleration

### Accessibility Issues:
1. Respect prefers-reduced-motion
2. Provide alternative content
3. Ensure keyboard navigation works
4. Test with screen readers
5. Add ARIA labels

---

## 📚 Resources

- [MDN Web Animations API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API)
- [CSS Tricks - Animation](https://css-tricks.com/almanac/properties/a/animation/)
- [Vue Transitions](https://vuejs.org/guide/built-ins/transition.html)
- [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API)

---

## 🎉 Happy Animating!

Your dashboard now has a complete animation system. Use these utilities to create smooth, modern, and engaging user experiences!
