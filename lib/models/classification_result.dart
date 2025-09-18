class ClassificationResult {
  final String species;
  final double confidence;
  final double? weight;
  final String? weightUnit;
  final DateTime timestamp;
  
  ClassificationResult({
    required this.species,
    required this.confidence,
    this.weight,
    this.weightUnit,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  Map<String, dynamic> toJson() {
    return {
      'species': species,
      'confidence': confidence,
      'weight': weight,
      'weightUnit': weightUnit,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    return ClassificationResult(
      species: json['species'],
      confidence: json['confidence'],
      weight: json['weight'],
      weightUnit: json['weightUnit'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  
  @override
  String toString() {
    final weightInfo = weight != null ? ', ${weight!.toStringAsFixed(2)} $weightUnit' : '';
    return 'Species: $species (${(confidence * 100).toStringAsFixed(1)}% confidence)$weightInfo';
  }
}