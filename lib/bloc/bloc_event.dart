import 'package:chat_app/bloc/bloc_state.dart';

abstract class ChatEvent {}

class MainPageEvent extends ChatEvent{
  MainPageEvent();
}
class SignUpButtonEvent extends ChatEvent {
  String email;
  String password;

  SignUpButtonEvent({required this.email, required this.password,});
}
class LoginButtonEvent extends ChatEvent{
  String email;
  String password;

  LoginButtonEvent({required this.email,required this.password});
}
class LogOutEvent extends ChatEvent{
  LogOutEvent();
}
class OtpEvent extends ChatEvent{
  String phoneNumber;
  String countryCode;
  OtpEvent({required this.phoneNumber,required this.countryCode});
}
class OtpVerification extends ChatEvent{
  String verificationId;
  String smsCode;
  OtpVerification({required this.verificationId,required this.smsCode});
}
class FirstPageEvent extends ChatEvent{
  FirstPageEvent();
}