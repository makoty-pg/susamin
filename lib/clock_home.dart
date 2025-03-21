import 'package:flutter/material.dart';
import 'package:memorization_and_clock/alarm_setting.dart';

class CornerWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CornerWidget({Key? key, required this.onEdit, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 10,
          left: 10,
          child: Text('6:00', style: TextStyle(fontSize: 18)),
        ),
        const Positioned(
          bottom: 10,
          left: 10,
          child: Text('3月3日(月)', style: TextStyle(fontSize: 18)),
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

class ClockHome extends StatelessWidget {
  const ClockHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ClockHomePage(title: 'メモクロ'),

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
  final items = ["AAA", "BBB", "CCC", "DDD", "EEE", "FFF", "GGG", "HHH", "III", "JJJ", "KKK", "LLL", "MMM", "NNN"];

  void handleEdit(String item) {
    print("編集: $item");
  }

  void handleDelete(String item) {
    print("削除: $item");
    setState(() {
      items.remove(item);
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
            const Text("Flutterスクロールサンプル"),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Stack(
                  children: [
                    SizedBox(
                      height: 80,
                      child: ListTile(
                        title: null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      ),
                    ),
                    Positioned.fill(
                      child: CornerWidget(
                        onEdit: () => handleEdit(item),
                        onDelete: () => handleDelete(item),
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
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlarmSetting()),
          );
        },
      ),
    );
  }
}