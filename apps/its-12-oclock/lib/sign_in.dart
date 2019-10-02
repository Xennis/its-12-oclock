import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

FirebaseUser fbUser;

Future<bool> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  fbUser = (await _auth.signInWithCredential(credential)).user;

  assert(fbUser.displayName != null);

  assert(!fbUser.isAnonymous);
  assert(await fbUser.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(fbUser.uid == currentUser.uid);

  return true;
}

void signOutGoogle() async{
  await googleSignIn.signOut();
}

