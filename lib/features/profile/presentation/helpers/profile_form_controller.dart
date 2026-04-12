import 'package:flutter/material.dart';
import '../../data/profile_model.dart';
import '../helpers/profile_progress_helper.dart';

class ProfileFormController {
  // ── Text controllers ──────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final emergencyController = TextEditingController();
  final addDiseaseController = TextEditingController();

  // ── Form state ────────────────────────────────────────────────────────────
  DateTime? birthDate;
  String? gender;
  String? bloodType;
  List<String> chronicDiseases = [];

  // ── Progress ──────────────────────────────────────────────────────────────
  final progressNotifier = ValueNotifier<double>(0.0);

  bool _initialized = false;
  bool get isInitialized => _initialized;

  // ── Init ──────────────────────────────────────────────────────────────────
  void init() {
    nameController.addListener(updateProgress);
    emergencyController.addListener(updateProgress);
  }

  void dispose() {
    nameController
      ..removeListener(updateProgress)
      ..dispose();
    emergencyController
      ..removeListener(updateProgress)
      ..dispose();
    addDiseaseController.dispose();
    progressNotifier.dispose();
  }

  // ── Progress ──────────────────────────────────────────────────────────────
  void updateProgress() {
    int count = 0;
    if (nameController.text.trim().isNotEmpty) count++;
    if (birthDate != null) count++;
    if (gender != null) count++;
    if (bloodType != null) count++;
    if (emergencyController.text.trim().isNotEmpty) count++;
    progressNotifier.value = count / 5.0;
  }

  // ── Populate ──────────────────────────────────────────────────────────────
  void populateFrom(ProfileModel profile, VoidCallback onSetState) {
    if (_initialized) return;
    _initialized = true;
    nameController.text = profile.fullName ?? '';
    emergencyController.text = profile.emergencyContact ?? '';
    birthDate = profile.birthDate;
    gender = profile.gender;
    bloodType = profile.bloodType;
    chronicDiseases = List<String>.from(profile.chronicDiseases ?? []);
    onSetState();
    updateProgress();
  }

  // ── Disease helpers ───────────────────────────────────────────────────────
  void addDisease(VoidCallback onSetState) {
    final d = addDiseaseController.text.trim();
    if (d.isNotEmpty && !chronicDiseases.contains(d)) {
      chronicDiseases.add(d);
      addDiseaseController.clear();
      onSetState();
    }
  }

  void removeDisease(String d, VoidCallback onSetState) {
    chronicDiseases.remove(d);
    onSetState();
  }

  // ── Field change handlers ─────────────────────────────────────────────────
  void onBloodTypeSelected(String type, VoidCallback onSetState) {
    bloodType = bloodType == type ? null : type;
    onSetState();
    updateProgress();
  }

  void onGenderChanged(String? value, VoidCallback onSetState) {
    gender = value;
    onSetState();
    updateProgress();
  }

  Future<void> pickDate(BuildContext context, VoidCallback onSetState) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 1, now.month, now.day),
      builder: (ctx, child) => Theme(data: Theme.of(ctx), child: child!),
    );
    if (picked != null) {
      birthDate = picked;
      onSetState();
      updateProgress();
    }
  }

  // ── Color / hint delegates ────────────────────────────────────────────────
  Color progressColor(double v, ThemeData theme) =>
      ProfileProgressHelper.progressColor(v, theme);

  String progressHint(int completed) =>
      ProfileProgressHelper.progressHint(completed);

  String formatDate(DateTime d) => ProfileProgressHelper.formatDate(d);
}