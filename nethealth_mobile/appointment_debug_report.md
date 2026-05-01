# Appointment Debug Report

## Root Cause
The regression where the app reverted to static data was caused by the `AppointmentDetailScreen` being fully mocked out with hardcoded static variables (e.g., `mockStatus`, `mockDoctor`). The rollback of the booking suite likely left this detail view in an incomplete state. There was no provider implemented to fetch a single appointment's details by ID, and there was no corresponding API endpoint on the Laravel backend to support such a fetch. Additionally, the `AppointmentsScreen` contained hardcoded, mocked PDF attachment views for "completed" appointments that were statically rendered regardless of the API payload.

## Files Changed

### Backend (Laravel)
1. **`routes/api.php`**: Added the `GET /appointments/{id}` API route to fetch a single appointment.
2. **`PatientAppointmentApiController.php`**: Implemented the `show($id)` method to validate the patient and return eager-loaded appointment details.

### Frontend (Flutter)
3. **`lib/core/network/api_endpoints.dart`**: Added the `appointmentDetail` string builder for the new backend route.
4. **`lib/features/appointments/data/appointments_repository.dart`**: Added the `getAppointmentDetails(id)` method to fetch the individual appointment from the API.
5. **`lib/features/appointments/providers/appointments_provider.dart`**: Created the `appointmentDetailProvider` (a Riverpod `FutureProvider.family`) to manage the state of the API fetch.
6. **`lib/features/appointments/ui/appointment_detail_screen.dart`**: Converted from a static `StatelessWidget` to a `ConsumerWidget`. Removed all mock constants and replaced them with dynamic UI components that observe `ref.watch(appointmentDetailProvider(id))`.
7. **`lib/features/appointments/ui/appointments_screen.dart`**: Removed the statically mocked PDF files (`_AttachedFile`) from the `_CompletedContent` widget.
