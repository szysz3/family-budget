import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static final Auth _instance = Auth._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Auth._();

  factory Auth() {
    return _instance;
  }

  Future<SignInResult> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    return await _signInWithCredentials(authCredential);
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<bool> isSignedIn() async {
    var currentUser = await _auth.currentUser();
    return currentUser != null;
  }

  Future<SignInResult> getSignedInUser() async {
    FirebaseUser signedAccount = await _auth.currentUser();
    return SignInResult(
        signedAccount.displayName, signedAccount.email, signedAccount.photoUrl);
  }

  Future<SignInResult> _signInWithCredentials(
      final AuthCredential credentials) async {
    final AuthResult authResult = await _auth.signInWithCredential(credentials);
    final FirebaseUser user = authResult.user;

    return SignInResult(user.displayName, user.email, user.photoUrl);
  }
}

class SignInResult {
  final name;
  final email;
  final imageUrl;

  const SignInResult(this.name, this.email, this.imageUrl);
}
