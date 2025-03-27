import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:memorization_and_clock/alarm_setting.dart';
import 'model/alarm_manager.dart';

class CornerWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String time;
  final String date;

  const CornerWidget({
    Key? key,
    required this.onEdit,
    required this.onDelete,
    required this.time,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 10,
          child: Text(time, style: const TextStyle(fontSize: 18)),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text(date, style: const TextStyle(fontSize: 18)),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.create_sharp, size: 30),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_forever, size: 30, color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class ClockHomePage extends StatefulWidget {
  const ClockHomePage({super.key, required this.title});

  final String title;

  @override
  State<ClockHomePage> createState() => _ClockHomePageState();
}

class _ClockHomePageState extends State<ClockHomePage> {
  List<AlarmSettings> alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    print("loadAlarms実行");
    final updatedAlarms = AlarmManager.getAllAlarms().cast<AlarmSettings>();
    setState(() {
      alarms = updatedAlarms;
    });
  }


  void handleDelete(int id) async {
    await AlarmManager.cancelAlarm(id);
    setState(() {
      alarms.removeWhere((alarm) => alarm.id == id);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("アラーム一覧"),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                String time = "${alarm.dateTime.hour}:${alarm.dateTime.minute}";
                String date = "${alarm.dateTime.month}月${alarm.dateTime.day}日";
                return Stack(
                  children: [
                    SizedBox(
                      height: 80,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      ),
                    ),
                    Positioned.fill(
                      child: CornerWidget(
                        time: time,
                        date: date,
                        onEdit: () {},
                        onDelete: () => handleDelete(alarm.id),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(color: Colors.black);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          DateTime now = DateTime.now().add(const Duration(minutes: 1));
          await AlarmManager.setAlarm(now);
          _loadAlarms();
        },
      ),
    );
  }
}
