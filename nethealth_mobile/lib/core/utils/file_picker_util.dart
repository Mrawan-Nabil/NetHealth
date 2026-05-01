import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerUtil {
  /// Picks a document (PDF, DOC) or Image using file_picker.
  static Future<File?> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      // Handle error or permission denied
      print("FilePicker error: $e");
    }
    return null;
  }

  /// Picks an image specifically using image_picker (e.g. from gallery).
  static Future<File?> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print("ImagePicker error: $e");
    }
    return null;
  }
}
