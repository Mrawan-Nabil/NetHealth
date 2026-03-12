# Mock API Server Setup

## Quick Start

### Option 1: Using Node.js (Recommended for testing)

1. Install dependencies:
```bash
npm install express cors
```

2. Run the mock server:
```bash
node mock-server.js
```

3. The server will start on `http://localhost:3000`

### Option 2: Using JSON Server (Alternative)

1. Install JSON Server globally:
```bash
npm install -g json-server
```

2. Create `db.json`:
```json
{
  "dashboard": {
    "user": {
      "name": "Ahmed Yahia",
      "username": "@y7ia007",
      "avatar": "https://i.pravatar.cc/150?img=12"
    },
    "stats": {
      "appointments": 3,
      "prescriptions": 1,
      "pending_tests": 2
    },
    "nextAppointment": {
      "doctor": "Dr. Sarah Johnson",
      "specialty": "Cardiologist",
      "time": "Tomorrow, 2:30 PM",
      "location": "City Medical Center",
      "status": "Confirmed",
      "avatar": "https://i.pravatar.cc/150?img=47"
    },
    "healthOverview": {
      "bloodType": "A+",
      "allergies": "Penicillin",
      "conditions": "Hypertension",
      "primaryDoctor": "Dr. Sarah Johnson",
      "primaryDoctorSpecialty": "Cardiologist",
      "primaryDoctorAvatar": "https://i.pravatar.cc/150?img=47"
    },
    "recentRecords": [
      {
        "title": "Latest Prescription",
        "doctor": "Dr. Michael Chen",
        "date": "Jan 20, 2025",
        "status": "Active"
      },
      {
        "title": "Blood Test Results",
        "doctor": "Lab Services",
        "date": "Jan 18, 2025",
        "status": "Available"
      },
      {
        "title": "Visit Summary",
        "doctor": "Dr. Sarah Johnson",
        "date": "Jan 15, 2025",
        "status": "Completed"
      }
    ],
    "activity": [
      "Appointment confirmed",
      "Test result uploaded",
      "Prescription updated"
    ]
  }
}
```

3. Run JSON Server:
```bash
json-server --watch db.json --port 3000
```

4. Access endpoint: `http://localhost:3000/dashboard`

## Testing the API

### Using cURL
```bash
curl http://localhost:3000/api/dashboard
```

### Using Browser
Open: `http://localhost:3000/api/dashboard`

### Using Postman
1. Create new GET request
2. URL: `http://localhost:3000/api/dashboard`
3. Send request

## Integration with Frontend

1. Create `.env` file:
```env
VITE_API_BASE_URL=http://localhost:3000
```

2. Start both servers:
```bash
# Terminal 1: Mock API
node mock-server.js

# Terminal 2: Frontend
npm run dev
```

3. Access dashboard: `http://localhost:5173/dashboard`

## Customizing Mock Data

Edit `mock-server.js` and modify the `mockDashboardData` object to test different scenarios:

### Example: Different user
```javascript
user: {
  name: "John Doe",
  username: "@johndoe",
  avatar: "https://i.pravatar.cc/150?img=33"
}
```

### Example: No appointments
```javascript
nextAppointment: null
```

### Example: Different status
```javascript
nextAppointment: {
  ...
  status: "Pending" // or "Cancelled"
}
```

## Troubleshooting

### Port already in use
Change the port in `mock-server.js`:
```javascript
const PORT = 3001 // Use different port
```

And update `.env`:
```env
VITE_API_BASE_URL=http://localhost:3001
```

### CORS errors
The mock server includes CORS middleware. If issues persist, check browser console and ensure the API URL is correct.

### Connection refused
Ensure the mock server is running before starting the frontend.
