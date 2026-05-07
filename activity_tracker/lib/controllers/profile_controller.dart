import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;

  final AuthController _authController = Get.find<AuthController>();

  String get _userId => _authController.userId;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final doc = await _db.collection('profiles').doc(_userId).get();
      if (doc.exists) {
        profile.value = ProfileModel.fromMap(doc.data()!);
      }
    } catch (_) {}
  }

  Future<void> saveProfile({
    required String name,
    required int age,
    required double weight,
    required int stepsTarget,
  }) async {
    try {
      isLoading.value = true;
      final p = ProfileModel(
        userId: _userId,
        name: name,
        age: age,
        weight: weight,
        stepsTarget: stepsTarget,
      );
      await _db.collection('profiles').doc(_userId).set(p.toMap());
      profile.value = p;
      Get.snackbar('Saved', 'Profile updated!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile');
    } finally {
      isLoading.value = false;
    }
  }

  int get stepsTarget => profile.value?.stepsTarget ?? 10000;
  String get userName => profile.value?.name ?? '';
}
