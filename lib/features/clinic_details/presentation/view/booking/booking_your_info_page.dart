import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/app_buton.dart';
import '../../cubit/clinic_details_cubit.dart';

class BookingYourInfoPage extends StatefulWidget {
  const BookingYourInfoPage({super.key});

  @override
  State<BookingYourInfoPage> createState() => _BookingYourInfoPageState();
}

class _BookingYourInfoPageState extends State<BookingYourInfoPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ClinicDetailsCubit>().state;
    final loaded = state is ClinicDetailsLoaded ? state : null;
    _nameController = TextEditingController(text: loaded?.patientName ?? '');
    _phoneController = TextEditingController(text: loaded?.patientPhone ?? '');
    _notesController = TextEditingController(text: loaded?.bookingNotes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        if (state is! ClinicDetailsLoaded) return const SizedBox.shrink();

        final cubit = context.read<ClinicDetailsCubit>();

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'booking.your_info'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              SizedBox(height: 24.h),

              _buildField(
                theme: theme,
                label: 'booking.full_name'.tr(),
                hint: 'booking.full_name_hint'.tr(),
                controller: _nameController,
                icon: Icons.person_outline,
                onChanged: cubit.updatePatientName,
              ),
              SizedBox(height: 16.h),

              _buildField(
                theme: theme,
                label: 'booking.phone'.tr(),
                hint: 'booking.phone_hint'.tr(),
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: cubit.updatePatientPhone,
              ),
              SizedBox(height: 16.h),

              _buildField(
                theme: theme,
                label: 'booking.notes_optional'.tr(),
                hint: 'booking.notes_hint'.tr(),
                controller: _notesController,
                icon: Icons.notes_outlined,
                maxLines: 3,
                onChanged: cubit.updateBookingNotes,
              ),

              SizedBox(height: 32.h),

              AppButton(
                text: 'booking.continue'.tr(),
                onPressed: state.canProceedStep2
                    ? () => cubit.nextBookingStep()
                    : null,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildField({
    required ThemeData theme,
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorsManager.defaultText,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: ColorsManager.inputBorder, size: 20.sp),
          ),
        ),
      ],
    );
  }
}