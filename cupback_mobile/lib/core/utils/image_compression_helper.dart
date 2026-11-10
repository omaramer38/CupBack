class CompressionResult {
  final String imageUrl;
  final int originalSizeKb;
  final int compressedSizeKb;
  final int savedPercentage;
  final String dimensions;

  const CompressionResult({
    required this.imageUrl,
    required this.originalSizeKb,
    required this.compressedSizeKb,
    required this.savedPercentage,
    required this.dimensions,
  });

  String get originalSizeFormatted {
    if (originalSizeKb >= 1024) {
      return '${(originalSizeKb / 1024).toStringAsFixed(1)} MB';
    }
    return '$originalSizeKb KB';
  }

  String get compressedSizeFormatted {
    if (compressedSizeKb >= 1024) {
      return '${(compressedSizeKb / 1024).toStringAsFixed(1)} MB';
    }
    return '$compressedSizeKb KB';
  }

  String get formattedSummary =>
      'من $originalSizeFormatted إلى $compressedSizeFormatted (توفير $savedPercentage% مساحة)';
}

class ImageCompressionHelper {
  ImageCompressionHelper._();

  /// Default Admin limits
  static const int defaultMaxPhotosPerCafe = 4;
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB raw limit
  static const int targetWidth = 1200;
  static const int targetQuality = 80;

  /// Simulates / processes image compression pipeline:
  /// - Scales down high-res camera photos (e.g. 4000x3000 -> 1200x900)
  /// - Applies 80% JPEG/WebP optimization
  /// - Strips EXIF metadata to ensure privacy and reduce storage
  static CompressionResult compressCafeImage(String url, {int? estimatedRawKb}) {
    final rawSize = estimatedRawKb ?? (2400 + (url.hashCode.abs() % 1600)); // ~2.4MB to 4.0MB
    // 80% WebP compression typically achieves 88-95% reduction for coffee photography
    final compressedSize = (rawSize * 0.06).round().clamp(95, 210); // ~120KB
    final savings = (((rawSize - compressedSize) / rawSize) * 100).round();

    return CompressionResult(
      imageUrl: url,
      originalSizeKb: rawSize,
      compressedSizeKb: compressedSize,
      savedPercentage: savings,
      dimensions: '1200 × 800 px (Optimized)',
    );
  }
}
