import 'package:chat_app/bloc/bloc_event.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc_state.dart';

class AuthPage extends Bloc<ChatEvent, ChatState> {
  AuthPage() : super(InitialState()) {
    final snap = FirebaseDatabase.instance.ref();

    on<LoginButtonEvent>((event, emit) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final FirebaseAuth auth = FirebaseAuth.instance;

      String email = event.email;

      final bool isVaild = EmailValidator.validate(email);
      if (isVaild) {
        try {
          final UserCredential credential =
              await auth.signInWithEmailAndPassword(
                  email: event.email, password: event.password);
          var user = credential.user;
          if (user != null) {
            pref.setString("uid", user.uid);
            emit(MainPageState());
          }
        } on FirebaseAuthException catch (e) {
          Fluttertoast.showToast(msg: e.code);
        }
      }
    });

    on<MainPageEvent>((event, emit) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.getString("uid") != null) {
        emit(MainPageState());
      } else {
        emit(LogOutState());
      }
    });

    on<FirstPageEvent>((event, emit) async {
      emit(FirstPageState());
    });

    on<SignUpButtonEvent>((event, emit) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final FirebaseAuth auth = FirebaseAuth.instance;
      String email = event.email;

      final bool isValid = EmailValidator.validate(email);
      if (isValid) {
        try {
          final UserCredential credential =
              await auth.createUserWithEmailAndPassword(
                  email: event.email, password: event.password);
          var user = credential.user;
          if (user != null) {
            pref.setString("uid", user.uid);
            String? userEmail = user.email;
            List userId = userEmail!.split('@');
            snap
                .child(userId.first)
                .set({"email": event.email, "password": event.password});
            Fluttertoast.showToast(msg: "You have logged in successfully");
            emit(MainPageState());
          }
        } on FirebaseAuthException catch (e) {
          throw Exception(e.code);
        }
      } else {
        Fluttertoast.showToast(msg: "invalid");
      }
    });

    on<LogOutEvent>((event, emit) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final FirebaseAuth auth = FirebaseAuth.instance;

      pref.remove("uid");
      auth.signOut();
      emit(LogOutState());
    });
    // on<FirstPageEvent>((event,emit){
    //
    // });
    on<OtpEvent>((event, emit) async {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: event.countryCode + event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: "Something went Wronge");
        },
        codeSent: (String verificationId, int? resendToken) {
          Fluttertoast.showToast(msg: 'Otp Sent');

          emit(OtpState(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    });

    on<OtpVerification>((event, emit) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final FirebaseAuth auth = FirebaseAuth.instance;
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.verificationId, smsCode: event.smsCode);
        var user=await auth.signInWithCredential(credential);
        var token = user.user;
        if(token!=null){
          pref.setString('uid', token.uid);
          Fluttertoast.showToast(msg: 'Login Successful');
          emit(MainPageState());
        }
      } catch (e) {
        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
        print(e.toString());
        Fluttertoast.showToast(msg: "Wrong Otp");
      }
    });
  }
}
