/// This modal class creates an [AppUser] object, from the [User] response
/// following a successful Firebase Auth request by the auth service.
class AppUser {
  final String uid;
  final DateTime created;
  final String displayName;
  final String photoURL;

  AppUser({this.uid, this.created, this.displayName, this.photoURL});
}
