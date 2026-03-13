// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../../../../core/theme/colors.dart';
// import '../cubit/booking_cubit.dart';
// import '../cubit/booking_state.dart';
//
// class DateTimeline extends StatelessWidget {
//   const DateTimeline({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.calendar_today_outlined, color: ColorsManager.primaryColor),
//             const SizedBox(width: 8),
//             Text(
//               "Choose Date",
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         BlocBuilder<BookingCubit, BookingState>(
//           builder: (context, state) {
//             if (state is BookingLoaded) {
//               return SizedBox(
//                 height: 60,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: state.dates.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 12),
//                   itemBuilder: (context, index) {
//                     final bookingDate = state.dates[index];
//                     final isSelected = isSameDay(bookingDate.date, state.selectedDate);
//                     return GestureDetector(
//                       onTap: () {
//                         context.read<BookingCubit>().selectDate(bookingDate.date);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: isSelected ? ColorsManager.primaryColor.withOpacity(0.1) : Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: isSelected ? ColorsManager.primaryColor : Colors.grey.shade300,
//                             width: isSelected ? 2 : 1,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             DateFormat('EEE, MMM d').format(bookingDate.date),
//                             style: TextStyle(
//                               color: isSelected ? ColorsManager.primaryColor : Colors.black87,
//                               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//             return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
//           },
//         ),
//       ],
//     );
//   }
//
//   bool isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }
// }
