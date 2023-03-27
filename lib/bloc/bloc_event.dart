abstract class ChatEvent {}

class MainPageEvent extends ChatEvent{
  MainPageEvent();
}
class SignUpButtonEvent extends ChatEvent {
  String email;
  //String spilted;
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
class FirstPageEvent extends ChatEvent{
  FirstPageEvent();
}