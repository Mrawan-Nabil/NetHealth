# 🏥 NetHealth – Smart Healthcare Management System

## 📌 Overview

**NetHealth** is a smart, AI-ready healthcare management platform designed to connect **patients**, **doctors**, **clinics**, and **pharmacies** through a unified digital system.
The platform focuses on **efficient appointment management**, **secure electronic health records (EHR)**, and **real-world medical workflows**, while being scalable for future AI and analytics features.

NetHealth is developed as a **university course project** using **Agile methodology**, with an emphasis on clean architecture, realistic data modeling, and working end-to-end features.

---

## 🎯 Project Goals

* Digitize patient–doctor interactions
* Provide structured and secure **medical records**
* Enable clinics and pharmacies to operate as verified entities
* Build a scalable backend ready for AI integration
* Deliver **working core features** rather than incomplete breadth

---

## 🧠 Key Features

### 🔐 Authentication & Authorization

* Secure user registration and login
* Role-based access control (RBAC)
* Supported roles:

  * Patient
  * Doctor
  * Clinic staff
  * Pharmacy staff
  * Admin
* Account verification & approval workflow

---

### 👨‍⚕️ Patient Module

* Patient profile with medical-grade data:

  * Gender, birth date, blood type
  * Allergies & chronic conditions
  * Emergency contact
* Book appointments with doctors
* Upload medical attachments (tests, X-rays)
* View complete medical history
* Receive diagnoses and prescriptions

---

### 🩺 Doctor Module

* Doctor profile with:

  * Medical license
  * Specialty
  * Qualifications & experience
* View assigned appointments
* Access patient medical history
* Create medical records per visit
* Add diagnoses & notes
* Issue digital prescriptions

---

### 🏥 Clinic Module

* Clinics represented as verified organizations
* Doctors and staff assigned to clinics
* Clinics host appointments
* Upload medical tests and visit summaries
* Real-world separation between **user accounts** and **organizations**

---

### 💊 Pharmacy Module

* Pharmacies represented as verified organizations
* Receive and fulfill prescriptions
* Manage prescription status
* Structured medicine handling
* Linked pharmacy staff accounts

---

### 📁 Electronic Health Records (EHR)

* Centralized medical record per appointment
* Diagnoses stored as structured entries
* Attachments (tests, images, reports)
* Full patient medical history timeline
* Audit timestamps for traceability

---

## 🏗️ System Architecture

* **Backend-first design**
* Clear separation of concerns:

  * Users vs Organizations
  * Medical data vs operational data
* Database designed using **ERD & UML**
* Ready for RESTful API expansion

---

## 🗄️ Database Design

* Normalized relational database
* Key entities:

  * User, Patient, Doctor
  * Clinic, Pharmacy
  * Appointment, MedicalRecord
  * Diagnosis, Attachment
  * Prescription, Medicine
* Audit fields (`created_at`, `updated_at`) across core tables
* Designed to scale for analytics & AI services

---

## 🛠️ Technology Stack

### Backend

* Django
* Django REST Framework (DRF)
* JWT Authentication

### Database

* SQLite (development)
* PostgreSQL-ready design

### Frontend

* Vue / React (component-based UI)
* Modern UI/UX design
* Dark-mode friendly layouts

### Development Methodology

* Agile (Sprint-based)
* Feature-driven implementation
* Continuous refinement

---

## 🔁 Agile Development Approach

The project follows **Agile methodology**, focusing on delivering **complete, usable features per sprint**.

### Core Strategy

1. Implement authentication & authorization first
2. Focus on **Patient + Doctor** workflows together
3. Integrate EHR and medical records early
4. Extend to clinics and pharmacies
5. Leave AI & analytics as extensible layers

---

## 👥 Team Structure

| Member      | Responsibility                                      |
| ----------- | --------------------------------------------------- |
| **Mrawan**  | Team Lead, Backend support, architecture            |
| **Mahmoud** | AI research, system analysis, feature validation    |
| **Mariam**  | Backend (Laravel experience leveraged conceptually) |
| **Mennah**  | UI/UX Design                                        |
| **Nour**    | Frontend development                                |
| **Moustafa**    | Frontend development                                |

---

## 🚀 Future Enhancements

* AI-powered symptom checker
* Smart prescription recommendations
* Predictive analytics for clinics
* Real-time chat & notifications
* Payment & insurance integration

---

## 📚 Academic Note

This project is developed as part of a **Computer Science university course**, with emphasis on:

* Clean software architecture
* Professional database design
* Realistic healthcare workflows
* Team collaboration and Agile practices

---

## ✅ Project Status

🔧 **Active Development**
Core modules are prioritized to ensure **working, testable, and demonstrable features**.

