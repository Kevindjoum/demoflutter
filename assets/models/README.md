# Model Files

This directory should contain the TensorFlow Lite model files for the marine invertebrate classification and weight estimation.

## Required Files

1. **classifier.tflite** - Main classification model to identify species (Anadara, Gafrarium, or Other)
2. **reg_anadara.tflite** - Regression model for estimating weight of Anadara species
3. **reg_gafrarium.tflite** - Regression model for estimating weight of Gafrarium species

## Model Requirements

- **Input**: 224x224 RGB images, normalized to [0, 1]
- **Classifier Output**: Probability distribution over species classes
- **Regression Output**: Single float value representing weight in grams

## Training Notes

The models should be trained on preprocessed images:
- Resized to 224x224 pixels
- RGB color channels
- Pixel values normalized to range [0, 1]

## Adding Your Models

1. Replace the placeholder `.tflite` files with your trained models
2. Ensure the models follow the input/output specifications above
3. Test the app with real images to verify proper functionality

## Model Performance

For best results, ensure your models are:
- Properly validated on test data
- Optimized for mobile inference
- Quantized if needed for better performance