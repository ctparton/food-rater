/// This class creates an AppUser object, from the [User] response following a
/// Firebase Auth request
class AppUser {
  final String uid;
  final DateTime created;
  final String displayName;

  AppUser({this.uid, this.created, this.displayName});
}
