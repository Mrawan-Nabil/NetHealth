# NetHealth — Backend Context for Flutter Development

> **Generated:** April 2026  
> **Source:** Blueprint (`nethealth_api_blueprint.md`) + Live codebase scan (migrations, models, enums)  
> **Purpose:** Single source of truth for the Flutter app's API integration layer. Feed this to your Flutter AI.  
> **Base URL:** `https://your-domain.com/api/v1`  
> **Auth:** Laravel Sanctum — Bearer Token in `Authorization` header.

---

## Section 1: Complete Route List

All endpoints live under the `/api/v1` prefix. Protected routes require `Authorization: Bearer <token>`.

### Public Routes (No Auth Required)

| Method | Path | Controller Action |
|--------|------|-------------------|
| `POST` | `/api/v1/auth/login` | `Api\AuthController@login` |
| `POST` | `/api/v1/auth/register/patient` | `Api\Auth\PatientRegistrationController@store` |

### Protected Routes (Sanctum Bearer Token Required)

| Method | Path | Controller Action |
|--------|------|-------------------|
| `GET` | `/api/v1/auth/me` | `Api\AuthController@me` |
| `POST` | `/api/v1/auth/logout` | `Api\AuthController@logout` |
| `GET` | `/api/v1/patient/dashboard` | `Api\Patient\DashboardApiController@index` |
| `GET` | `/api/v1/patient/doctors` | `Api\Patient\AppointmentApiController@getDoctors` |
| `GET` | `/api/v1/patient/doctors/{id}` | `Api\Patient\AppointmentApiController@showDoctor` |
| `GET` | `/api/v1/patient/appointments` | `Api\Patient\AppointmentApiController@index` |
| `POST` | `/api/v1/patient/appointments` | `Api\Patient\AppointmentApiController@store` |
| `GET` | `/api/v1/patient/appointments/{id}` | `Api\Patient\AppointmentApiController@show` |
| `DELETE` | `/api/v1/patient/appointments/{id}/cancel` | `Api\Patient\AppointmentApiController@cancel` |
| `GET` | `/api/v1/patient/medical-records` | `Api\Patient\MedicalRecordApiController@index` |
| `GET` | `/api/v1/patient/medical-records/{id}` | `Api\Patient\MedicalRecordApiController@show` |
| `GET` | `/api/v1/patient/prescriptions` | `Api\Patient\PrescriptionApiController@index` |
| `GET` | `/api/v1/patient/prescriptions/{id}` | `Api\Patient\PrescriptionApiController@show` |
| `GET` | `/api/v1/patient/test-results` | `Api\Patient\TestResultApiController@index` |
| `GET` | `/api/v1/patient/test-results/{id}` | `Api\Patient\TestResultApiController@show` |
| `GET` | `/api/v1/patient/imaging` | `Api\Patient\ImagingApiController@index` |
| `GET` | `/api/v1/patient/imaging/{id}` | `Api\Patient\ImagingApiController@show` |
| `GET` | `/api/v1/patient/visit-history` | `Api\Patient\VisitHistoryApiController@index` |
| `GET` | `/api/v1/patient/profile` | `Api\Patient\ProfileApiController@index` |
| `PATCH` | `/api/v1/patient/profile` | `Api\Patient\ProfileApiController@update` |
| `POST` | `/api/v1/patient/profile/avatar` | `Api\Patient\ProfileApiController@updateAvatar` |
| `POST` | `/api/v1/patient/profile/password` | `Api\Patient\ProfileApiController@changePassword` |

---

## Section 2: Standard Response Envelope

**Every single response** from the API — success or error — uses this wrapper.

### Success (200 OK)
```json
{
  "status": "success",
  "message": "Data retrieved successfully.",
  "data": { }
}
```

### Success — Created (201 Created)
```json
{
  "status": "success",
  "message": "Appointment booked successfully.",
  "data": { }
}
```

### Paginated Collection (200 OK)
```json
{
  "status": "success",
  "message": "Appointments retrieved.",
  "data": [ ],
  "meta": {
    "current_page": 1,
    "last_page": 4,
    "per_page": 15,
    "total": 52
  }
}
```

