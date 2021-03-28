import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_rater/models/app_user_model.dart';

/// Service class to handle all interactions with Firebase Authentication
///
/// Handles Sign In, Sign Out, Regrestration and Decoding of the raw [User]
/// response from Firebase Auth
class AuthService {
  /// Instance of Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns an [AppUser] object if [User] in response from Firebase Auth
  AppUser _userFromFirebase(User user) {
    return user != null
        ? AppUser(
            uid: user.uid,
            created: user.metadata.creationTime,
            displayName: user.displayName,
            photoURL: user.photoURL)
        : null;
  }

  /// Listens for changes in the authentication status (Sign In / Sign Out) and
  /// returns the current authentication state as a stream of [AppUser]
  Stream<AppUser> get user {
    return _auth.authStateChanges().map((User u) => _userFromFirebase(u));
  }

  /// Returns the signed in [AppUser] if sign in is successful, otherwise
  /// null is returned
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      return null;
    }
  }

  /// Registers a user with a [username], [email] and [password] and returns an
  /// [AppUser] if registration is successful, otherwise returns null
  Future registerUser(String username, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _auth.currentUser.updateProfile(displayName: username);
      return _userFromFirebase(_auth.currentUser);
    } catch (e) {
      return null;
    }
  }

  /// Signs the user out, if successful the [AuthStateChanges] is modified
  Future signOut() async {
    return await _auth.signOut();
  }

  /// Updates the profile icon of the user as shown on the profile screen
  Future updateAvatar(String avatarIcon) async {
    try {
      await _auth.currentUser.updateProfile(photoURL: avatarIcon);
    } catch (e) {
      return null;
    }
  }

  /// Returns the [AppUser] that is currently signed in, else returns null
  AppUser getSignedInUser() {
    if (_auth.currentUser != null) {
      return _userFromFirebase(_auth.currentUser);
    } else {
      return null;
    }
  }
}
