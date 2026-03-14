import { ref, onMounted } from 'vue'

/**
 * Animation utilities composable
 * Provides reusable animation functions and utilities
 */
export function useAnimations() {
  const isAnimating = ref(false)

  /**
   * Stagger animation for list items
   * @param {string} selector - CSS selector for items to animate
   * @param {number} delay - Delay between each item (ms)
   */
  const staggerAnimation = (selector, delay = 100) => {
    const elements = document.querySelectorAll(selector)
    elements.forEach((el, index) => {
      el.style.animationDelay = `${index * delay}ms`
      el.classList.add('animate-fade-in-up')
    })
  }

  /**
   * Scroll reveal animation
   * @param {string} selector - CSS selector for elements
   * @param {object} options - Intersection Observer options
   */
  const scrollReveal = (selector, options = {}) => {
    const defaultOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px',
      ...options
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-fade-in-up')
          observer.unobserve(entry.target)
        }
      })
    }, defaultOptions)

    const elements = document.querySelectorAll(selector)
    elements.forEach(el => {
      el.style.opacity = '0'
      observer.observe(el)
    })

    return observer
  }

  /**
   * Ripple effect on click
   * @param {Event} event - Click event
   */
  const createRipple = (event) => {
    const button = event.currentTarget
    const ripple = document.createElement('span')
    const diameter = Math.max(button.clientWidth, button.clientHeight)
    const radius = diameter / 2

    ripple.style.width = ripple.style.height = `${diameter}px`
    ripple.style.left = `${event.clientX - button.offsetLeft - radius}px`
    ripple.style.top = `${event.clientY - button.offsetTop - radius}px`
    ripple.classList.add('ripple')

    const existingRipple = button.getElementsByClassName('ripple')[0]
    if (existingRipple) {
      existingRipple.remove()
    }

    button.appendChild(ripple)

    setTimeout(() => {
      ripple.remove()
    }, 600)
  }

  /**
   * Smooth scroll to element
   * @param {string} selector - CSS selector or element ID
   * @param {number} offset - Offset from top (px)
   */
  const smoothScrollTo = (selector, offset = 0) => {
    const element = document.querySelector(selector)
    if (element) {
      const top = element.getBoundingClientRect().top + window.pageYOffset - offset
      window.scrollTo({
        top,
        behavior: 'smooth'
      })
    }
  }

  /**
   * Animate number counter
   * @param {number} start - Starting number
   * @param {number} end - Ending number
   * @param {number} duration - Animation duration (ms)
   * @param {function} callback - Callback function with current value
   */
  const animateNumber = (start, end, duration, callback) => {
    const startTime = performance.now()
    const difference = end - start

    const step = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      
      // Easing function (ease-out)
      const easeOut = 1 - Math.pow(1 - progress, 3)
      const current = start + (difference * easeOut)
      
      callback(Math.round(current))

      if (progress < 1) {
        requestAnimationFrame(step)
      }
    }

    requestAnimationFrame(step)
  }

  /**
   * Shake animation for error states
   * @param {HTMLElement} element - Element to shake
   */
  const shake = (element) => {
    element.classList.add('animate-shake')
    setTimeout(() => {
      element.classList.remove('animate-shake')
    }, 500)
  }

  /**
   * Pulse animation
   * @param {HTMLElement} element - Element to pulse
   * @param {number} duration - Duration in ms
   */
  const pulse = (element, duration = 1000) => {
    element.classList.add('animate-pulse-slow')
    setTimeout(() => {
      element.classList.remove('animate-pulse-slow')
    }, duration)
  }

  /**
   * Fade transition between elements
   * @param {HTMLElement} oldElement - Element to fade out
   * @param {HTMLElement} newElement - Element to fade in
   * @param {number} duration - Transition duration (ms)
   */
  const crossFade = async (oldElement, newElement, duration = 300) => {
    isAnimating.value = true

    // Fade out old element
    oldElement.style.transition = `opacity ${duration}ms ease`
    oldElement.style.opacity = '0'

    await new Promise(resolve => setTimeout(resolve, duration))

    // Hide old, show new
    oldElement.style.display = 'none'
    newElement.style.display = 'block'
    newElement.style.opacity = '0'

    // Fade in new element
    requestAnimationFrame(() => {
      newElement.style.transition = `opacity ${duration}ms ease`
      newElement.style.opacity = '1'
    })

    await new Promise(resolve => setTimeout(resolve, duration))
    isAnimating.value = false
  }

  /**
   * Slide animation
   * @param {HTMLElement} element - Element to slide
   * @param {string} direction - Direction: 'up', 'down', 'left', 'right'
   * @param {number} duration - Duration in ms
   */
  const slide = (element, direction = 'up', duration = 300) => {
    const animations = {
      up: 'animate-slide-in-up',
      down: 'animate-slide-in-down',
      left: 'animate-slide-in-left',
      right: 'animate-slide-in-right'
    }

    element.classList.add(animations[direction])
    setTimeout(() => {
      element.classList.remove(animations[direction])
    }, duration)
  }

  /**
   * Bounce animation
   * @param {HTMLElement} element - Element to bounce
   */
  const bounce = (element) => {
    element.classList.add('animate-bounce')
    setTimeout(() => {
      element.classList.remove('animate-bounce')
    }, 1000)
  }

  /**
   * Loading skeleton animation
   * @param {boolean} show - Show or hide skeleton
   */
  const toggleSkeleton = (show) => {
    const skeletons = document.querySelectorAll('.skeleton')
    skeletons.forEach(skeleton => {
      if (show) {
        skeleton.classList.add('animate-shimmer')
      } else {
        skeleton.classList.remove('animate-shimmer')
      }
    })
  }

  /**
   * Page transition
   * @param {function} callback - Function to execute during transition
   */
  const pageTransition = async (callback) => {
    isAnimating.value = true
    
    // Fade out
    document.body.style.opacity = '0'
    await new Promise(resolve => setTimeout(resolve, 200))
    
    // Execute callback
    if (callback) await callback()
    
    // Fade in
    document.body.style.opacity = '1'
    await new Promise(resolve => setTimeout(resolve, 200))
    
    isAnimating.value = false
  }

  return {
    isAnimating,
    staggerAnimation,
    scrollReveal,
    createRipple,
    smoothScrollTo,
    animateNumber,
    shake,
    pulse,
    crossFade,
    slide,
    bounce,
    toggleSkeleton,
    pageTransition
  }
}

/**
 * CSS class utilities for animations
 */
export const animationClasses = {
  fadeIn: 'animate-fade-in',
  fadeInUp: 'animate-fade-in-up',
  fadeInDown: 'animate-fade-in-down',
  fadeInLeft: 'animate-fade-in-left',
  fadeInRight: 'animate-fade-in-right',
  scaleIn: 'animate-scale-in',
  slideInRight: 'animate-slide-in-right',
  slideInLeft: 'animate-slide-in-left',
  slideInUp: 'animate-slide-in-up',
  slideInDown: 'animate-slide-in-down',
  bounce: 'animate-bounce',
  pulse: 'animate-pulse-slow',
  shimmer: 'animate-shimmer',
  spin: 'animate-spin',
  glow: 'animate-glow',
  hoverLift: 'hover-lift',
  hoverScale: 'hover-scale',
  hoverGlow: 'hover-glow',
  cardInteractive: 'card-interactive',
  btnRipple: 'btn-ripple'
}

/**
 * Stagger delay utilities
 */
export const staggerDelays = {
  1: 'stagger-1',
  2: 'stagger-2',
  3: 'stagger-3',
  4: 'stagger-4',
  5: 'stagger-5'
}
