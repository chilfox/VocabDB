import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<File?> pickAndUploadFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['csv'], 
      allowMultiple: false, 
    );

    if (result != null) {
      PlatformFile platformFile = result.files.first;
      File selectedFile = File(platformFile.path!);
      return selectedFile;
    }
    else{ //the user didn't choose a file
      return null;
    }
  } catch (e) {
    print('error: $e');
    return null;
  }
}