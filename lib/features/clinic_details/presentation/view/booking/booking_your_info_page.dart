import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Read initial values from state — not cubit getters
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
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        if (state is! ClinicDetailsLoaded) return const SizedBox.shrink();

        final cubit = context.read<ClinicDetailsCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'booking.your_info'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              _buildField(
                label: 'booking.full_name'.tr(),
                hint: 'booking.full_name_hint'.tr(),
                controller: _nameController,
                icon: Icons.person_outline,
                onChanged: cubit.updatePatientName,
              ),
              const SizedBox(height: 16),

              _buildField(
                label: 'booking.phone'.tr(),
                hint: 'booking.phone_hint'.tr(),
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: cubit.updatePatientPhone,
              ),
              const SizedBox(height: 16),

              _buildField(
                label: 'booking.notes_optional'.tr(),
                hint: 'booking.notes_hint'.tr(),
                controller: _notesController,
                icon: Icons.notes_outlined,
                maxLines: 3,
                onChanged: cubit.updateBookingNotes,
              ),

              const SizedBox(height: 32),

              AppButton(
                text: 'booking.continue'.tr(),
                // canProceedStep2 lives on the STATE now
                onPressed: state.canProceedStep2
                    ? () => cubit.nextBookingStep()
                    : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildField({
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
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ColorsManager.primaryColor, width: 2),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}