class QuizList {
  final int? id;
  final String title;

  QuizList({
    this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory QuizList.fromMap(Map<String, dynamic> map) {
    return QuizList(
      id: map['id'],
      title: map['title'],
    );
  }
}

class QuizData {
  final int? id;
  final int quizListId;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;

  QuizData({
    this.id,
    required this.quizListId,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quizListId': quizListId,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'answer': answer,
    };
  }

  factory QuizData.fromMap(Map<String, dynamic> map) {
    return QuizData(
      id: map['id'],
      quizListId: map['quizListId'],
      question: map['question'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['option3'],
      option4: map['option4'],
      answer: map['answer'],
    );
  }
}

