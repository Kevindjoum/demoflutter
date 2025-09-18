import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessor {
  static const int targetSize = 224;
  
  /// Preprocess image for TensorFlow Lite model
  /// Resizes to 224x224 and normalizes pixels to [0, 1]
  static Future<List<List<List<List<double>>>>> preprocessImage(File imageFile) async {
    try {
      // Read image bytes
      final bytes = await imageFile.readAsBytes();
      
      // Decode image
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Could not decode image');
      }
      
      // Resize to 224x224
      img.Image resizedImage = img.copyResize(
        image,
        width: targetSize,
        height: targetSize,
        interpolation: img.Interpolation.linear,
      );
      
      // Convert to normalized float array [0, 1]
      List<List<List<List<double>>>> input = List.generate(
        1, // batch size
        (b) => List.generate(
          targetSize, // height
          (y) => List.generate(
            targetSize, // width
            (x) => List.generate(
              3, // RGB channels
              (c) {
                late int pixel;
                if (c == 0) {
                  pixel = img.getRed(resizedImage, x, y);
                } else if (c == 1) {
                  pixel = img.getGreen(resizedImage, x, y);
                } else {
                  pixel = img.getBlue(resizedImage, x, y);
                }
                return pixel / 255.0; // Normalize to [0, 1]
              },
            ),
          ),
        ),
      );
      
      return input;
    } catch (e) {
      throw Exception('Error preprocessing image: $e');
    }
  }
  
  /// Get image dimensions for validation
  static Future<Map<String, int>> getImageDimensions(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Could not decode image');
    }
    
    return {
      'width': image.width,
      'height': image.height,
    };
  }
}