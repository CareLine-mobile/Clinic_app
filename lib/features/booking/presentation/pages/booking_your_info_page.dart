import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/app_buton.dart';
import '../cubit/booking_flow_cubit.dart';

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
    final state = context.read<BookingFlowCubit>().state;
    _nameController = TextEditingController(text: state.patientName);
    _phoneController = TextEditingController(text: state.patientPhone);
    _notesController = TextEditingController(text: state.notes);
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
    return BlocBuilder<BookingFlowCubit, BookingFlowState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Information",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              _buildField(
                label: "Full Name",
                hint: "Enter your full name",
                controller: _nameController,
                icon: Icons.person_outline,
                onChanged: (v) => context.read<BookingFlowCubit>().updatePatientName(v),
              ),
              const SizedBox(height: 16),

              _buildField(
                label: "Phone Number",
                hint: "Enter your phone number",
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: (v) => context.read<BookingFlowCubit>().updatePatientPhone(v),
              ),
              const SizedBox(height: 16),

              _buildField(
                label: "Notes (Optional)",
                hint: "Any symptoms or notes for the doctor...",
                controller: _notesController,
                icon: Icons.notes_outlined,
                maxLines: 3,
                onChanged: (v) => context.read<BookingFlowCubit>().updateNotes(v),
              ),

              const SizedBox(height: 32),

              AppButton(
                text: "Continue",
                onPressed: state.canProceedStep2
                    ? () => context.read<BookingFlowCubit>().nextStep()
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
              borderSide: const BorderSide(color: ColorsManager.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}