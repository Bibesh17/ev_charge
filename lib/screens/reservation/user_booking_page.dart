import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/reservation/reservation_service.dart';
import 'package:ev_charge/services/user/payment_service.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

class UserBookingPage extends StatefulWidget {
  static const String routeName = '/booking-page';
  final String name, address, id;
  const UserBookingPage(
      {super.key, required this.name, required this.address, required this.id});

  @override
  State<UserBookingPage> createState() => _UserBookingPageState();
}

class _UserBookingPageState extends State<UserBookingPage> {
  final TextEditingController chargingStationController =
      TextEditingController();
  final TextEditingController chargingStationLocationController =
      TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ReservationService reservationService = ReservationService();
  final PaymentService paymentService = PaymentService();

  late DateTime startDateTime, endDateTime;

  late double chargingDurationInHours;
  late int amount;

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    print('************************************************');
    print('Picked Time: $picked');
    if (picked != null) {
      // Format time as hh:mm and set it in the controller
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      controller.text = formattedTime;
      print('Formatted Tiem: $formattedTime');
    }
  }

  // Function to validate times
  bool validateTime() {
    if (startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
      showSnackBar(context, 'Please select both start and end times');
      return false;
    }

    // Parse the selected start and end times as TimeOfDay
    TimeOfDay startTime = TimeOfDay(
      hour: int.parse(startTimeController.text.split(":")[0]),
      minute: int.parse(startTimeController.text.split(":")[1]),
    );
    TimeOfDay endTime = TimeOfDay(
      hour: int.parse(endTimeController.text.split(":")[0]),
      minute: int.parse(endTimeController.text.split(":")[1]),
    );

    // Convert TimeOfDay to DateTime for comparison
    final now = DateTime.now();
    startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    // Check if start time is in the past
    if (startDateTime.isBefore(now)) {
      showSnackBar(context, 'Starting time must be in the future');
      return false;
    }

    if (endDateTime.isBefore(startDateTime)) {
      showSnackBar(context, 'Please enter a valid time');
      return false;
    }

    final Duration duration = endDateTime.difference(startDateTime);
    chargingDurationInHours = duration.inMinutes / 60.0;
    amount = (chargingDurationInHours * 250 * 100).toInt();

    return true;
  }

  void addReservation() {
    reservationService.bookStation(
      context: context,
      stationId: widget.id,
      startingTime: startDateTime,
      endingTime: endDateTime,
      paymentAmount: amount.toString(),
      remarks: remarksController.text,
    );
  }

  void makePayment() {
    paymentService.makePayment(
      context: context,
      duration: chargingDurationInHours,
      onSuccess: addReservation,
      amount: amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    chargingStationController.text = widget.name;
    chargingStationLocationController.text = widget.address;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 240, 242, 246),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextfield(
                  labelText: 'Charging Station',
                  obscureText: false,
                  controller: chargingStationController,
                  icon: Icons.business,
                  readOnly: true,
                ),
                CustomTextfield(
                  labelText: 'Charging Station Location',
                  obscureText: false,
                  controller: chargingStationLocationController,
                  icon: Icons.location_on,
                  readOnly: true,
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _selectTime(context, startTimeController),
                  child: AbsorbPointer(
                    child: CustomTextfield(
                      labelText: 'Starting Time',
                      obscureText: false,
                      controller: startTimeController,
                      icon: Icons.watch,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _selectTime(context, endTimeController),
                  child: AbsorbPointer(
                    child: CustomTextfield(
                      labelText: 'Ending Time',
                      obscureText: false,
                      controller: endTimeController,
                      icon: Icons.watch,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextfield(
                  labelText: 'Remarks',
                  obscureText: false,
                  controller: remarksController,
                  icon: Icons.note,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Note: You would not get the refund of the payment and you are supposed to reach the charging station within 30 minutes of your booking. Otherwise, your booking might get cancelled.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (validateTime()) {
                        // makePayment();
                        addReservation();
                        startTimeController.clear();
                        endTimeController.clear();
                        remarksController.clear();
                      }
                    }
                  },
                  style: elevatedButtonStyle,
                  child: const Text(
                    'Book Station',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
