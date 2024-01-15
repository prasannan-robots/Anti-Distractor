import 'package:Mentor/core/loader.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../core/loader.dart';
import 'dart:isolate';
import 'dart:ui';

class PreferredTimePage extends StatefulWidget {
  @override
  _PreferredTimePageState createState() => _PreferredTimePageState();
}

class _PreferredTimePageState extends State<PreferredTimePage> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  ReceivePort port = ReceivePort();
  String isolateName = 'background_isolate';
  Loader _loader = Loader();
  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );

    _loader.getSelectedTime().then((time) {
      setState(() {
        _selectedTime = time ?? TimeOfDay.now();
      });
    });
    port.listen((_) async => await _update());
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
      await _loader.saveSelectedTime(pickedTime);
      final now = DateTime.now();
      final initialAlarmDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        0, // This is the alarm ID
        Loader.makerequest,
        startAt: initialAlarmDateTime,
        exact: true,
        wakeup: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preference set as ${_selectedTime.format(context)}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Preferred Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Preferred Time:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              '${_selectedTime.format(context)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
          ],
        ),
      ),
    );
  }
}
