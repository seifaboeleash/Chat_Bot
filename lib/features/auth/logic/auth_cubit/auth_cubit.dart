import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.auth) : super(AuthInitial());
  final FirebaseAuth auth ;
  // Login
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      print('Firebase Error Code: ${e.code}');
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errMessage: 'Wrong password provided.'));
      } else if (e.code == 'invalid-credential') {
        emit(LoginFailure(errMessage: 'Email or password is incorrect.'));
      } else {
        emit(LoginFailure(errMessage: e.message ?? 'Authentication error'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Unexpected error occurred'));
    }
  }

  // Register
  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      emit(RegisterLoading());
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(RegisterFailure(errMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(RegisterFailure(errMessage: 'Wrong password provided.'));
      } else if (e.code == 'invalid-credential') {
        emit(RegisterFailure(errMessage: 'Email or password is incorrect.'));
      }else if (e.code == 'email-already-in-use') { 
    emit(RegisterFailure(errMessage: 'Email already in use.'));
  } else {
        emit(RegisterFailure(errMessage: e.message ?? 'Authentication error'));
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: 'Unexpected error occurred'));
    }
  }

  // Logout
  Future<void> logout() async {
    await auth.signOut();
  }
}
