# DApp - Marine Invertebrate Classifier

A local-first Flutter application that classifies marine invertebrates and estimates their weight from photos using TensorFlow Lite models.

## Features

- **Camera Integration**: Capture photos directly from device camera
- **Gallery Support**: Select images from device gallery
- **AI Classification**: Identify marine invertebrate species using TensorFlow Lite
- **Weight Estimation**: Estimate weight based on species-specific regression models
- **Offline Processing**: All AI processing happens locally on device
- **Real-time Results**: Fast inference with loading indicators
- **User-friendly UI**: Intuitive interface with material design

## Supported Species

- **Anadara** - With dedicated weight estimation model
- **Gafrarium** - With dedicated weight estimation model
- **Other** - For unrecognized species

## Technical Architecture

### AI Pipeline

1. **Image Preprocessing**:
   - Resize images to 224x224 pixels
   - Normalize pixel values to [0, 1] range
   - RGB color channel processing

2. **Species Classification**:
   - Uses `classifier.tflite` model
   - Returns species prediction with confidence score

3. **Weight Estimation**:
   - Uses species-specific regression models:
     - `reg_anadara.tflite` for Anadara species
     - `reg_gafrarium.tflite` for Gafrarium species
   - Returns weight estimate in grams

### Dependencies

- `image_picker`: Camera and gallery access
- `tflite_flutter`: TensorFlow Lite integration
- `image`: Image processing and manipulation
- `permission_handler`: Device permissions
- `path_provider`: File system access

## Setup Instructions

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio or VS Code
- Device with camera (for testing)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Kevindjoum/demoflutter.git
   cd demoflutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. **Add TensorFlow Lite Models**:
   - Place your trained models in `assets/models/`:
     - `classifier.tflite` - Main classification model
     - `reg_anadara.tflite` - Anadara weight regression model
     - `reg_gafrarium.tflite` - Gafrarium weight regression model
   - See `assets/models/README.md` for model specifications

4. Run the application:
   ```bash
   flutter run
   ```

## Model Requirements

### Input Specifications
- **Image Size**: 224x224 pixels
- **Color Channels**: RGB (3 channels)
- **Data Type**: Float32
- **Value Range**: [0, 1] (normalized)

### Output Specifications
- **Classifier**: Probability distribution over species classes
- **Regression Models**: Single float value (weight in grams)

## Usage

1. **Launch the App**: Open the DApp application
2. **Take/Select Photo**: Use camera or gallery to select an image
3. **Analyze Image**: Tap "Analyze Image" to process the photo
4. **View Results**: See species classification and weight estimate
5. **Confidence Indicator**: Check the confidence level of predictions

## File Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── classification_result.dart # Data model for results
├── screens/
│   └── home_screen.dart         # Main application screen
├── services/
│   ├── ai_service.dart          # TensorFlow Lite integration
│   └── image_processor.dart     # Image preprocessing
└── widgets/
    ├── loading_indicator.dart   # Loading UI component
    └── result_display.dart      # Results UI component

assets/
└── models/                      # TensorFlow Lite model files
    ├── classifier.tflite
    ├── reg_anadara.tflite
    └── reg_gafrarium.tflite

test/                           # Unit and widget tests
```

## Development

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/classification_result_test.dart
```

### Building for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Permissions

The app requires the following permissions:
- **Camera**: For capturing photos
- **Storage**: For accessing gallery images

Permissions are requested at runtime when needed.

## Performance Considerations

- Models are loaded once at app startup
- Image preprocessing is optimized for mobile devices
- UI remains responsive during AI processing
- Results are cached for the current session

## Troubleshooting

### Common Issues

1. **Model Loading Errors**: Ensure model files are in `assets/models/` and listed in `pubspec.yaml`
2. **Permission Denied**: Grant camera and storage permissions in device settings
3. **Out of Memory**: Large images are automatically resized during preprocessing
4. **Slow Performance**: Consider model quantization for better mobile performance

### Debug Mode

Use Flutter's debug mode for detailed error logs:
```bash
flutter run --debug
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- TensorFlow Lite team for mobile AI framework
- Flutter team for the cross-platform framework
- Marine biology research community for species classification insights