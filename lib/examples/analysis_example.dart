/// Example usage of the DApp Marine Invertebrate Classifier
/// 
/// This file demonstrates how to integrate and use the AI service
/// for marine invertebrate classification and weight estimation.

import 'dart:io';
import 'package:demoflutter/services/ai_service.dart';
import 'package:demoflutter/models/classification_result.dart';

class MarineInvertebrateAnalyzer {
  final AIService _aiService = AIService();
  bool _isInitialized = false;
  
  /// Initialize the AI models
  Future<void> initialize() async {
    try {
      await _aiService.initializeModels();
      _isInitialized = true;
      print('✅ AI models initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize AI models: $e');
      throw e;
    }
  }
  
  /// Analyze an image and return classification results
  Future<ClassificationResult?> analyzeImage(File imageFile) async {
    if (!_isInitialized) {
      throw Exception('Analyzer not initialized. Call initialize() first.');
    }
    
    try {
      print('🔄 Processing image: ${imageFile.path}');
      
      // Process the image through AI pipeline
      final result = await _aiService.processImage(imageFile);
      
      // Create classification result
      final classificationResult = ClassificationResult(
        species: result['species'],
        confidence: result['confidence'],
        weight: result['weight'],
        weightUnit: result['weightUnit'],
      );
      
      // Log results
      print('📊 Analysis Results:');
      print('   Species: ${classificationResult.species}');
      print('   Confidence: ${(classificationResult.confidence * 100).toStringAsFixed(1)}%');
      if (classificationResult.weight != null) {
        print('   Weight: ${classificationResult.weight!.toStringAsFixed(2)} ${classificationResult.weightUnit}');
      }
      print('   Timestamp: ${classificationResult.timestamp}');
      
      return classificationResult;
    } catch (e) {
      print('❌ Error during analysis: $e');
      return null;
    }
  }
  
  /// Batch process multiple images
  Future<List<ClassificationResult>> analyzeMultipleImages(List<File> imageFiles) async {
    final results = <ClassificationResult>[];
    
    for (final imageFile in imageFiles) {
      final result = await analyzeImage(imageFile);
      if (result != null) {
        results.add(result);
      }
    }
    
    return results;
  }
  
  /// Get analysis summary statistics
  Map<String, dynamic> getAnalysisSummary(List<ClassificationResult> results) {
    if (results.isEmpty) {
      return {'total': 0, 'species_distribution': {}, 'average_confidence': 0.0};
    }
    
    final speciesCount = <String, int>{};
    double totalConfidence = 0.0;
    double totalWeight = 0.0;
    int weightCount = 0;
    
    for (final result in results) {
      // Count species distribution
      speciesCount[result.species] = (speciesCount[result.species] ?? 0) + 1;
      
      // Sum confidence
      totalConfidence += result.confidence;
      
      // Sum weights if available
      if (result.weight != null) {
        totalWeight += result.weight!;
        weightCount++;
      }
    }
    
    return {
      'total': results.length,
      'species_distribution': speciesCount,
      'average_confidence': totalConfidence / results.length,
      'average_weight': weightCount > 0 ? totalWeight / weightCount : null,
      'specimens_with_weight': weightCount,
    };
  }
  
  /// Dispose of resources
  void dispose() {
    _aiService.dispose();
    _isInitialized = false;
    print('🧹 Resources disposed');
  }
}

/// Example usage function
Future<void> exampleUsage() async {
  final analyzer = MarineInvertebrateAnalyzer();
  
  try {
    // Initialize the analyzer
    await analyzer.initialize();
    
    // Example: Analyze a single image
    final imageFile = File('/path/to/marine_invertebrate.jpg');
    final result = await analyzer.analyzeImage(imageFile);
    
    if (result != null) {
      print('Analysis completed: ${result.toString()}');
    }
    
    // Example: Batch processing
    final imageFiles = [
      File('/path/to/image1.jpg'),
      File('/path/to/image2.jpg'),
      File('/path/to/image3.jpg'),
    ];
    
    final batchResults = await analyzer.analyzeMultipleImages(imageFiles);
    final summary = analyzer.getAnalysisSummary(batchResults);
    
    print('Batch Analysis Summary:');
    print('Total images processed: ${summary['total']}');
    print('Species distribution: ${summary['species_distribution']}');
    print('Average confidence: ${(summary['average_confidence'] * 100).toStringAsFixed(1)}%');
    
    if (summary['average_weight'] != null) {
      print('Average weight: ${summary['average_weight'].toStringAsFixed(2)} grams');
    }
    
  } finally {
    // Always dispose of resources
    analyzer.dispose();
  }
}

/// Performance benchmarking
class PerformanceBenchmark {
  static Future<Map<String, double>> benchmarkAnalysis(
    MarineInvertebrateAnalyzer analyzer,
    File testImage,
    {int iterations = 10}
  ) async {
    final times = <double>[];
    
    for (int i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();
      await analyzer.analyzeImage(testImage);
      stopwatch.stop();
      times.add(stopwatch.elapsedMilliseconds.toDouble());
    }
    
    times.sort();
    final average = times.reduce((a, b) => a + b) / times.length;
    final median = times[times.length ~/ 2];
    final min = times.first;
    final max = times.last;
    
    return {
      'average_ms': average,
      'median_ms': median,
      'min_ms': min,
      'max_ms': max,
    };
  }
}