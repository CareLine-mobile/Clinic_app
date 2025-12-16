// lib/features/clinics/presentation/widgets/clinic_image_gallery_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';

class ClinicImageGalleryWidget extends StatefulWidget {
  final List<String> imageUrls;
  final bool isOpen;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ClinicImageGalleryWidget({
    Key? key,
    required this.imageUrls,
    required this.isOpen,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<ClinicImageGalleryWidget> createState() =>
      _ClinicImageGalleryWidgetState();
}

class _ClinicImageGalleryWidgetState extends State<ClinicImageGalleryWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  final int _maxVisibleThumbnails = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onThumbnailTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Main Image Gallery
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index) {
            return Image.network(
              widget.imageUrls[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.local_hospital,
                    size: 60,
                    color: Colors.grey,
                  ),
                );
              },
            );
          },
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),

        // Status Badge
        Positioned(
          top: vSize.s50,
          left: hSize.s16,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: hSize.s12,
              vertical: vSize.s6,
            ),
            decoration: BoxDecoration(
              color: widget.isOpen ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(hSize.s20),
            ),
            child: Text(
              widget.isOpen ? 'مفتوح' : 'مغلق',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Favorite Button
        Positioned(
          top: vSize.s50,
          right: hSize.s16,
          child: GestureDetector(
            onTap: widget.onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(hSize.s10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : Colors.grey[700],
                size: 24.r,
              ),
            ),
          ),
        ),

        // Thumbnail Strip at Bottom
        Positioned(
          bottom: vSize.s16,
          left: hSize.s32,
          right: hSize.s32,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: EdgeInsets.all(4),
            height: 60.h,
            child: Row(
              children: [
                // Thumbnails
                ...List.generate(
                  _maxVisibleThumbnails.clamp(0, widget.imageUrls.length),
                      (index) => _buildThumbnail(index),
                ),

                // "+N" indicator if there are more images
                if (widget.imageUrls.length > _maxVisibleThumbnails)
                  _buildMoreIndicator(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(int index) {
    final isSelected = index == _currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onThumbnailTap(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                if (!isSelected)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreIndicator() {
    final remainingCount = widget.imageUrls.length - _maxVisibleThumbnails;

    return Expanded(
      child: GestureDetector(
        onTap: _showAllImages,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withAlpha(150),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              '+$remainingCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAllImages() {
    final hSize = AppSizeHorizontal.instance;
    final vSize = AppSizeVertical.instance;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(hSize.s16),
                child: Text(
                  'جميع الصور',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(hSize.s16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: widget.imageUrls.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _onThumbnailTap(index);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}