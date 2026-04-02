import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/empty_state_widget.dart';
import '../../cubit/search_cubit.dart';

class SearchErrorView extends StatelessWidget {
  final String message;
  const SearchErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.wifi_off_rounded,
      title: 'errors.network.title'.tr(),
      subtitle: message,
      enableBackButton: false,   // ← no back button
      actionLabel: 'common.retry'.tr(),
      onActionPressed: () => context.read<SearchCubit>().retry(),
    );
  }
}