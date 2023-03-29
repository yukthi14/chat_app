abstract class ChatState {}

class InitialState extends ChatState {
  InitialState();
}

class MainPageState extends ChatState {
  MainPageState();
}

class LogOutState extends ChatState {
  LogOutState();
}
class OtpState extends ChatState{
  String verificationId;
  OtpState({required this.verificationId});
}
class FirstPageState extends ChatState {
  FirstPageState();
}
