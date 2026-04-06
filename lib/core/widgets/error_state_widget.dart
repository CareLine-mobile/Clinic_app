import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/utils/assets.dart'; // Ensure Assets.errorServerIcon is here
import 'package:clinic_app/core/widgets/custom_lottie_icon.dart';
import 'package:flutter/material.dart';
import '../errors/failure_message_mapper.dart';
import '../errors/failures.dart';
import '../utils/enums.dart';
import '../utils/app_size.dart';

// Assuming CustomLottieIcon is imported here or in the same file
// import 'package:clinic_app/widgets/custom_lottie_icon.dart';

class ErrorStateWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;
  final bool showAppBar;

  const ErrorStateWidget({
    Key? key,
    required this.failure,
    required this.onRetry,
    this.showAppBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeV = AppSizeVertical.instance;
    final sizeH = AppSizeHorizontal.instance;

    // Get error info using FailureMessageMapper
    final errorType = FailureMessageMapper.mapFailureToErrorType(failure);
    final title = FailureMessageMapper.mapFailureToMessage(failure);
    final subtitle = FailureMessageMapper.getSubtitle(failure);
    final actionLabel = FailureMessageMapper.getActionMessage(failure);

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replaced the Icon() widget with our dynamic widget builder
            _buildErrorVisual(errorType),

            SizedBox(height: sizeV.s24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: sizeV.s12),
            Text(
              subtitle,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorsManager.miscellaneous,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: sizeV.s32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel),
              style: ElevatedButton.styleFrom(
                iconColor: ColorsManager.defaultSurface,
                padding: EdgeInsets.symmetric(
                  horizontal: sizeH.s32,
                  vertical: sizeV.s14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method that returns a Widget instead of IconData
  Widget _buildErrorVisual(ErrorType type) {
    final color = _getColorForErrorType(type);
    const double iconSize = 80.0;
    const double lottiSize = 180.0;

    switch (type) {
      case ErrorType.server:
        return const CustomLottieIcon(
          assetPath: Assets.errorServerIcon,
          width: lottiSize,
          height: lottiSize,
        );
      case ErrorType.network:
        return const CustomLottieIcon(
          assetPath: Assets.errorConnectionIcon,
          width: lottiSize,
          height: iconSize,
        );
      case ErrorType.auth:
        return Icon(Icons.lock_outline, size: iconSize, color: color);
      case ErrorType.cache:
        return Icon(Icons.storage, size: iconSize, color: color);
      case ErrorType.validation:
        return Icon(Icons.warning_amber, size: iconSize, color: color);
      case ErrorType.unknown:
      return Icon(Icons.error_outline, size: iconSize, color: color);
    }
  }

  Color _getColorForErrorType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.orange[400]!;
      case ErrorType.server:
        return Colors.red[400]!;
      case ErrorType.auth:
        return Colors.red[400]!;
      case ErrorType.cache:
        return Colors.blue[400]!;
      case ErrorType.validation:
        return Colors.amber[600]!;
      case ErrorType.unknown:
        return Colors.grey[400]!;
    }
  }
}

// Extension for easy usage
extension FailureWidgetExtension on Failure {
  Widget toErrorWidget({
    required VoidCallback onRetry,
    bool showAppBar = false,
  }) {
    return ErrorStateWidget(
      failure: this,
      onRetry: onRetry,
      showAppBar: showAppBar,
    );
  }
}