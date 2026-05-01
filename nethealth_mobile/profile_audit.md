# Profile Implementation Audit Report

This document details the refactoring steps and technical decisions made to connect the static Profile UI to the live Laravel backend.

## 1. Global Avatar Locations
To ensure the user's avatar stays synchronized across the entire application after an upload, the static fallback images were updated to use the live `profileProvider` state.

**Replaced instances:**
- `lib/features/home/ui/dashboard_screen.dart`: The `_TopBar` component was converted to a `ConsumerWidget`. The `CircleAvatar` was replaced with `NhAvatar`, observing `ref.watch(profileProvider).valueOrNull?.avatarUrl`.
- `lib/features/profile/ui/profile_screen.dart`: Replaced the hardcoded user initialization circle with the `NhAvatar` component, properly falling back to user initials if no URL is provided by the API.
- `lib/features/profile/ui/edit_profile_screen.dart`: Converted the entire screen to a `ConsumerStatefulWidget` to instantly show the updated avatar via `NhAvatar` immediately after the image picker successfully uploads a new file.

*Note on existing widgets:* Instances like `doctor_details_screen.dart` or `booking_modals.dart` typically use `DoctorAvatar` because they reference the currently viewed *doctor's* avatar, not the global *patient's* avatar. Those were intentionally left intact.

## 2. Backend Alignments
During the initial investigation, it was discovered that `PatientProfileController` and `PatientProfileResource` **did not exist** in the Laravel backend. To resolve this, they were created from scratch:
- **`app/Http/Controllers/Api/Patient/PatientProfileApiController.php`**: Hand-crafted to accept, validate, and process `PATCH /profile` updates and `POST /profile/avatar` uploads.
- **`app/Http/Resources/Api/PatientProfileResource.php`**: Hand-crafted to precisely map the database structure (`users` table fields combined with `patients` table fields) into the exact JSON format expected by the Flutter `PatientProfileModel` (e.g., nesting the `emergency_contact_name/phone/relationship` under a single `emergency_contact` JSON object).

The Flutter `PatientProfileModel` was also augmented with an `avatarUrl` property to correctly store the parsed URL coming from the newly created `PatientProfileResource`.

## 3. Image Handling Notes (Multipart Uploads)
The avatar upload process utilizes Dio's `FormData` and `MultipartFile` mapping exactly to the backend requirements.

**Frontend (`profile_repository.dart`):**
```dart
final formData = FormData.fromMap({
  'avatar': await MultipartFile.fromFile(image.path),
});
final response = await _dio.post('${ApiEndpoints.patientProfile}/avatar', data: formData);
```

**Backend (`PatientProfileApiController.php`):**
The Laravel controller validates the incoming file (`mimes:jpeg,png,jpg,gif|max:5120`). Upon successful validation:
1. It deletes the previous avatar from the `public` storage disk (if one existed and it wasn't a generic web avatar).
2. It uses `$request->file('avatar')->store('avatars', 'public')` to place the file in the designated folder.
3. It updates the `$user->avatar` field and instantly returns the fully qualified HTTP path so Riverpod can gracefully update the `PatientProfileModel` without requiring a full page refresh.
