import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationsTabScreen extends StatefulWidget {
  const MedicationsTabScreen({Key? key}) : super(key: key);

  @override
  State<MedicationsTabScreen> createState() => _MedicationsTabScreenState();
}

class _MedicationsTabScreenState extends State<MedicationsTabScreen> {
  MedicationFilter _selectedFilter = MedicationFilter.all;

  // Sample data for UI demonstration
  final List<MedicationModel> _sampleMedications = [
    MedicationModel(
      id: '1',
      name: 'باراسيتامول',
      dosage: '500 ملجم',
      frequency: 'daily',
      times: ['8:00 AM', '2:00 PM', '8:00 PM'],
      imageUrl: null,
    ),
    MedicationModel(
      id: '2',
      name: 'فيتامين د',
      dosage: '1000 وحدة دولية',
      frequency: 'weekly',
      times: ['9:00 AM'],
      imageUrl: null,
    ),
    MedicationModel(
      id: '3',
      name: 'إيبوبروفين',
      dosage: '400 ملجم',
      frequency: 'as_needed',
      times: [],
      imageUrl: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(_sampleMedications.length),
          _buildFilterChips(),
          _buildStatisticsCards(_sampleMedications),
          _buildMedicationsList(_sampleMedications),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }

  // ==================== SLIVER APP BAR ====================

  Widget _buildSliverAppBar(int totalCount) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SliverAppBar(
      expandedHeight: 140.h,
      floating: false,
      pinned: true,
      backgroundColor: theme.cardColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                theme.cardColor,
                primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.local_pharmacy_rounded,
                          color: primaryColor,
                          size: 24.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '$totalCount دواء',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  _buildAddButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return IconButton(
      onPressed: () {
        // Navigate to add medication screen
        // Navigator.pushNamed(context, '/add-medication');
      },
      icon: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 20.r,
        ),
      ),
    );
  }

  // ==================== FILTER CHIPS ====================

  Widget _buildFilterChips() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50.h,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: MedicationFilter.values.length,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            final filter = MedicationFilter.values[index];
            return _buildFilterChip(filter);
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(MedicationFilter filter) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilter == filter;
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? primaryColor : theme.dividerColor,
          ),
        ),
        child: Text(
          filter.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : theme.hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ==================== STATISTICS ====================

  Widget _buildStatisticsCards(List<MedicationModel> medications) {
    final dailyCount = medications.where((m) => m.frequency == 'daily').length;
    final weeklyCount = medications.where((m) => m.frequency == 'weekly').length;
    final asNeededCount = medications.where((m) => m.frequency == 'as_needed').length;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'medication.filter_daily'.tr(),
                count: dailyCount.toString(),
                icon: Icons.calendar_today,
                color: const Color(0xFF1E88E5),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                label: 'medication.filter_weekly'.tr(),
                count: weeklyCount.toString(),
                icon: Icons.event_repeat,
                color: const Color(0xFF4CAF50),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                label: 'medication.filter_as_needed'.tr(),
                count: asNeededCount.toString(),
                icon: Icons.medication_liquid,
                color: const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.r),
          SizedBox(height: 8.h),
          Text(
            count,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MEDICATIONS LIST ====================

  Widget _buildMedicationsList(List<MedicationModel> medications) {
    final filteredMedications = _getFilteredMedications(medications);
    final groupedMedications = _groupMedicationsByFrequency(filteredMedications);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final entry = groupedMedications.entries.elementAt(index);
          return _buildMedicationGroup(entry.key, entry.value);
        },
        childCount: groupedMedications.length,
      ),
    );
  }

  List<MedicationModel> _getFilteredMedications(List<MedicationModel> medications) {
    if (_selectedFilter == MedicationFilter.all) {
      return medications;
    }
    return medications.where((m) => m.frequency == _selectedFilter.value).toList();
  }

  Map<String, List<MedicationModel>> _groupMedicationsByFrequency(
      List<MedicationModel> medications,
      ) {
    final grouped = <String, List<MedicationModel>>{};
    for (var med in medications) {
      grouped.putIfAbsent(med.frequency, () => []).add(med);
    }
    return grouped;
  }

  Widget _buildMedicationGroup(String frequency, List<MedicationModel> medications) {
    final theme = Theme.of(context);
    final label = frequency == 'daily'
        ? 'medication.group_daily'.tr()
        : frequency == 'weekly'
        ? 'medication.group_weekly'.tr()
        : 'medication.group_as_needed'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            '$label (${medications.length})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: medications
                .map((med) => _buildMedicationCard(med))
                .toList(),
          ),
        ),
      ],
    );
  }

  // ==================== MEDICATION CARD ====================

  Widget _buildMedicationCard(MedicationModel medication) {
    final theme = Theme.of(context);
    final (icon, color) = _getFrequencyStyle(medication.frequency);
    final timesText = medication.times.length > 1
        ? 'medication.times_multiple'.tr().replaceAll('{count}', '${medication.times.length}')
        : 'medication.times_once'.tr();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Dismissible(
        key: Key(medication.id),
        background: _buildDismissBackground(
          color: Colors.red[400]!,
          icon: Icons.delete_outline,
          alignment: Alignment.centerRight,
        ),
        secondaryBackground: _buildDismissBackground(
          color: theme.colorScheme.primary,
          icon: Icons.edit_outlined,
          alignment: Alignment.centerLeft,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Edit action
            return false;
          } else {
            // Delete action
            return await _showDeleteDialog(medication.name);
          }
        },
        child: _buildCardContent(medication, icon, color, timesText, theme),
      ),
    );
  }

  Widget _buildDismissBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Icon(icon, color: Colors.white, size: 24.r),
    );
  }

  Future<bool> _showDeleteDialog(String name) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('medication.delete_title'.tr()),
        content: Text('medication.delete_confirm'.tr().replaceAll('{name}', name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('medication.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('medication.delete'.tr()),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget _buildCardContent(
      MedicationModel medication,
      IconData icon,
      Color color,
      String timesText,
      ThemeData theme,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to medication details
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                _buildMedicationImage(icon, color),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        medication.dosage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    timesText,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right,
                  color: theme.dividerColor,
                  size: 20.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationImage(IconData icon, Color color) {
    return Container(
      width: 56.r,
      height: 56.r,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(
        icon,
        color: color,
        size: 28.r,
      ),
    );
  }

  (IconData, Color) _getFrequencyStyle(String frequency) {
    switch (frequency) {
      case 'daily':
        return (Icons.calendar_today, const Color(0xFF1E88E5));
      case 'weekly':
        return (Icons.event_repeat, const Color(0xFF4CAF50));
      case 'as_needed':
        return (Icons.medication_liquid, const Color(0xFF9C27B0));
      default:
        return (Icons.medication, Colors.grey);
    }
  }
}

// ==================== MODELS ====================

enum MedicationFilter {
  all('all', 'الكل'),
  daily('daily', 'يومي'),
  weekly('weekly', 'أسبوعي'),
  asNeeded('as_needed', 'عند الحاجة');

  final String value;
  final String label;
  const MedicationFilter(this.value, this.label);
}

class MedicationModel {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final List<String> times;
  final String? imageUrl;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    this.imageUrl,
  });
}