// ==================== clinic_details_screen.dart ====================
import 'package:clinic_app/core/widgets/Loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../domain/entites/clinic_entities.dart';
import '../cubit/clinic_details_cubit.dart';
import '../cubit/clinic_ui_cubit.dart';
import 'content_view.dart';


class ClinicDetailsScreen extends StatefulWidget {
  final int clinicId;

  const ClinicDetailsScreen({
    Key? key,
    required this.clinicId,
  }) : super(key: key);

  @override
  State<ClinicDetailsScreen> createState() => _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState extends State<ClinicDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final TabController _tabController;

  static const int _tabCount = 4;
  static const double _appBarTransitionOffset = 180.0;

  // Keep track of the last loaded clinic
  ClinicDetails? _lastLoadedClinic;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadClinicData();
  }

  void _initializeControllers() {
    _scrollController = ScrollController()..addListener(_handleScroll);
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  void _loadClinicData() {
    context.read<ClinicDetailsCubit>().loadClinicDetails(widget.clinicId);
  }

  void _handleScroll() {
    final isTransparent = _scrollController.offset < _appBarTransitionOffset.h;
    context.read<ClinicUiCubit>().updateAppBarTransparency(isTransparent);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ClinicDetailsCubit, ClinicDetailsState>(
          listener: _handleStateChanges,
        ),
      ],
      child: BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  Widget _buildBody(ClinicDetailsState state) {
    return switch (state) {
      ClinicDetailsLoading() => const Scaffold(
        body: LoadingSpinner(),
      ),
      ClinicDetailsError() => Scaffold(
        body: EmptyStateWidget(
          title: state.message,
          onActionPressed: _loadClinicData,
          icon: Icons.error,
          enableBackButton: true,
          onBackPressed: () {
            Navigator.pop(context);
          },
          actionLabel: 'اضغط للمحاولة مرة أخرى',
          subtitle: '',

        ),
      ),
      ClinicDetailsLoaded() => _buildLoadedContent(state.clinic),
      BookingInProgress() => _buildLoadedContent(_lastLoadedClinic!),
      BookingSuccess() => _buildLoadedContent(_lastLoadedClinic!),
      BookingError() => _buildLoadedContent(_lastLoadedClinic!),
      _ => const Scaffold(
        body: Center(
          child: LoadingSpinner(),
        ),
      ),
    };
  }

  Widget _buildLoadedContent(ClinicDetails clinic) {
    // Cache the last loaded clinic
    _lastLoadedClinic = clinic;

    return ContentView(
      clinic: clinic,
      scrollController: _scrollController,
      tabController: _tabController,
    );
  }

  void _handleStateChanges(BuildContext context, ClinicDetailsState state) {
    switch (state) {
      case BookingSuccess():
        CustomSnackBar.show(
          context,
          message: state.message,
          type: SnackBarType.success,
        );
      case BookingError():
        CustomSnackBar.show(
          context,
          message: state.message,
          type: SnackBarType.error,
        );
      case ClinicDetailsError():
        CustomSnackBar.show(
          context,
          message: state.message,
          type: SnackBarType.error,
        );
      case ClinicDetailsLoaded():
      // Update cached clinic when loaded
        _lastLoadedClinic = state.clinic;
      default:
        break;
    }
  }
}