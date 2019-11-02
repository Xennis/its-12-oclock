import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static FirebaseUser fbUser;

  static Future<FirebaseUser> _signInWithGoogle(
      GoogleSignInAccount account) async {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user;
  }

  static Future<FirebaseUser> getSignedInUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    assert(user != null);
    fbUser = user;
    return user;
  }

  static Future<FirebaseUser> signIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final FirebaseUser user = await _signInWithGoogle(googleSignInAccount);

    assert(user != null);
    assert(!user.isAnonymous);
    assert(user.displayName != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    fbUser = user;
    return user;
  }

  static void signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
