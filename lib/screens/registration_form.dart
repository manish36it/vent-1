import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  final DateTime? selectedStartDate;
  final TimeOfDay? selectedStartTime;
  final DateTime? selectedEndDate;
  final TimeOfDay? selectedEndTime;
  final Function(BuildContext) selectStartDate;
  final Function(BuildContext) selectStartTime;
  final Function(BuildContext) selectEndDate;
  final Function(BuildContext) selectEndTime;
  final VoidCallback submitForm;

  RegistrationForm({
    required this.selectedStartDate,
    required this.selectedStartTime,
    required this.selectedEndDate,
    required this.selectedEndTime,
    required this.selectStartDate,
    required this.selectStartTime,
    required this.selectEndDate,
    required this.selectEndTime,
    required this.submitForm,
  });

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  bool _isSubmitted = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm:ss');

    String startDateText = 'Select Start Date';
    if (widget.selectedStartDate != null) {
      startDateText = dateFormat.format(widget.selectedStartDate!);
    }

    String startTimeText = 'Select Start Time';
    if (widget.selectedStartTime != null) {
      startTimeText = timeFormat.format(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          widget.selectedStartTime!.hour,
          widget.selectedStartTime!.minute,
        ),
      );
    }

    String endDateText = 'Select End Date';
    if (widget.selectedEndDate != null) {
      endDateText = dateFormat.format(widget.selectedEndDate!);
    }

    String endTimeText = 'Select End Time';
    if (widget.selectedEndTime != null) {
      endTimeText = timeFormat.format(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          widget.selectedEndTime!.hour,
          widget.selectedEndTime!.minute,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Program Name',
                  hintText: 'Enter Program Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Program Name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Program Type',
                  hintText: 'Enter Program Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Program Type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'No. of Participants',
                  hintText: 'Enter No. of Participants',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.group),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter No. of Participants';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: startDateController,
                validator: (value) {
                  if (widget.selectedStartDate == null) {
                    return 'Please select a Start Date';
                  }
                  return null;
                },
                onTap: () async {
                  await widget.selectStartDate(context);
                  startDateController.text =
                      dateFormat.format(widget.selectedStartDate!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                controller: startTimeController,
                validator: (value) {
                  if (widget.selectedStartTime == null) {
                    return 'Please select a Start Time';
                  }
                  return null;
                },
                onTap: () async {
                  await widget.selectStartTime(context);
                  startTimeController.text =
                      timeFormat.format(DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        widget.selectedStartTime!.hour,
                        widget.selectedStartTime!.minute,
                      ));
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: endDateController,
                validator: (value) {
                  if (widget.selectedEndDate == null) {
                    return 'Please select an End Date';
                  }
                  return null;
                },
                onTap: () async {
                  await widget.selectEndDate(context);
                  endDateController.text =
                      dateFormat.format(widget.selectedEndDate!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'End Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                controller: endTimeController,
                validator: (value) {
                  if (widget.selectedEndTime == null) {
                    return 'Please select an End Time';
                  }
                  return null;
                },
                onTap: () async {
                  await widget.selectEndTime(context);
                  endTimeController.text =
                      timeFormat.format(DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        widget.selectedEndTime!.hour,
                        widget.selectedEndTime!.minute,
                      ));
                },
              ),
              SizedBox(height: 32),
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: child,
                    );
                  },
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Registering...'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: child,
                    );
                  },
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Registering...'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitted ? null : widget.submitForm,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.done), // Add your chosen icon here
                      SizedBox(width: 8), // Add spacing between icon and label
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
