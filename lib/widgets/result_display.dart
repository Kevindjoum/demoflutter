import 'package:flutter/material.dart';
import '../models/classification_result.dart';

class ResultDisplay extends StatelessWidget {
  final ClassificationResult result;
  
  const ResultDisplay({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Analysis Results',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Species
            _buildResultRow(
              context,
              'Species',
              result.species,
              Icons.pets,
              Colors.blue,
            ),
            
            const SizedBox(height: 12),
            
            // Confidence
            _buildResultRow(
              context,
              'Confidence',
              '${(result.confidence * 100).toStringAsFixed(1)}%',
              Icons.psychology,
              _getConfidenceColor(result.confidence),
            ),
            
            const SizedBox(height: 12),
            
            // Weight (if available)
            if (result.weight != null) ...[
              _buildResultRow(
                context,
                'Estimated Weight',
                '${result.weight!.toStringAsFixed(2)} ${result.weightUnit ?? 'grams'}',
                Icons.scale,
                Colors.orange,
              ),
              const SizedBox(height: 12),
            ],
            
            // Timestamp
            _buildResultRow(
              context,
              'Analyzed',
              _formatTimestamp(result.timestamp),
              Icons.access_time,
              Colors.grey,
            ),
            
            const SizedBox(height: 16),
            
            // Confidence indicator
            _buildConfidenceIndicator(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildConfidenceIndicator(BuildContext context) {
    final confidence = result.confidence;
    final color = _getConfidenceColor(confidence);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confidence Level',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: confidence,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Text(
          _getConfidenceText(confidence),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }
  
  String _getConfidenceText(double confidence) {
    if (confidence >= 0.8) return 'High confidence';
    if (confidence >= 0.6) return 'Medium confidence';
    return 'Low confidence';
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}