### Validation Error (422 Unprocessable Entity)
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "national_id": ["The national id has already been taken."],
    "email": ["The email field is required."]
  }
}
```

### Authentication Error (401 Unauthorized)
```json
{
  "status": "error",
  "message": "Unauthenticated."
}
```

### Authorization Error (403 Forbidden)
```json
{
  "status": "error",
  "message": "This action is unauthorized."
}
```

### Not Found (404)
```json
{
  "status": "error",
  "message": "Resource not found."
}
```

### Suspended Account (403 — during login)
```json
{
  "status": "error",
  "message": "Your account has been suspended."
}
```

---

## Section 3: Exact JSON Response Shapes

All datetime fields use **ISO 8601 UTC** format. All enum fields return their **raw string values** — no display formatting. The Flutter app is responsible for all presentation logic.

### `POST /api/v1/auth/login` & `POST /api/v1/auth/register/patient`

**Request (login):**
```json
{
  "email": "ahmed.hassan@example.com",
  "password": "secret123"
}
```

**Response (200 — active account):**
```json
{
  "status": "success",
  "token": "1|aB3cD4eF5gH6iJ7kL8mN9oP0qR1sT2uV3wX4yZ5",
  "token_type": "Bearer",
  "user": {
    "id": 14,
    "full_name": "Ahmed Hassan",
    "email": "ahmed.hassan@example.com",
    "role": "patient",
    "account_status": "active",
    "avatar_url": "https://ui-avatars.com/api/?name=Ahmed+Hassan&background=random"
  }
}
```

**Response (200 — pending account — issue token but Flutter shows waiting screen):**
```json
{
  "status": "success",
  "token": "2|bC3dE4fG5hI6jK7lM8nO9pQ0rS1tU2vW3xY4zA5",
  "token_type": "Bearer",
  "user": {
    "id": 22,
    "full_name": "Layla Ibrahim",
    "email": "layla@example.com",
    "role": "patient",
    "account_status": "pending",
    "avatar_url": "https://ui-avatars.com/api/?name=Layla+Ibrahim&background=random"
  }
}
```

**Request (register/patient) — all fields:**
```json
{
  "full_name": "Ahmed Hassan",
  "email": "ahmed.hassan@example.com",
  "password": "secret123",
  "password_confirmation": "secret123",
  "phone": "01012345678",
  "gender": "male",
  "birth_date": "1990-05-15",
  "governorate": "Cairo",
  "national_id": "29001011234567",
  "blood_type": "A+",
  "allergies": ["Penicillin", "Aspirin"],
  "chronic_conditions": "Hypertension",
  "emergency_contact_name": "Fatma Hassan",
  "emergency_contact_phone": "01098765432"
}
```

---

### `GET /api/v1/auth/me`

**Response (200):**
```json
{
  "status": "success",
  "message": "Data retrieved successfully.",
  "data": {
    "id": 14,
    "full_name": "Ahmed Hassan",
    "email": "ahmed.hassan@example.com",
    "role": "patient",
    "account_status": "active",
    "avatar_url": "https://your-domain.com/storage/avatars/ahmed_abc123.jpg"
  }
}
```

---

### `POST /api/v1/auth/logout`

**Response (200):**
```json
{
  "status": "success",
  "message": "Logged out successfully."
}
```

---

### `GET /api/v1/patient/dashboard`

**Response (200):**
```json
{
  "status": "success",
  "message": "Dashboard data retrieved.",
  "data": {
    "health_overview": {
      "blood_type": "A+",
      "allergies": ["Penicillin", "Aspirin"],
      "chronic_conditions": "Hypertension, Type 2 Diabetes",
      "primary_doctor": {
        "id": 7,
        "full_name": "Dr. Sara Kamel",
        "specialty": "Cardiology",
        "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg"
      }
    },
    "stats": {
      "upcoming_appointments": 2,
      "active_prescriptions": 1,
      "pending_tests": 3
    },
    "next_appointment": {
      "id": 45,
      "appointment_time": "2026-05-10T10:00:00Z",
      "appointment_status": "scheduled",
      "appointment_type": "physical",
      "visit_reason": "Follow-up consultation for hypertension",
      "doctor": {
        "id": 7,
        "full_name": "Dr. Sara Kamel",
        "specialty": "Cardiology",
        "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg"
      },
      "clinic": {
        "id": 3,
        "clinic_name": "Heart Care Center",
        "clinic_address": "15 Tahrir Square, Cairo"
      }
    },
    "recent_records": [
      {
        "appointment_id": 38,
        "doctor_full_name": "Dr. Sara Kamel",
        "appointment_time": "2026-04-01T09:00:00Z",
        "status": "completed"
      },
      {
        "appointment_id": 31,
        "doctor_full_name": "Dr. Youssef Naguib",
        "appointment_time": "2026-03-15T11:30:00Z",
        "status": "completed"
      }
    ]
  }
}
```

> **Note:** `primary_doctor` is null if the patient has no completed appointments. `next_appointment` is null if no upcoming appointments exist. Always null-check these fields in Flutter.

---

### `GET /api/v1/patient/appointments` (paginated list)

**Query params:** `?status=scheduled&per_page=15&page=1`

**Response (200):**
```json
{
  "status": "success",
  "message": "Appointments retrieved.",
  "data": [
    {
      "id": 45,
      "appointment_time": "2026-05-10T10:00:00Z",
      "appointment_status": "scheduled",
      "appointment_type": "physical",
      "visit_reason": "Follow-up consultation for hypertension",
      "cancelled_by": null,
      "cancellation_reason": null,
      "doctor": {
        "id": 7,
        "full_name": "Dr. Sara Kamel",
        "specialty": "Cardiology",
        "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg",
        "consultation_fee": 350
      },
      "clinic": {
        "id": 3,
        "clinic_name": "Heart Care Center",
        "clinic_address": "15 Tahrir Square, Cairo",
        "clinic_governorate": "Cairo"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 15,
    "total": 42
  }
}
```

---

### `GET /api/v1/patient/appointments/{id}` (full detail)

**Response (200):**
```json
{
  "status": "success",
  "message": "Appointment retrieved.",
  "data": {
    "id": 45,
    "appointment_time": "2026-05-10T10:00:00Z",
    "appointment_status": "scheduled",
    "appointment_type": "physical",
    "visit_reason": "Follow-up consultation for hypertension",
    "cancelled_by": null,
    "cancellation_reason": null,
    "doctor": {
      "id": 7,
      "full_name": "Dr. Sara Kamel",
      "specialty": "Cardiology",
      "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg",
      "consultation_fee": 350
    },
    "clinic": {
      "id": 3,
      "clinic_name": "Heart Care Center",
      "clinic_address": "15 Tahrir Square, Cairo",
      "clinic_phone": "0223456789",
      "clinic_governorate": "Cairo"
    },
    "medical_record": {
      "id": 29,
      "record_status": "closed",
      "diagnosis_notes": "Blood pressure well-controlled. Continue current medication regimen.",
      "created_at": "2026-04-01T09:45:00Z",
      "diagnoses": [
        {
          "id": 12,
          "description": "Essential hypertension, stage 1. BP 130/85 mmHg at visit.",
          "created_at": "2026-04-01T09:45:00Z"
        }
      ],
      "prescriptions": [
        {
          "id": 8,
          "prescription_status": "issued",
          "created_at": "2026-04-01T09:50:00Z"
        }
      ],
      "attachments_count": 1
    }
  }
}
```

---

### `GET /api/v1/patient/doctors` (doctor search list)

**Query params:** `?specialty=Cardiology&search=Sara&per_page=20`

**Response (200):**
```json
{
  "status": "success",
  "message": "Doctors retrieved.",
  "data": [
    {
      "id": 7,
      "full_name": "Dr. Sara Kamel",
      "specialty": "Cardiology",
      "professional_title": "consultant",
      "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg",
      "consultation_fee": 350,
      "clinic_name": "Heart Care Center",
      "experience": "12 years of experience in interventional cardiology and echocardiography.",
      "qualifications": "MD, Cairo University | Fellowship in Cardiology, AUC"
    },
    {
      "id": 11,
      "full_name": "Dr. Youssef Naguib",
      "specialty": "Neurology",
      "professional_title": "specialist",
      "avatar_url": "https://ui-avatars.com/api/?name=Youssef+Naguib&background=random",
      "consultation_fee": 400,
      "clinic_name": "NeuroSense Clinic",
      "experience": "8 years of experience in epilepsy management and stroke rehabilitation.",
      "qualifications": "MD, Ain Shams University | MSc in Neurology"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 2,
    "per_page": 20,
    "total": 35
  }
}
```

> **Note:** `rating` and `reviews` fields do NOT exist in this API. They were web-layer placeholders using `rand()` and are intentionally omitted.

---

### `GET /api/v1/patient/doctors/{id}` (full doctor profile)

**Response (200):**
```json
{
  "status": "success",
  "message": "Doctor profile retrieved.",
  "data": {
    "id": 7,
    "full_name": "Dr. Sara Kamel",
    "specialty": "Cardiology",
    "professional_title": "consultant",
    "medical_license": "ML-2014-00347",
    "syndicate_id": "SYN-20140892",
    "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg",
    "consultation_fee": 350,
    "clinic_name": "Heart Care Center",
    "experience": "12 years of experience in interventional cardiology and echocardiography.",
    "qualifications": "MD, Cairo University | Fellowship in Cardiology, AUC"
  }
}
```

---

### `POST /api/v1/patient/appointments` (book appointment)

**Request:**
```json
{
  "doctor_id": 7,
  "appointment_time": "2026-06-15T14:00:00Z",
  "appointment_type": "physical",
  "visit_reason": "Annual cardiac check-up and ECG review"
}
```

**Response (201):**
```json
{
  "status": "success",
  "message": "Appointment booked successfully.",
  "data": {
    "id": 78,
    "appointment_time": "2026-06-15T14:00:00Z",
    "appointment_status": "scheduled",
    "appointment_type": "physical",
    "visit_reason": "Annual cardiac check-up and ECG review",
    "cancelled_by": null,
    "cancellation_reason": null,
    "doctor": {
      "id": 7,
      "full_name": "Dr. Sara Kamel",
      "specialty": "Cardiology",
      "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg",
      "consultation_fee": 350
    },
    "clinic": {
      "id": 3,
      "clinic_name": "Heart Care Center",
      "clinic_address": "15 Tahrir Square, Cairo",
      "clinic_governorate": "Cairo"
    }
  }
}
```

> **DB note:** The `visit_reason` field in the request maps directly to the `appointments.visit_reason` column.

---

### `DELETE /api/v1/patient/appointments/{id}/cancel`

**Request (body is optional):**
```json
{
  "reason": "Schedule conflict — need to reschedule"
}
```

**Response (200):**
```json
{
  "status": "success",
  "message": "Appointment cancelled successfully.",
  "data": {
    "id": 45,
    "appointment_status": "cancelled",
    "appointment_time": "2026-05-10T10:00:00Z",
    "appointment_type": "physical",
    "visit_reason": "Follow-up consultation for hypertension",
    "cancelled_by": null,
    "cancellation_reason": null,
    "doctor": { },
    "clinic": { }
  }
}
```

> **Note:** Only `scheduled` appointments can be cancelled. Returns `422` if already `completed` or `cancelled`.

---

### `GET /api/v1/patient/medical-records` (paginated list)

**Response (200):**
```json
{
  "status": "success",
  "message": "Medical records retrieved.",
  "data": [
    {
      "id": 29,
      "record_status": "closed",
      "diagnosis_notes": "Blood pressure well-controlled. Continue current medication.",
      "created_at": "2026-04-01T09:45:00Z",
      "diagnoses_count": 1,
      "attachments_count": 2,
      "doctor": {
        "id": 7,
        "full_name": "Dr. Sara Kamel",
        "specialty": "Cardiology",
        "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg"
      },
      "appointment": {
        "id": 45,
        "appointment_time": "2026-04-01T09:00:00Z",
        "appointment_type": "physical",
        "clinic": {
          "id": 3,
          "clinic_name": "Heart Care Center"
        }
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 2,
    "per_page": 15,
    "total": 18
  }
}
```

---

### `GET /api/v1/patient/medical-records/{id}` (full detail)

**Response (200):**
```json
{
  "status": "success",
  "message": "Medical record retrieved.",
  "data": {
    "id": 29,
    "record_status": "closed",
    "diagnosis_notes": "Blood pressure well-controlled. Continue current medication regimen.",
    "created_at": "2026-04-01T09:45:00Z",
    "doctor": {
      "id": 7,
      "full_name": "Dr. Sara Kamel",
      "specialty": "Cardiology",
      "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg"
    },
    "appointment": {
      "id": 45,
      "appointment_time": "2026-04-01T09:00:00Z",
      "appointment_type": "physical",
      "clinic": {
        "id": 3,
        "clinic_name": "Heart Care Center",
        "clinic_address": "15 Tahrir Square, Cairo"
      }
    },
    "diagnoses": [
      {
        "id": 12,
        "description": "Essential hypertension, stage 1. BP 130/85 mmHg at visit.",
        "created_at": "2026-04-01T09:45:00Z"
      }
    ],
    "attachments": [
      {
        "id": 55,
        "attachment_type": "lab_result",
        "attachment_name": "Lipid Panel Report",
        "test_result_status": "reviewed",
        "uploaded_at": "2026-04-01T10:00:00Z"
      }
    ],
    "prescriptions": [
      {
        "id": 8,
        "prescription_status": "issued",
        "created_at": "2026-04-01T09:50:00Z"
      }
    ]
  }
}
```

---

### `GET /api/v1/patient/prescriptions` (paginated list)

**Query params:** `?status=issued&per_page=15`

**Response (200):**
```json
{
  "status": "success",
  "message": "Prescriptions retrieved.",
  "data": [
    {
      "id": 8,
      "prescription_status": "issued",
      "created_at": "2026-04-01T09:50:00Z",
      "expires_at": "2026-05-01T09:50:00Z",
      "diagnosis_notes": "Blood pressure well-controlled. Continue current medication regimen.",
      "medicines": ["Amlodipine", "Ramipril"],
      "doctor": {
        "id": 7,
        "full_name": "Dr. Sara Kamel",
        "specialty": "Cardiology",
        "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 15,
    "total": 5
  }
}
```

> **Note:** `expires_at` is computed as `created_at + 30 days`. It is not a DB column.

---

### `GET /api/v1/patient/prescriptions/{id}` (full detail)

**Response (200):**
```json
{
  "status": "success",
  "message": "Prescription retrieved.",
  "data": {
    "id": 8,
    "generated_date": "2026-04-01T09:50:00Z",
    "prescription_status": "issued",
    "notes": [
      "Take medications with food.",
      "Avoid excessive sodium intake.",
      "Return in 4 weeks for follow-up BP check."
    ],
    "doctor": {
      "full_name": "Dr. Sara Kamel",
      "specialty": "Cardiology",
      "professional_title": "consultant",
      "medical_license": "ML-2014-00347",
      "syndicate_id": "SYN-20140892",
      "phone": "01011223344",
      "account_status": "active",
      "clinic_address": "15 Tahrir Square, Cairo",
      "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg"
    },
    "patient": {
      "full_name": "Ahmed Hassan",
      "gender": "male",
      "age": 36,
      "patient_id_string": "#PT-00000014"
    },
    "diagnosis": {
      "title": "Essential Hypertension",
      "description": "Blood pressure well-controlled. Continue current medication regimen."
    },
    "medicines": [
      {
        "name": "Amlodipine",
        "category": "Calcium Channel Blocker",
        "dosage": "5mg",
        "frequency": "Once daily",
        "duration_days": 30,
        "instructions": "Take in the morning with or without food."
      },
      {
        "name": "Ramipril",
        "category": "ACE Inhibitor",
        "dosage": "10mg",
        "frequency": "Once daily",
        "duration_days": 30,
        "instructions": "Take at the same time each day. Monitor potassium levels."
      }
    ]
  }
}
```

> **DB mapping note:** `diagnosis.title` has no direct DB column — it is derived from the first diagnosis `description`. `diagnosis.description` comes from `medical_records.diagnosis_notes`. `medicines[].instructions` maps to `prescription_items.notes` (no — `prescription_items` has no `notes` column; this field maps to the prescription `notes` split per item — see blueprint note). `medicines[].name` is from `medicines.name`, `category` from `medicines.category`. `prescription_items` columns: `dosage` (string), `frequency` (string), `duration_days` (integer).

---

### `GET /api/v1/patient/test-results` (paginated list)

**Query params:** `?status=pending&per_page=15`

**Response (200):**
```json
{
  "status": "success",
  "message": "Test results retrieved.",
  "data": [
    {
      "id": 55,
      "name": "Lipid Panel Report",
      "category": "Lab Result",
      "test_result_status": "reviewed",
      "uploaded_at": "2026-04-01T10:00:00Z"
    },
    {
      "id": 61,
      "name": "CBC - Complete Blood Count",
      "category": "Lab Result",
      "test_result_status": "pending",
      "uploaded_at": "2026-04-10T14:30:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 2,
    "per_page": 15,
    "total": 21
  }
}
```

> **Important:** `test_result_status` returns raw enum values `"pending"` or `"reviewed"` only. Never `"VERIFIED"` — that is a web UI string, not an API value.

---

### `GET /api/v1/patient/test-results/{id}` (full detail with file)

**Response (200):**
```json
{
  "status": "success",
  "message": "Test result retrieved.",
  "data": {
    "id": 55,
    "name": "Lipid Panel Report",
    "category": "Lab Result",
    "test_result_status": "reviewed",
    "uploaded_at": "2026-04-01T10:00:00Z",
    "notes": "Results reviewed by Dr. Sara Kamel. LDL elevated — dietary changes recommended.",
    "file_url": "https://your-domain.com/storage/attachments/lipid_panel_report.pdf",
    "mime_type": "application/pdf"
  }
}
```

---

### `GET /api/v1/patient/imaging` (paginated list)

**Response (200):**
```json
{
  "status": "success",
  "message": "Imaging records retrieved.",
  "data": [
    {
      "id": 33,
      "title": "Cardiac MRI - Left Ventricular Function",
      "modality": "MRI",
      "test_result_status": "reviewed",
      "scan_date": "2026-03-20T08:00:00Z",
      "physician_name": "Dr. Sara Kamel",
      "clinic_name": "Heart Care Center",
      "file_format": "DICOM"
    },
    {
      "id": 41,
      "title": "Chest X-Ray AP",
      "modality": "X-Ray",
      "test_result_status": "pending",
      "scan_date": "2026-04-05T11:00:00Z",
      "physician_name": "Dr. Youssef Naguib",
      "clinic_name": "NeuroSense Clinic",
      "file_format": "JPG"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 15,
    "total": 6
  }
}
```

> **DB mapping:** `title` = `medical_attachments.attachment_name`. `modality` is computed in `ImagingSummaryResource` by parsing keywords from `attachment_name` (MRI, CT, X-Ray, Ultrasound, PET, etc.). `scan_date` = `medical_attachments.uploaded_at`. `file_format` is computed from `mime_type` in `MedicalAttachmentResource`.

---

### `GET /api/v1/patient/imaging/{id}` (full detail)

**Response (200):**
```json
{
  "status": "success",
  "message": "Imaging record retrieved.",
  "data": {
    "id": 33,
    "title": "Cardiac MRI - Left Ventricular Function",
    "modality": "MRI",
    "scan_date": "2026-03-20T08:00:00Z",
    "test_result_status": "reviewed",
    "file_info": {
      "format": "DICOM",
      "size_bytes": 4718592,
      "size_human": "4.5 MB",
      "mime_type": "application/dicom"
    },
    "image_url": "https://your-domain.com/storage/attachments/cardiac_mri_abc123.dcm",
    "physician_interpretation": {
      "text": "Normal left ventricular systolic function. EF estimated at 62%. No regional wall motion abnormalities. Mild pericardial effusion noted.",
      "author": "Dr. Sara Kamel, Consultant Cardiologist"
    },
    "physician": {
      "full_name": "Dr. Sara Kamel",
      "professional_title": "consultant"
    },
    "clinic_name": "Heart Care Center"
  }
}
```

> **Important:** `image_url` will be `null` if the file does not physically exist in storage. Flutter must handle this gracefully by showing a placeholder. **Never assume a non-null URL means the file is accessible.**

---

### `GET /api/v1/patient/visit-history` (paginated list)

Uses the same `AppointmentResource` shape as the appointments list.

**Query params:** `?status=completed&per_page=20`

**Response (200):**
```json
{
  "status": "success",
  "message": "Visit history retrieved.",
  "data": [
    {
      "id": 38,
      "appointment_time": "2026-04-01T09:00:00Z",
      "appointment_status": "completed",
      "appointment_type": "physical",
      "visit_reason": "Routine follow-up",
      "cancelled_by": null,
      "cancellation_reason": null,
      "doctor": {
        "id": 7,
        "full_name": "Dr. Sara Kamel",
        "specialty": "Cardiology",
        "avatar_url": "https://your-domain.com/storage/avatars/sara_kamel.jpg",
        "consultation_fee": 350
      },
      "clinic": {
        "id": 3,
        "clinic_name": "Heart Care Center",
        "clinic_address": "15 Tahrir Square, Cairo",
        "clinic_governorate": "Cairo"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 20,
    "total": 47
  }
}
```

> **Note:** `avatarBg`, `avatarColor`, and `doctorInitials` fields are **not included** — those are web UI concerns only.

---

### `GET /api/v1/patient/profile`

**Response (200):**
```json
{
  "status": "success",
  "message": "Profile retrieved.",
  "data": {
    "id": 14,
    "full_name": "Ahmed Hassan",
    "email": "ahmed.hassan@example.com",
    "phone": "01012345678",
    "national_id": "29001011234567",
    "gender": "male",
    "birth_date": "1990-05-15",
    "governorate": "Cairo",
    "account_status": "active",
    "avatar_url": "https://your-domain.com/storage/avatars/ahmed_abc123.jpg",
    "blood_type": "A+",
    "allergies": ["Penicillin", "Aspirin"],
    "chronic_conditions": "Hypertension, Type 2 Diabetes",
    "emergency_contact": {
      "name": "Fatma Hassan",
      "phone": "01098765432",
      "relationship": "Spouse"
    }
  }
}
```

> **DB mapping:** `full_name` from `users.full_name`. `birth_date` from `users.birth_date` (cast to date — returns `"YYYY-MM-DD"` string). `blood_type` from `patients.blood_type`. `allergies` from `patients.allergies` (cast to array in `Patient` model). `chronic_conditions` from `patients.chronic_conditions`. `emergency_contact.name` = `patients.emergency_contact_name`. `emergency_contact.phone` = `patients.emergency_contact_phone`. `emergency_contact.relationship` = `patients.emergency_contact_relationship`.

---

### `PATCH /api/v1/patient/profile`

**Request (partial update supported — send only changed fields):**
```json
{
  "full_name": "Ahmed Hassan Mahmoud",
  "phone": "01011223344",
  "emergency_contact_relationship": "Brother"
}
```

**Response (200):** Returns the full updated `PatientProfileResource` — same shape as `GET /profile`.

---

### `POST /api/v1/patient/profile/password`

**Request:**
```json
{
  "current_password": "oldSecret123",
  "password": "newSecret456",
  "password_confirmation": "newSecret456"
}
```

**Response (200):**
```json
{
  "status": "success",
  "message": "Password changed successfully."
}
```

**Validation failure (422):**
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "current_password": ["Current password is incorrect."]
  }
}
```

---

### `POST /api/v1/patient/profile/avatar`

**Request:** `multipart/form-data` with key `avatar` (image file, max 20MB, types: jpeg/png/jpg/webp/gif)

**Response (200):**
```json
{
  "status": "success",
  "message": "Avatar updated successfully.",
  "data": {
    "avatar_url": "https://your-domain.com/storage/avatars/ahmed_new_xyz789.jpg"
  }
}
```

---

## Section 4: Validation Error Format Reference

Flutter must handle `422` responses from any endpoint. The structure is always:

```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "<field_name>": [
      "<error message string 1>",
      "<error message string 2>"
    ]
  }
}
```

### Common Validation Error Examples by Endpoint

**Login — wrong credentials:**
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "email": ["These credentials do not match our records."]
  }
}
```

**Registration — duplicate national ID:**
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "national_id": ["The national id has already been taken."],
    "email": ["The email has already been taken."]
  }
}
```

**Book appointment — past date:**
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "appointment_time": ["The appointment time must be a date after now."]
  }
}
```

**Cancel appointment — already completed:**
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "appointment": ["This appointment cannot be cancelled as it is already completed."]
  }
}
```

**Avatar upload — wrong file type:**
```json
{
  "status": "error",
  "message": "The given data was invalid.",
  "errors": {
    "avatar": ["The avatar must be an image.", "The avatar must be a file of type: jpeg, png, jpg, webp, gif."]
  }
}
```

---

## Section 5: All Enums — Exact Values for Dart Recreation

### `AppointmentStatus` (string-backed)
```dart
enum AppointmentStatus {
  scheduled('scheduled'),
  cancelled('cancelled'),
  completed('completed');
  
  const AppointmentStatus(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `Scheduled` | `"scheduled"` |
| `Cancelled` | `"cancelled"` |
| `Completed` | `"completed"` |

---

### `AppointmentType` (string-backed)
```dart
enum AppointmentType {
  physical('physical'),
  remote('remote'),
  emergency('emergency');
  
  const AppointmentType(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `Physical` | `"physical"` |
| `Remote` | `"remote"` |
| `Emergency` | `"emergency"` |

---

### `AttachmentType` (string-backed)
```dart
enum AttachmentType {
  imaging('imaging'),
  labResult('lab_result'),
  clinicalDocument('clinical_document'),
  prescription('prescription');
  
  const AttachmentType(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `Imaging` | `"imaging"` |
| `Lab_Result` | `"lab_result"` |
| `Clinical_Document` | `"clinical_document"` |
| `Prescription` | `"prescription"` |

---

### `TestResultStatus` (string-backed)
```dart
enum TestResultStatus {
  pending('pending'),
  reviewed('reviewed');
  
  const TestResultStatus(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `Pending` | `"pending"` |
| `Reviewed` | `"reviewed"` |

---

### `PrescriptionStatus` (string-backed)
```dart
enum PrescriptionStatus {
  pending('pending'),
  issued('issued'),
  dispensed('dispensed'),
  cancelled('cancelled');
  
  const PrescriptionStatus(this.value);
  final String value;
}
```
| Case | Raw API Value | Meaning |
|------|--------------|---------|
| `Pending` | `"pending"` | Prescription written, not yet filled |
| `Issued` | `"issued"` | Active/current prescription |
| `Dispensed` | `"dispensed"` | Dispensed by pharmacy |
| `Cancelled` | `"cancelled"` | Voided |

---

### `AccountStatus` (string-backed)
```dart
enum AccountStatus {
  active('active'),
  suspended('suspended'),
  pending('pending');
  
  const AccountStatus(this.value);
  final String value;
}
```
| Case | Raw API Value | Flutter Behaviour |
|------|--------------|------------------|
| `Active` | `"active"` | Normal app access |
| `Pending` | `"pending"` | Show waiting-for-approval screen |
| `Suspended` | `"suspended"` | Login rejected with `403` — never receives a token |

---

### `BloodType` (string-backed)
```dart
enum BloodType {
  aPositive('A+'),
  aNegative('A-'),
  bPositive('B+'),
  bNegative('B-'),
  abPositive('AB+'),
  abNegative('AB-'),
  oPositive('O+'),
  oNegative('O-');
  
  const BloodType(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `APositive` | `"A+"` |
| `ANegative` | `"A-"` |
| `BPositive` | `"B+"` |
| `BNegative` | `"B-"` |
| `ABPositive` | `"AB+"` |
| `ABNegative` | `"AB-"` |
| `OPositive` | `"O+"` |
| `ONegative` | `"O-"` |

---

### `Gender` (string-backed — bonus, not in blueprint but used in registration)
```dart
enum Gender {
  male('male'),
  female('female'),
  other('other');
  
  const Gender(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `Male` | `"male"` |
| `Female` | `"female"` |
| `Other` | `"other"` |

> **Note:** The registration endpoint only accepts `"male"` or `"female"` via validation rule `in:male,female`. `"other"` exists in the DB enum but is not exposed in registration validation currently.

---

### `RecordStatus` (string-backed — used in medical records)
```dart
enum RecordStatus {
  open('open'),
  closed('closed'),
  archived('archived');
  
  const RecordStatus(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `Open` | `"open"` |
| `Closed` | `"closed"` |
| `Archived` | `"archived"` |

---

### `ProfessionalTitle` (string-backed — used in doctor profiles)
```dart
enum ProfessionalTitle {
  resident('resident'),
  specialist('specialist'),
  consultant('consultant'),
  professor('professor');
  
  const ProfessionalTitle(this.value);
  final String value;
}
```
| Case | Raw API Value |
|------|--------------|
| `Resident` | `"resident"` |
| `Specialist` | `"specialist"` |
| `Consultant` | `"consultant"` |
| `Professor` | `"professor"` |

---

## Section 6: Database Schema Reference

This section maps every relevant DB column to its API key and data type for Flutter model generation.

### `users` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | `id` | `int` | |
| `full_name` | `full_name` | `String` | |
| `email` | `email` | `String` | |
| `phone` | `phone` | `String` | |
| `national_id` | `national_id` | `String` | e.g. `"29001011234567"` |
| `gender` | `gender` | `String` (Gender enum value) | |
| `birth_date` | `birth_date` | `String` (`"YYYY-MM-DD"`) | Cast to date |
| `governorate` | `governorate` | `String?` | |
| `avatar` | `avatar_url` | `String?` | Full storage URL, resource computes this |
| `account_status` | `account_status` | `String` (AccountStatus enum) | |
| `role` | `role` | `String` | e.g. `"patient"` |

### `patients` table (PK = `user_id`, no auto-increment)
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `user_id` | — | — | Foreign key to users, not exposed directly |
| `blood_type` | `blood_type` | `String?` (BloodType enum) | |
| `allergies` | `allergies` | `List<String>?` | Stored as text, cast to array in model |
| `chronic_conditions` | `chronic_conditions` | `String?` | |
| `emergency_contact_name` | `emergency_contact.name` | `String?` | Nested in profile |
| `emergency_contact_phone` | `emergency_contact.phone` | `String?` | Nested in profile |
| `emergency_contact_relationship` | `emergency_contact.relationship` | `String?` | Nested in profile |

### `doctors` table (PK = `user_id`, no auto-increment)
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `user_id` | `id` | `int` | Used as the doctor ID in all requests |
| `medical_license` | `medical_license` | `String` | Unique |
| `specialty` | `specialty` | `String` | Free-text |
| `professional_title` | `professional_title` | `String` (ProfessionalTitle enum) | |
| `syndicate_id` | `syndicate_id` | `String` | Unique |
| `consultation_fee` | `consultation_fee` | `int` | Unsigned integer (EGP) |
| `experience` | `experience` | `String?` | Free text |
| `qualifications` | `qualifications` | `String?` | Free text |

### `clinics` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | `id` | `int` | |
| `clinic_name` | `clinic_name` | `String` | |
| `clinic_type` | — | — | Not exposed in API responses currently |
| `clinic_phone` | `clinic_phone` | `String` | |
| `clinic_address` | `clinic_address` | `String` | |
| `clinic_governorate` | `clinic_governorate` | `String` | |

### `appointments` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | `id` | `int` | |
| `patient_id` | — | — | FK to patients |
| `doctor_id` | — | — | FK to doctors |
| `clinic_id` | — | — | FK to clinics |
| `appointment_time` | `appointment_time` | `DateTime` (ISO 8601 string) | Cast to datetime |
| `appointment_status` | `appointment_status` | `String` (AppointmentStatus enum) | |
| `appointment_type` | `appointment_type` | `String` (AppointmentType enum) | |
| `visit_reason` | `visit_reason` | `String?` | NOT `notes` — use this key in requests |

### `medical_records` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | `id` | `int` | |
| `appointment_id` | Nested `appointment` object | — | |
| `patient_id` | — | — | FK |
| `doctor_id` | Nested `doctor` object | — | |
| `diagnosis_notes` | `diagnosis_notes` | `String?` | |
| `record_status` | `record_status` | `String` (RecordStatus enum) | |
| `created_at` | `created_at` | `DateTime` (ISO 8601) | |

### `diagnoses` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | `id` | `int` | |
| `medical_record_id` | — | — | FK |
| `description` | `description` | `String` | Full diagnosis text |
| `created_at` | `created_at` | `DateTime` | |

### `medical_attachments` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | `id` | `int` | |
| `medical_record_id` | — | — | FK |
| `attachment_type` | `attachment_type` | `String` (AttachmentType enum) | |
| `attachment_name` | `name` / `title` | `String` | Used as display name |
| `file_path` | — | — | Used internally to build `file_url` / `image_url` |
| `mime_type` | `mime_type` | `String` | e.g. `"application/pdf"`, `"image/jpeg"` |
| `test_result_status` | `test_result_status` | `String` (TestResultStatus enum) | |
| `notes` | `notes` | `String?` | |
| `uploaded_at` | `uploaded_at` / `scan_date` | `DateTime` (ISO 8601) | Note: no `created_at` — model uses `CREATED_AT = 'uploaded_at'` |

### `prescriptions` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | `id` | `int` | |
| `medical_record_id` | — | — | FK |
| `pharmacy_id` | — | — | FK, nullable |
| `prescription_status` | `prescription_status` | `String` (PrescriptionStatus enum) | |
| `notes` | `notes` | `List<String>` | Split on `\n` in resource |
| `created_at` | `created_at` / `generated_date` | `DateTime` | |

### `prescription_items` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | — | — | Not exposed |
| `prescription_id` | — | — | FK |
| `medicine_id` | — | — | FK |
| `dosage` | `dosage` | `String` | e.g. `"5mg"` |
| `frequency` | `frequency` | `String` | e.g. `"Once daily"` |
| `duration_days` | `duration_days` | `int` | |
| *(no timestamps)* | — | — | `public $timestamps = false` in model |

### `medicines` table
| DB Column | API Key | Dart Type | Notes |
|-----------|---------|-----------|-------|
| `id` | — | — | |
| `name` | `name` | `String` | e.g. `"Amlodipine"` |
| `category` | `category` | `String` | e.g. `"Calcium Channel Blocker"` |
| `strength` | — | — | Not currently exposed in API resources |

---

## Section 7: Known Gotchas & Flutter Integration Notes

1. **`avatar` is stored as JSON in DB** — the `User` model casts `avatar` to `array`. The API resource computes `avatar_url` as a full storage URL string. Flutter only ever receives `avatar_url` — never the raw JSON array.

2. **Doctor ID = `user_id`** — The `doctors` table has no separate `id` column. Its primary key is `user_id`. When sending `doctor_id` in appointment booking, use the `id` value from any `DoctorSummaryResource` response.

3. **`appointment_status` vs `appointment_type`** — These are different fields. `status` = lifecycle state (`scheduled/completed/cancelled`). `type` = modality (`physical/remote/emergency`).

4. **`medical_attachments` has no `updated_at`** — The model sets `UPDATED_AT = null`. Only `uploaded_at` exists, which also serves as `CREATED_AT` in the model.

5. **`prescription_items` has no timestamps** — `public $timestamps = false`. Do not expect `created_at` or `updated_at` from prescription item data.

6. **Patient PK is `user_id`** — Similarly, `patients` table PK is `user_id`. Internally used for authorization checks. Exposed as `id` in profile responses.

7. **`allergies` is stored as TEXT in DB, cast to array** — The `Patient` model casts `allergies => 'array'`. API always returns it as `List<String>` or `null`. Flutter should initialize as an empty list when null.

8. **`expires_at` is computed, not stored** — Prescription expiry (30 days after `created_at`) is computed in the resource layer. Not a DB column.

9. **`clinic_id` on new appointments is inferred** — There is no doctor-clinic pivot table yet. The backend resolves `clinic_id` from the doctor's most recent appointment clinic. This is a known architectural limitation.

10. **Auth header format** — `Authorization: Bearer <token>` — no session cookies. The Sanctum token is a plain-text string like `"14|xyz..."`.
