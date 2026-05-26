part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  String errMessage;
  LoginFailure({required this.errMessage});
}
 class RegisterLoading extends AuthState {}

 class RegisterSuccess extends AuthState {}

 class RegisterFailure extends AuthState {
  String errMessage ;
  RegisterFailure ({required this.errMessage});
 }
