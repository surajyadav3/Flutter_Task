import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  TextEditingController weightCtrl = TextEditingController();
  TextEditingController stepsTargetCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    ProfileController controller = Get.find<ProfileController>();
    await controller.fetchProfile();
    var profile = controller.profile.value;
    if (profile != null) {
      nameCtrl.text = profile.name;
      ageCtrl.text = profile.age > 0 ? '${profile.age}' : '';
      weightCtrl.text = profile.weight > 0 ? '${profile.weight}' : '';
      stepsTargetCtrl.text = profile.stepsTarget > 0 ? '${profile.stepsTarget}' : '';
    }
  }

  void saveProfile() {
    ProfileController controller = Get.find<ProfileController>();
    controller.saveProfile(
      name: nameCtrl.text.trim(),
      age: int.tryParse(ageCtrl.text.trim()) ?? 0,
      weight: double.tryParse(weightCtrl.text.trim()) ?? 0,
      stepsTarget: int.tryParse(stepsTargetCtrl.text.trim()) ?? 10000,
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    weightCtrl.dispose();
    stepsTargetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.find<ProfileController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Set your details and daily step target',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.indigo.shade100,
              child: Icon(Icons.person, size: 50, color: Colors.indigo),
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline, color: Colors.indigo),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: ageCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
              prefixIcon: Icon(Icons.cake_outlined, color: Colors.orange),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: weightCtrl,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              prefixIcon: Icon(Icons.monitor_weight_outlined, color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: stepsTargetCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Daily Steps Target',
              prefixIcon: Icon(Icons.directions_walk, color: Colors.purple),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 32),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Save Profile', style: TextStyle(fontSize: 16)),
                ),
              )),
        ],
      ),
    );
  }
}
