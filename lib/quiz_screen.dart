import 'package:flutter/material.dart';
import 'package:memorization_and_clock/result_screen.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, required this.quizMap, required this.isTest, required this.alarmId});
  final List<Map> quizMap;
  final bool isTest;
  final int alarmId;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Map> quizMap;
  int index = 0;
  int result = 0;
  bool isSelectNow = true;

  @override
  void initState() {
    quizMap = widget.quizMap;
    super.initState();
  }

  Future<void> updateQuiz(BuildContext context, int selectAnswer) async {
    setState(() {
      isSelectNow = false;
    });
    if (quizMap[index]["answer"] == selectAnswer) {
      result++;
    }

    await Future.delayed(const Duration(seconds: 1));
    isSelectNow = true;
    setState(() {});
    index++;
    if (index == quizMap.length) {
      await goToResult(context, widget.isTest, widget.alarmId);
    }
    setState(() {});
  }

  Future<void> goToResult(BuildContext context, bool isTest, int alarmId) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(result: result, quizMap: quizMap, isTest: isTest, alarmId: alarmId,)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0C3FC), Color(0xFF8EC5FC)], // グラデーションの色
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: index < quizMap.length
            ? CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3
                  ),
                ),
                Center(
                  child: Text(
                    quizMap[index]['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24, // フォントサイズ
                      fontWeight: FontWeight.bold, // 太字
                      color: Colors.white, // 文字色
                    ),
                  ),
                ),
                const SizedBox(height: 20), // 質問と選択肢の間にスペース
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, key) {
                  int useKey = key + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!isSelectNow) return;
                        await updateQuiz(context, useKey);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelectNow
                            ? Colors.white
                            : (quizMap[index]["answer"] == useKey
                            ? Colors.green
                            : Colors.red),
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        quizMap[index]["option$useKey"] +
                            (isSelectNow
                                ? ""
                                : quizMap[index]["answer"] == useKey
                                ? " ○"
                                : " ×"),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
                childCount: 4,
              ),
            ),
          ],
        )
            : Center(child: CircularProgressIndicator()), // クイズ終了時のローディング表示
      ),
    );
  }
}