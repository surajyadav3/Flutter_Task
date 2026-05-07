import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/activity_controller.dart';
import '../controllers/profile_controller.dart';
import 'tracking_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.delete<ActivityController>(force: true);
    Get.delete<ProfileController>(force: true);
    Get.put(ActivityController());
    Get.put(ProfileController());
  }

  @override
  void dispose() {
    Get.delete<ActivityController>(force: true);
    Get.delete<ProfileController>(force: true);
    super.dispose();
  }

  Widget _buildDashboard() {
    ActivityController ac = Get.find<ActivityController>();
    ProfileController pc = Get.find<ProfileController>();

    return Obx(() {
      return Column(
        children: [
          // greeting header
          Container(
            width: double.infinity,
            color: Colors.indigo,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${pc.userName.isNotEmpty ? pc.userName : "there"}!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  ac.hasTodayData
                      ? 'Here is your activity for today'
                      : 'No activity logged today',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // metric cards
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: _metricCard(
                      icon: Icons.directions_walk,
                      label: 'Steps',
                      value: '${ac.todaySteps.value}',
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: _metricCard(
                      icon: Icons.local_fire_department,
                      label: 'Calories',
                      value: '${ac.todayCalories.value} kcal',
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: _metricCard(
                      icon: Icons.water_drop,
                      label: 'Water',
                      value: '${ac.todayWater.value.toStringAsFixed(1)} L',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildDashboard(),
      TrackingScreen(),
      HistoryScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Tracker'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
