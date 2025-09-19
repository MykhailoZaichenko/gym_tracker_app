import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseName;
  final List<Map<String, dynamic>> sets; // [{reps: 10, weight: 20}, ...]

  final Function(List<Map<String, dynamic>>) onSave;

  ExerciseDetailScreen({
    required this.exerciseName,
    required this.sets,
    required this.onSave,
  });

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late List<Map<String, dynamic>> _sets;

  @override
  void initState() {
    super.initState();
    _sets = List.from(widget.sets);
  }

  void _addSet() {
    final repsController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Новий підхід"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Повтори / Повторения"),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Вага / Вес (кг)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Скасувати / Отмена"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Додати / Добавить"),
            onPressed: () {
              setState(() {
                _sets.add({
                  "reps": int.tryParse(repsController.text) ?? 0,
                  "weight": double.tryParse(weightController.text) ?? 0,
                });
              });
              widget.onSave(_sets);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _removeSet(int index) {
    setState(() {
      _sets.removeAt(index);
    });
    widget.onSave(_sets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.exerciseName)),
      body: ListView.builder(
        itemCount: _sets.length,
        itemBuilder: (context, index) {
          final set = _sets[index];
          return ListTile(
            title: Text("Підхід ${index + 1} / Подход ${index + 1}"),
            subtitle: Text(
              "Повтори: ${set['reps']} | Вага: ${set['weight']} кг",
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeSet(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSet,
        child: Icon(Icons.add),
      ),
    );
  }
}
