// ==================== sections/image_gallery_section.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../cubit/clinic_details_cubit.dart';
import '../../widgets/clinic_image_gallery_widget.dart';

class ImageGallerySection extends StatelessWidget {
  final ClinicDetails clinic;

  const ImageGallerySection({
    Key? key,
    required this.clinic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 400.h,
        child: ClinicImageGalleryWidget(
          imageUrls: clinic.imageUrls,
          isOpen: clinic.isOpen,
          isFavorite: clinic.isFavorite,
          onFavoriteToggle: () {
            context.read<ClinicDetailsCubit>().toggleFavorite();
          },
        ),
      ),
    );
  }
}