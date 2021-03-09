import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_rater/models/app_user_model.dart';

class AuthService {
  // sign in with email and password

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFirebase(User user) {
    return user != null
        ? AppUser(
            uid: user.uid,
            created: user.metadata.creationTime,
            displayName: user.displayName)
        : null;
  }

  Stream<AppUser> get user {
    return _auth.authStateChanges().map((User u) => _userFromFirebase(u));
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerUser(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _auth.currentUser.updateProfile(displayName: username);
      return _userFromFirebase(_auth.currentUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}
