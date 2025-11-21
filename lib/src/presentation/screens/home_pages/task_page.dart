import 'package:flutter/material.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/app_colors.dart';
import '/src/utils/consts/app_specifications/app_texts.dart';
import '/src/utils/consts/app_specifications/app_dimensions.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('gestion_documentaire Tasks'),
        backgroundColor: AppColors.mainAppColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, AppRoutesName.homePage),
            tooltip: 'Go to Home',
          ),
        ],
      ),
      body: Container(
        color: AppColors.mainBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Enter a new task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                        ),
                        filled: true,
                        fillColor: AppColors.mainBackgroundColorForCustomTextField,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLarge,
                        vertical: AppDimensions.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                    child: ListTile(
                      title: Text(
                        _tasks[index],
                        style:  TextStyle(color: AppColors.textMainPageColor),
                      ),
                      trailing: IconButton(
                        icon:  Icon(Icons.delete, color: AppColors.mainRedColor),
                        onPressed: () => _removeTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutesName.homePage),
        backgroundColor: AppColors.mainAppColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.home),
        tooltip: 'Navigate to Home',
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
} 