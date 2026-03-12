// Mock API Server for Development
// Run with: node mock-server.js

import express from 'express'
import cors from 'cors'

const app = express()
const PORT = 3000

app.use(cors())
app.use(express.json())

// Mock dashboard data
const mockDashboardData = {
  user: {
    name: "Ahmed Yahia",
    username: "@y7ia007",
    avatar: "https://i.pravatar.cc/150?img=12"
  },
  stats: {
    appointments: 3,
    prescriptions: 1,
    pending_tests: 2
  },
  nextAppointment: {
    doctor: "Dr. Sarah Johnson",
    specialty: "Cardiologist",
    time: "Tomorrow, 2:30 PM",
    location: "City Medical Center",
    status: "Confirmed",
    avatar: "https://i.pravatar.cc/150?img=47"
  },
  healthOverview: {
    bloodType: "A+",
    allergies: "Penicillin",
    conditions: "Hypertension",
    primaryDoctor: "Dr. Sarah Johnson",
    primaryDoctorSpecialty: "Cardiologist",
    primaryDoctorAvatar: "https://i.pravatar.cc/150?img=47"
  },
  recentRecords: [
    {
      title: "Latest Prescription",
      doctor: "Dr. Michael Chen",
      date: "Jan 20, 2025",
      status: "Active"
    },
    {
      title: "Blood Test Results",
      doctor: "Lab Services",
      date: "Jan 18, 2025",
      status: "Available"
    },
    {
      title: "Visit Summary",
      doctor: "Dr. Sarah Johnson",
      date: "Jan 15, 2025",
      status: "Completed"
    }
  ],
  activity: [
    "Appointment confirmed",
    "Test result uploaded",
    "Prescription updated"
  ]
}

// Dashboard endpoint
app.get('/api/dashboard', (req, res) => {
  // Simulate network delay
  setTimeout(() => {
    res.json(mockDashboardData)
  }, 500)
})

// Book appointment endpoint
app.post('/api/appointments', (req, res) => {
  const appointmentData = req.body
  
  setTimeout(() => {
    res.json({
      success: true,
      message: "Appointment booked successfully",
      appointment: {
        id: Math.random().toString(36).substr(2, 9),
        ...appointmentData,
        status: "Confirmed"
      }
    })
  }, 500)
})

app.listen(PORT, () => {
  console.log(`Mock API server running on http://localhost:${PORT}`)
  console.log(`Dashboard endpoint: http://localhost:${PORT}/api/dashboard`)
})
