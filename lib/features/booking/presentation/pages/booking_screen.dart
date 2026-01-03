import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../data/datasources/booking_mock_datasource.dart';
import '../../data/repository/booking_repository_impl.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/booking_stepper.dart';
import '../pages/booking_date_time_page.dart';
import '../pages/booking_your_info_page.dart';
import '../pages/booking_confirmation_page.dart';


class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCubit(
        BookingRepositoryImpl(BookingMockDataSource()),
      )..loadBookingData(),
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          int currentStep = 0;
          if (state is BookingLoaded) {
            currentStep = state.currentStep;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "City Medical Center",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    "Book Appointment",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                    if (currentStep > 0) {
                        context.read<BookingCubit>().previousStep();
                    } else {
                        Navigator.of(context).pop();
                    }
                },
              ),
            ),
            body: Column(
              children: [
                const BookingStepper(),
                Expanded(
                  child: Builder(
                    builder: (context) {
                        switch (currentStep) {
                            case 0:
                                return const BookingDateTimePage();
                            case 1:
                                return  BookingYourInfoPage();
                             case 2:
                                return const BookingConfirmationPage();
                            default:
                                return const BookingDateTimePage();
                        }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
