

import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  late FirebaseAuth auth;

  AuthService({required this.auth});

  Stream<User?> get user => auth.authStateChanges();

  // Todo: Sign Up With Email and Password
  Future<String?> signUpWithEmailAndPassword(String email, String password) async {
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signOut() async {
    try{
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  // Todo: Sign In With Email and Password
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch(e) {
      rethrow;
    }
  }

}