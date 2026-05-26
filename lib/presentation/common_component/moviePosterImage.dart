import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MoviePosterImage extends StatelessWidget {
  const MoviePosterImage({
    required this.imageUrl,
    required this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final loadingWidget = placeholder ?? const SizedBox.shrink();
    final failureWidget = errorWidget ?? const SizedBox.shrink();

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null ? child : loadingWidget,
        errorBuilder: (context, error, stackTrace) => failureWidget,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => loadingWidget,
      errorWidget: (context, url, error) => failureWidget,
    );
  }
}
