import 'package:flutter_test/flutter_test.dart';
import 'package:demoflutter/models/classification_result.dart';

void main() {
  group('ClassificationResult', () {
    test('should create result with required fields', () {
      final result = ClassificationResult(
        species: 'Anadara',
        confidence: 0.85,
      );
      
      expect(result.species, 'Anadara');
      expect(result.confidence, 0.85);
      expect(result.weight, isNull);
      expect(result.weightUnit, isNull);
    });
    
    test('should create result with weight information', () {
      final result = ClassificationResult(
        species: 'Gafrarium',
        confidence: 0.92,
        weight: 15.5,
        weightUnit: 'grams',
      );
      
      expect(result.species, 'Gafrarium');
      expect(result.confidence, 0.92);
      expect(result.weight, 15.5);
      expect(result.weightUnit, 'grams');
    });
    
    test('should convert to and from JSON', () {
      final originalResult = ClassificationResult(
        species: 'Anadara',
        confidence: 0.88,
        weight: 12.3,
        weightUnit: 'grams',
      );
      
      final json = originalResult.toJson();
      final restoredResult = ClassificationResult.fromJson(json);
      
      expect(restoredResult.species, originalResult.species);
      expect(restoredResult.confidence, originalResult.confidence);
      expect(restoredResult.weight, originalResult.weight);
      expect(restoredResult.weightUnit, originalResult.weightUnit);
    });
    
    test('should generate proper string representation', () {
      final result = ClassificationResult(
        species: 'Anadara',
        confidence: 0.856,
        weight: 12.34,
        weightUnit: 'grams',
      );
      
      final stringRepresentation = result.toString();
      
      expect(stringRepresentation, contains('Anadara'));
      expect(stringRepresentation, contains('85.6%'));
      expect(stringRepresentation, contains('12.34 grams'));
    });
    
    test('should handle result without weight in string representation', () {
      final result = ClassificationResult(
        species: 'Other',
        confidence: 0.45,
      );
      
      final stringRepresentation = result.toString();
      
      expect(stringRepresentation, contains('Other'));
      expect(stringRepresentation, contains('45.0%'));
      expect(stringRepresentation, isNot(contains('grams')));
    });
  });
}