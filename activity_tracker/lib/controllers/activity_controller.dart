import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/activity_model.dart';
import 'auth_controller.dart';

class ActivityController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxList<ActivityModel> history = <ActivityModel>[].obs;

  // Running totals for today, summed across all entries.
  final RxInt todaySteps = 0.obs;
  final RxInt todayCalories = 0.obs;
  final RxDouble todayWater = 0.0.obs;

  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  String get _userId => _authController.userId;

  bool get hasTodayData =>
      todaySteps.value > 0 || todayCalories.value > 0 || todayWater.value > 0;

  Future<void> saveActivity({
    required int steps,
    required double water,
    required int calories,
  }) async {
    try {
      isLoading.value = true;
      final activity = ActivityModel(
        userId: _userId,
        steps: steps,
        waterLiters: water,
        calories: calories,
        createdAt: DateTime.now(),
      );
      final doc = await _db.collection('activities').add(activity.toMap());
      activity.id = doc.id;

      // Optimistically updating the todays dashboard :)
      todaySteps.value += steps;
      todayCalories.value += calories;
      todayWater.value += water;

      Get.snackbar('Saved', 'Activity logged!');
      await fetchHistory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save activity: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHistory() async {
    try {
      isFetching.value = true;
      final snapshot = await _db
          .collection('activities')
          .where('userId', isEqualTo: _userId)
          .get();

      final list = snapshot.docs
          .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      history.value = list;

      // Recompute and recalcutate the todays total data for firebase :
      final now = DateTime.now();
      final todayList = list.where((a) =>
          a.createdAt.year == now.year &&
          a.createdAt.month == now.month &&
          a.createdAt.day == now.day).toList();

      todaySteps.value    = todayList.fold(0,   (s, a) => s + a.steps);
      todayCalories.value = todayList.fold(0,   (s, a) => s + a.calories);
      todayWater.value    = todayList.fold(0.0, (s, a) => s + a.waterLiters);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load history: $e');
    } finally {
      isFetching.value = false;
    }
  }
}
