import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/patient_profile_model.dart';
import '../data/profile_repository.dart';
import '../../../core/network/dio_provider.dart';
import '../../auth/providers/auth_provider.dart';
import 'dart:io';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(dioProvider));
});

class ProfileNotifier extends AsyncNotifier<PatientProfileModel?> {
  @override
  Future<PatientProfileModel?> build() async {
    final authState = ref.watch(authProvider).valueOrNull;
    if (authState == null) return null;
    return _fetchProfile();
  }

  Future<PatientProfileModel?> _fetchProfile() async {
    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      return profile;
    } catch (e, st) {
      // Allow Riverpod to catch errors to display in UI natively
      throw e;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final updatedProfile = await ref.read(profileRepositoryProvider).updateProfile(data);
      state = AsyncData(updatedProfile);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateAvatar(File image) async {
    try {
      await ref.read(profileRepositoryProvider).updateAvatar(image);
      // Invalidate to trigger a fresh fetch from the server ensuring clean synchronization
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, PatientProfileModel?>(ProfileNotifier.new);
