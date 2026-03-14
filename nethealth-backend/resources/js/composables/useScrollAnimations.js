import { ref, onMounted, onUnmounted } from 'vue'

export function useScrollAnimations() {
  const isVisible = ref(false)
  
  const observeElements = (selector = '.scroll-reveal', threshold = 0.1) => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('revealed')
          }
        })
      },
      { 
        threshold,
        rootMargin: '50px 0px -50px 0px'
      }
    )

    // Observe all elements with the selector
    const elements = document.querySelectorAll(selector)
    elements.forEach((element) => {
      observer.observe(element)
    })

    return observer
  }

  const setupParallax = () => {
    let ticking = false

    const updateParallax = () => {
      const scrolled = window.pageYOffset
      const parallaxElements = document.querySelectorAll('.parallax-element')
      
      parallaxElements.forEach((element, index) => {
        const speed = 0.3 + (index * 0.1)
        const yPos = -(scrolled * speed)
        element.style.transform = `translateY(${yPos}px)`
      })
      
      ticking = false
    }

    const handleScroll = () => {
      if (!ticking) {
        requestAnimationFrame(updateParallax)
        ticking = true
      }
    }

    window.addEventListener('scroll', handleScroll, { passive: true })
    
    return () => {
      window.removeEventListener('scroll', handleScroll)
    }
  }

  const setupSmoothScroll = () => {
    document.documentElement.style.scrollBehavior = 'smooth'
  }

  onMounted(() => {
    // Setup scroll animations
    const observer = observeElements()
    const cleanupParallax = setupParallax()
    setupSmoothScroll()

    // Cleanup function
    onUnmounted(() => {
      observer.disconnect()
      cleanupParallax()
    })
  })

  return {
    isVisible,
    observeElements,
    setupParallax,
    setupSmoothScroll
  }
}

// Dark mode detection and handling
export function useDarkMode() {
  const isDark = ref(false)

  const updateDarkMode = () => {
    isDark.value = document.documentElement.classList.contains('dark')
  }

  onMounted(() => {
    updateDarkMode()
    
    // Watch for dark mode changes
    const observer = new MutationObserver(updateDarkMode)
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['class']
    })

    onUnmounted(() => {
      observer.disconnect()
    })
  })

  return {
    isDark
  }
}

// Smooth scroll to element
export function scrollToElement(elementId) {
  const element = document.getElementById(elementId)
  if (element) {
    element.scrollIntoView({
      behavior: 'smooth',
      block: 'start'
    })
  }
}