import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  TextEditingController stepsCtrl = TextEditingController();
  TextEditingController caloriesCtrl = TextEditingController();
  TextEditingController waterCtrl = TextEditingController();

  @override
  void dispose() {
    stepsCtrl.dispose();
    caloriesCtrl.dispose();
    waterCtrl.dispose();
    super.dispose();
  }

  void saveActivity() {
    int steps = int.tryParse(stepsCtrl.text.trim()) ?? 0;
    int calories = int.tryParse(caloriesCtrl.text.trim()) ?? 0;
    double water = double.tryParse(waterCtrl.text.trim()) ?? 0;

    if (steps == 0 && calories == 0 && water == 0) {
      Get.snackbar('Empty', 'Please enter at least one value');
      return;
    }

    ActivityController controller = Get.find<ActivityController>();
    controller.saveActivity(steps: steps, calories: calories, water: water);

    stepsCtrl.clear();
    caloriesCtrl.clear();
    waterCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find<ActivityController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Activity',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Each entry is saved with the current time',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),
          TextField(
            controller: stepsCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Steps',
              hintText: 'e.g. 8000',
              prefixIcon: Icon(Icons.directions_walk, color: Colors.orange),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: caloriesCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Calories (kcal)',
              hintText: 'e.g. 1800',
              prefixIcon: Icon(Icons.local_fire_department, color: Colors.red),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: waterCtrl,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Water (litres)',
              hintText: 'e.g. 2.5',
              prefixIcon: Icon(Icons.water_drop, color: Colors.blue),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 32),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Save Activity', style: TextStyle(fontSize: 16)),
                ),
              )),
        ],
      ),
    );
  }
}
