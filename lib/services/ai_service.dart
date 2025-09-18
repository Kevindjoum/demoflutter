import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'image_processor.dart';

class AIService {
  Interpreter? _classifierInterpreter;
  Interpreter? _regAnadaraInterpreter;
  Interpreter? _regGafrariumInterpreter;
  
  // Species labels - these would typically be loaded from a labels file
  final List<String> _speciesLabels = [
    'Anadara',
    'Gafrarium',
    'Other'
  ];
  
  bool get isInitialized => 
      _classifierInterpreter != null && 
      _regAnadaraInterpreter != null && 
      _regGafrariumInterpreter != null;
  
  /// Initialize all TensorFlow Lite models
  Future<void> initializeModels() async {
    try {
      // Load classifier model
      _classifierInterpreter = await Interpreter.fromAsset('assets/models/classifier.tflite');
      
      // Load regression models
      _regAnadaraInterpreter = await Interpreter.fromAsset('assets/models/reg_anadara.tflite');
      _regGafrariumInterpreter = await Interpreter.fromAsset('assets/models/reg_gafrarium.tflite');
      
      print('All models initialized successfully');
    } catch (e) {
      print('Error initializing models: $e');
      throw Exception('Failed to initialize AI models: $e');
    }
  }
  
  /// Classify species and estimate weight from image
  Future<Map<String, dynamic>> processImage(File imageFile) async {
    if (!isInitialized) {
      throw Exception('Models not initialized. Call initializeModels() first.');
    }
    
    try {
      // Preprocess image
      final processedImage = await ImageProcessor.preprocessImage(imageFile);
      
      // Step 1: Classify species
      final speciesResult = await _classifySpecies(processedImage);
      final species = speciesResult['species'] as String;
      final confidence = speciesResult['confidence'] as double;
      
      // Step 2: Estimate weight based on species
      double? weight;
      if (species == 'Anadara' && _regAnadaraInterpreter != null) {
        weight = await _estimateWeight(_regAnadaraInterpreter!, processedImage);
      } else if (species == 'Gafrarium' && _regGafrariumInterpreter != null) {
        weight = await _estimateWeight(_regGafrariumInterpreter!, processedImage);
      }
      
      return {
        'species': species,
        'confidence': confidence,
        'weight': weight,
        'weightUnit': 'grams',
      };
    } catch (e) {
      throw Exception('Error processing image: $e');
    }
  }
  
  /// Classify species using the classifier model
  Future<Map<String, dynamic>> _classifySpecies(List<List<List<List<double>>>> input) async {
    try {
      // Prepare output tensor
      var output = List.filled(_speciesLabels.length, 0.0).reshape([1, _speciesLabels.length]);
      
      // Run inference
      _classifierInterpreter!.run(input, output);
      
      // Find the class with highest probability
      final probabilities = output[0] as List<double>;
      double maxProbability = probabilities[0];
      int maxIndex = 0;
      
      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProbability) {
          maxProbability = probabilities[i];
          maxIndex = i;
        }
      }
      
      return {
        'species': _speciesLabels[maxIndex],
        'confidence': maxProbability,
        'probabilities': probabilities,
      };
    } catch (e) {
      throw Exception('Error in species classification: $e');
    }
  }
  
  /// Estimate weight using regression model
  Future<double> _estimateWeight(Interpreter interpreter, List<List<List<List<double>>>> input) async {
    try {
      // Prepare output tensor for regression (single value)
      var output = List.filled(1, 0.0).reshape([1, 1]);
      
      // Run inference
      interpreter.run(input, output);
      
      // Return weight estimate
      return output[0][0] as double;
    } catch (e) {
      throw Exception('Error in weight estimation: $e');
    }
  }
  
  /// Dispose of interpreters
  void dispose() {
    _classifierInterpreter?.close();
    _regAnadaraInterpreter?.close();
    _regGafrariumInterpreter?.close();
    
    _classifierInterpreter = null;
    _regAnadaraInterpreter = null;
    _regGafrariumInterpreter = null;
  }
}