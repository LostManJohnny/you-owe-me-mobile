// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_owe_us/services/user_profile_service.dart';
import '../domain/auth/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth;
  final UserProfileService userProfileService;

  AuthService(this.userProfileService, {FirebaseAuth? firebaseAuth}) : _auth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserProfile?> signIn({
    required String email,
    required String password,
  }) async {
    var creds = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (creds.user == null) {
      throw Exception("Failed to retrieve profile from authentication server");
    }
    var profile = await userProfileService.getUserProfileByUID(creds.user!.uid);
    return profile;
  }

  Future<UserProfile> signUp({
    required String email,
    required String password,
    required UserProfile userProfile,
  }) async {
    final creds = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    userProfile = userProfile.copyWith(authKey: creds.user?.uid);
    userProfileService.saveUserProfile(userProfile);
    return userProfile;
  }

  Future<void> sendPasswordResetEmail({required String email}) => _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() => _auth.signOut();
}
