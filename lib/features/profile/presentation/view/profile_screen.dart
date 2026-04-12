import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';

import '../../data/profile_model.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Controllers ───────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _addDiseaseController = TextEditingController();

  // ── Local form state ──────────────────────────────────────────────────────
  DateTime? _birthDate;
  String? _gender;
  String? _bloodType;
  List<String> _chronicDiseases = [];

  // ── Progress tracking ─────────────────────────────────────────────────────
  late final ValueNotifier<double> _progressNotifier;
  bool _initialized = false;

  static const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _progressNotifier = ValueNotifier(0.0);
    _nameController.addListener(_updateProgress);
    _emergencyController.addListener(_updateProgress);
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_updateProgress)
      ..dispose();
    _emergencyController
      ..removeListener(_updateProgress)
      ..dispose();
    _addDiseaseController.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  // ── Progress ──────────────────────────────────────────────────────────────

  void _updateProgress() {
    int count = 0;
    if (_nameController.text.trim().isNotEmpty) count++;
    if (_birthDate != null) count++;
    if (_gender != null) count++;
    if (_bloodType != null) count++;
    if (_emergencyController.text.trim().isNotEmpty) count++;
    _progressNotifier.value = count / 5.0;
  }

  // ── Populate ──────────────────────────────────────────────────────────────

  void _populateFrom(ProfileModel profile) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = profile.fullName ?? '';
    _emergencyController.text = profile.emergencyContact ?? '';
    setState(() {
      _birthDate = profile.birthDate;
      _gender = profile.gender;
      _bloodType = profile.bloodType;
      _chronicDiseases = List<String>.from(profile.chronicDiseases ?? []);
    });
    _updateProgress();
  }

  // ── Field handlers ────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 1, now.month, now.day),
      builder: (ctx, child) => Theme(data: Theme.of(ctx), child: child!),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
      _updateProgress();
    }
  }

  void _onGenderChanged(String? value) {
    setState(() => _gender = value);
    _updateProgress();
  }

  void _onBloodTypeSelected(String type) {
    setState(() => _bloodType = _bloodType == type ? null : type);
    _updateProgress();
  }

  void _addDisease() {
    final d = _addDiseaseController.text.trim();
    if (d.isNotEmpty && !_chronicDiseases.contains(d)) {
      setState(() => _chronicDiseases.add(d));
      _addDiseaseController.clear();
    }
  }

  void _removeDisease(String d) => setState(() => _chronicDiseases.remove(d));

  // ── Submit ────────────────────────────────────────────────────────────────

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_birthDate == null) {
      CustomSnackBar.show(
        context,
        message: 'profile.validation.birthDateRequired'.tr(),
        type: SnackBarType.error,
      );
      return;
    }
    if (_gender == null) {
      CustomSnackBar.show(
        context,
        message: 'profile.validation.genderRequired'.tr(),
        type: SnackBarType.error,
      );
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      fullName: _nameController.text.trim(),
      birthDate: _birthDate!,
      gender: _gender!,
      bloodType: _bloodType,
      chronicDiseases:
      _chronicDiseases.isEmpty ? null : List.from(_chronicDiseases),
      emergencyContact: _emergencyController.text.trim(),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  Color _progressColor(double v, ThemeData t) {
    if (v < 0.41) return Colors.red.shade400;
    if (v < 0.81) return Colors.orange.shade500;
    return Colors.green.shade500;
  }

  String _progressHint(int completed) {
    if (completed >= 5) return '';
    return 'profile.completion.hint$completed'.tr();
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('profile.appBarTitle'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (_, current) =>
        current is ProfileLoaded ||
            current is ProfileLoadError ||
            current is ProfileUpdateSuccess ||
            current is ProfileUpdateFailure,
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _populateFrom(state.profile);
          } else if (state is ProfileLoadError) {
            CustomSnackBar.show(context,
                message: state.message, type: SnackBarType.error);
          } else if (state is ProfileUpdateSuccess) {
            CustomSnackBar.show(
              context,
              message: 'profile.messages.saveSuccess'.tr(),
              type: SnackBarType.success,
            );
            Future.delayed(const Duration(milliseconds: 900), () {
              if (mounted) Navigator.pop(context);
            });
          } else if (state is ProfileUpdateFailure) {
            CustomSnackBar.show(context,
                message: state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          if (!_initialized &&
              (state is ProfileInitial || state is ProfileLoading)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_initialized && state is ProfileLoadError) {
            return _buildLoadErrorView(state.message, theme);
          }

          final isUpdating = state is ProfileUpdating;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressSection(theme),
                  const SizedBox(height: 20),
                  _buildPersonalSection(theme),
                  const SizedBox(height: 14),
                  _buildMedicalSection(theme),
                  const SizedBox(height: 14),
                  _buildEmergencySection(theme),
                  const SizedBox(height: 28),
                  AppButton(
                    text: 'profile.actions.save'.tr(),
                    onPressed: isUpdating ? null : _submit,
                    isLoading: isUpdating,
                    horizontalPadding: 0,
                    verticalPadding: 0,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Section builders
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildLoadErrorView(String message, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            AppButton(
              text: 'profile.actions.retry'.tr(),
              onPressed: () => context.read<ProfileCubit>().loadProfile(),
              horizontalPadding: 0,
              verticalPadding: 0,
            ),
          ],
        ),
      ),
    );
  }

  // ── Progress circle ───────────────────────────────────────────────────────

  Widget _buildProgressSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(
            'profile.completion.title'.tr(),
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<double>(
            valueListenable: _progressNotifier,
            builder: (_, progress, __) {
              final completed = (progress * 5).round();
              return Column(
                children: [
                  SizedBox(
                    width: 136,
                    height: 136,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Track
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 10,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.dividerColor.withOpacity(0.25),
                            ),
                          ),
                        ),
                        // Animated fill
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => SizedBox.expand(
                            child: CircularProgressIndicator(
                              value: v,
                              strokeWidth: 10,
                              strokeCap: StrokeCap.round,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _progressColor(v, theme),
                              ),
                            ),
                          ),
                        ),
                        // Animated counter
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(v * 100).toInt()}%',
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _progressColor(v, theme),
                                ),
                              ),
                              Text(
                                'profile.completion.done'.tr(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color:
                                  theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'profile.completion.of5'
                        .tr(namedArgs: {'filled': '$completed'}),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                  if (progress < 1.0 && completed < 5) ...[
                    const SizedBox(height: 6),
                    Text(
                      _progressHint(completed),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _progressColor(progress, theme),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Card wrapper ──────────────────────────────────────────────────────────

  Widget _buildSectionCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
        BorderSide(color: theme.dividerColor.withOpacity(0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      size: 18, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: theme.dividerColor.withOpacity(0.4)),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // ── Personal ──────────────────────────────────────────────────────────────

  Widget _buildPersonalSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      icon: Icons.person_outline_rounded,
      title: 'profile.sections.personal'.tr(),
      children: [
        AppTextField(
          controller: _nameController,
          hintText: 'profile.fields.fullName'.tr(),
          prefixIcon: Icon(Icons.badge_outlined,
              color: Colors.grey.shade500, size: 20),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'profile.validation.nameRequired'.tr()
              : null,
        ),
        const SizedBox(height: 12),
        _buildDateField(theme),
        const SizedBox(height: 16),
        _buildGenderSelector(theme),
      ],
    );
  }

  Widget _buildDateField(ThemeData theme) {
    final hasDate = _birthDate != null;
    final label = hasDate
        ? _formatDate(_birthDate!)
        : 'profile.fields.dateOfBirth'.tr();
    final borderColor = hasDate
        ? theme.colorScheme.primary
        : (theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
        Colors.grey.shade300);

    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: hasDate ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 20,
                color: hasDate
                    ? theme.colorScheme.primary
                    : Colors.grey.shade500),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasDate
                      ? theme.colorScheme.onSurface
                      : Colors.grey.shade500,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded,
                color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector(ThemeData theme) {
    // Map backend values ('Male'/'Female') → localized display labels
    final genders = <String, String>{
      'Male': 'profile.gender.male'.tr(),
      'Female': 'profile.gender.female'.tr(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(theme, 'profile.fields.gender'.tr()),
        const SizedBox(height: 8),
        Row(
          children: genders.entries.toList().asMap().entries.map((entry) {
            final idx = entry.key;
            String backendValue = entry.value.key;   // 'Male' / 'Female'
            final displayLabel = entry.value.value; // translated
            final selected = _gender == backendValue;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: idx == 0 ? 8 : 0),
                child: InkWell(
                  onTap: () => _onGenderChanged(backendValue.toLowerCase()),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? theme.colorScheme.primary
                            : (theme.inputDecorationTheme.enabledBorder
                            ?.borderSide.color ??
                            Colors.grey.shade300),
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: backendValue,
                          groupValue: _gender,
                          onChanged: _onGenderChanged,
                          activeColor: theme.colorScheme.primary,
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(
                          displayLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          backendValue == 'Male'
                              ? Icons.male_rounded
                              : Icons.female_rounded,
                          size: 18,
                          color: selected
                              ? theme.colorScheme.primary
                              : Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Medical ───────────────────────────────────────────────────────────────

  Widget _buildMedicalSection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      icon: Icons.medical_information_outlined,
      title: 'profile.sections.medical'.tr(),
      children: [
        _buildBloodTypeSelector(theme),
        const SizedBox(height: 16),
        _buildChronicDiseasesInput(theme),
      ],
    );
  }

  Widget _buildBloodTypeSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(theme, 'profile.fields.bloodType'.tr()),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _bloodTypes.map((type) {
            final sel = _bloodType == type;
            return InkWell(
              onTap: () => _onBloodTypeSelected(type),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 54,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sel
                      ? theme.colorScheme.primary
                      : theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: sel
                        ? theme.colorScheme.primary
                        : (theme.inputDecorationTheme.enabledBorder
                        ?.borderSide.color ??
                        Colors.grey.shade300),
                    width: sel ? 0 : 1,
                  ),
                ),
                child: Text(
                  type,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: sel ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight:
                    sel ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChronicDiseasesInput(ThemeData theme) {
    final inputBorderColor =
        theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
            Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(theme, 'profile.fields.chronicDiseases'.tr()),
        const SizedBox(height: 10),
        if (_chronicDiseases.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _chronicDiseases.map((d) {
              return Chip(
                label: Text(d,
                    style: TextStyle(
                        color: theme.colorScheme.primary, fontSize: 13)),
                deleteIcon:
                const Icon(Icons.close_rounded, size: 15),
                onDeleted: () => _removeDisease(d),
                backgroundColor:
                theme.colorScheme.primary.withOpacity(0.1),
                deleteIconColor: theme.colorScheme.primary,
                side: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.3)),
                padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addDiseaseController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addDisease(),
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'profile.fields.chronicHint'.tr(),
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500, fontSize: 13),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: inputBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: inputBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: theme.colorScheme.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: _addDisease,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Emergency ─────────────────────────────────────────────────────────────

  Widget _buildEmergencySection(ThemeData theme) {
    return _buildSectionCard(
      theme: theme,
      icon: Icons.emergency_outlined,
      title: 'profile.sections.emergency'.tr(),
      children: [
        AppTextField(
          controller: _emergencyController,
          hintText: 'profile.fields.emergencyContact'.tr(),
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(Icons.phone_outlined,
              color: Colors.grey.shade500, size: 20),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'profile.validation.emergencyRequired'.tr() : null,
        ),
      ],
    );
  }

  // ── Shared ────────────────────────────────────────────────────────────────

  Widget _fieldLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}