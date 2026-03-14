// API Service for Dashboard
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000'

export const dashboardAPI = {
  /**
   * Fetch dashboard data for the logged-in user
   * @returns {Promise<Object>} Dashboard data
   */
  async getDashboardData() {
    try {
      const response = await fetch(`${API_BASE_URL}/api/dashboard`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          // Add authentication token if needed
          // 'Authorization': `Bearer ${getAuthToken()}`
        },
        credentials: 'include' // Include cookies for authentication
      })

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      return await response.json()
    } catch (error) {
      console.error('Error fetching dashboard data:', error)
      throw error
    }
  },

  /**
   * Book a new appointment
   * @param {Object} appointmentData - Appointment details
   * @returns {Promise<Object>} Created appointment
   */
  async bookAppointment(appointmentData) {
    try {
      const response = await fetch(`${API_BASE_URL}/api/appointments`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify(appointmentData)
      })

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      return await response.json()
    } catch (error) {
      console.error('Error booking appointment:', error)
      throw error
    }
  }
}

// Helper function to get auth token (implement based on your auth system)
function getAuthToken() {
  return localStorage.getItem('authToken') || sessionStorage.getItem('authToken')
}
