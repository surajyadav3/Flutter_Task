import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import 'activity_controller.dart';
import 'profile_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill the all fields');
      return;
    }
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    try {
      isLoading.value = true;
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // every user get a empty profile when he/she logged in ;
      // used the uid to keep data seperate like user connected to there own data in db;
      await _db.collection('profiles').doc(credential.user!.uid).set({
        'userId': credential.user!.uid,
        'name': '',
        'age': 0,
        'weight': 0.0,
        'stepsTarget': 10000,
      });
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Register Failed', e.message ?? 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // Explicitly remove user-scoped controllers so the next person who
    // logs in and get a fresh table to set data;
    Get.delete<ActivityController>(force: true);
    Get.delete<ProfileController>(force: true);
    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }

  String get userId => _auth.currentUser?.uid ?? '';
}
