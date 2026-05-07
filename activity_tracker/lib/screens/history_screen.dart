import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import '../models/activity_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String getFormattedDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime dateOnly = DateTime(date.year, date.month, date.day);
    int diff = today.difference(dateOnly).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  String getFormattedTime(DateTime dt) {
    int hour = dt.hour == 0 ? 12 : dt.hour > 12 ? dt.hour - 12 : dt.hour;
    String minute = dt.minute.toString().padLeft(2, '0');
    String period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find<ActivityController>();

    return Obx(() {
      if (controller.isFetching.value && controller.history.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.history.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No history yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Start tracking your activities!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchHistory(),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.history.length,
          itemBuilder: (context, index) {
            ActivityModel item = controller.history[index];

            return Card(
              margin: EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${getFormattedDate(item.createdAt)}  •  ${getFormattedTime(item.createdAt)}',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.directions_walk, color: Colors.orange),
                            SizedBox(height: 4),
                            Text(
                              '${item.steps}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'steps',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.local_fire_department, color: Colors.red),
                            SizedBox(height: 4),
                            Text(
                              '${item.calories}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'kcal',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.water_drop, color: Colors.blue),
                            SizedBox(height: 4),
                            Text(
                              '${item.waterLiters} L',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'water',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
