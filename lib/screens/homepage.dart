import 'package:chat_app/bloc/bloc_event.dart';
import 'package:chat_app/bloc/bloc_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import '../bloc/bloc_main.dart';
import '../list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  static initializeApp() {}
}

class _HomePageState extends State<HomePage> {
  final AuthPage _bloc = AuthPage();
  final snap = FirebaseDatabase.instance.ref();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _countryCode = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  var topSize, containerSize;
  String check = 'email';
  String otp = 'otp';
  String code = "";
  String button = 'generateOtp';
  String verificationId='';

  @override
  void initState() {
    _countryCode.text = '+91';
    _bloc.add(MainPageEvent());
    super.initState();
  }

  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter mobile number');
      return false;
    } else if (!regExp.hasMatch(value)) {
      Fluttertoast.showToast(msg: 'Please enter valid mobile number');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    topSize = MediaQuery.of(context).size.height * 0.009;
    containerSize = MediaQuery.of(context).size.height * 0.805;
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      setState(() {
        containerSize = MediaQuery.of(context).size.height * 0.47;
        topSize = MediaQuery.of(context).size.height * 0.0099;
      });
    } else {
      setState(() {
        containerSize = MediaQuery.of(context).size.height * 0.805;
        topSize = MediaQuery.of(context).size.height * 0.009;
      });
    }

    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      body: Container(
          child: BlocProvider(
        create: (_) => _bloc,
        child: BlocBuilder<AuthPage, ChatState>(builder: (context, state) {
          if (state is MainPageState) {
            return _mainPage(context);
          } else if (state is InitialState) {
            return _loginForm(context,'');
          } else if (state is LogOutState) {
            return _loginForm(context,'');
          } else if (state is FirstPageState) {
            return _firstPage(context);
          } else if (state is OtpState) {

            // setState((){
            //   verificationId=state.verificationId;
            //   otp = 'getOtp';
            //
            // });
            return _loginForm(context,state.verificationId);
          } else {
            return _loadingState(context);
          }
        }),
      )),
    );
  }

  //**********************NEXT PAGE AFTER LOGIN SUCCESSFUL*******************

  Widget _mainPage(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: const Text(
            "List View",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Colors.lightBlue.shade300,
          actions: [
            OutlinedButton(
                onPressed: () {
                  _bloc.add(FirstPageEvent());
                },
                child: const Icon(
                  Icons.chat_rounded,
                  color: Colors.black87,
                ))
          ],
        ),
        body: Column());
  }

  Widget _firstPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text(
          "Chat App",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.lightBlue.shade300,
        actions: [
          BackButton(
            onPressed: () {
              _bloc.add(MainPageEvent());
            },
          ),
          OutlinedButton(
              onPressed: () {
                _bloc.add(LogOutEvent());
              },
              child: const Icon(Icons.logout, color: Colors.black87)),
        ],
      ),
      body: Column(
        children: [
          Lists.sentMessage.isNotEmpty
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: containerSize,
                  color: Colors.transparent,
                  child: ListView.builder(
                      itemCount: Lists.sentMessage.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                            top: MediaQuery.of(context).size.height * 0.02,
                          ),
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            Lists.sentMessage[index],
                            style: const TextStyle(
                                fontSize: 24, fontStyle: FontStyle.italic),
                            textDirection: TextDirection.rtl,
                          ),
                        );
                      }),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: containerSize,
                  color: Colors.green,
                  child: const Center(
                      child: Text(
                    "Welcome",
                    style: TextStyle(fontSize: 30),
                  ))),
          SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.2,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: topSize),
              child: TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2)),
                  hintStyle: const TextStyle(color: Colors.green),
                  hintText: "Enter Message",
                  labelText: "Message",
                  labelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              Lists.sentMessage.add(_messageController.text);
            });
          },
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  //******************LOGIN PAGE BUTTON AND FIELD*************************

  Widget _loginForm(BuildContext context,String id) {
    print(id);
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/download.png'),
                  fit: BoxFit.fill,
                ),
                border: Border.all(color: Colors.blue.shade100, width: 4),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    offset: const Offset(
                      8.0,
                      8.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
          (check == 'email') ? _emailPassword() : _phoneNumber(),
          // _signUpButton(),
          (check == 'email') ? _buttons() : _otpButton(id),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                if (check == 'email') {
                  setState(() {
                    check = 'phone';
                  });
                } else {
                  setState(() {
                    check = 'email';
                  });
                }
              },
              child: Text(
                (check == 'email')
                    ? 'Login with Phone Number'
                    : 'Login with Email',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _emailPassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.mail_rounded),
              hintText: "Email Address",
              labelText: "Email",
              labelStyle:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              icon: Icon(Icons.remove_red_eye_rounded),
              hintText: "Password",
              labelText: "Password",
              labelStyle:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _passwordField() {
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: TextFormField(
  //       controller: _passwordController,
  //       decoration: const InputDecoration(
  //         icon: Icon(Icons.remove_red_eye_rounded),
  //         hintText: "Password",
  //         labelText: "Password",
  //         labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
  //         border: OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //       ),
  //     ),
  //   );
  // }

  Widget _phoneNumber() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: (otp == 'otp')
          ? Row(
              children: [
                Container(
                  width: 40,
                  margin: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: _countryCode,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const Text(
                  "|",
                  style: TextStyle(fontSize: 40, color: Colors.grey),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  margin: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: _phone,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                        counterText: ""),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Pinput(
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {

                      code = value;

                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      otp = 'otp';
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.55,
                      top: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: const Text(
                      "Change Phone Number",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  // Widget _signUpButton() {
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: ElevatedButton(
  //         onPressed: () {
  //           _bloc.add(SignUpButtonEvent(
  //             email: _emailController.text,
  //             password: _passwordController.text,
  //           ));
  //         },
  //         child: const Text(
  //           "Sign Up",
  //           style: TextStyle(color: Colors.black87),
  //         )),
  //   );
  // }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () {
              _bloc.add(LoginButtonEvent(
                  email: _emailController.text,
                  password: _passwordController.text));
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.black87),
            )),
        ElevatedButton(
            onPressed: () {
              _bloc.add(SignUpButtonEvent(
                email: _emailController.text,
                password: _passwordController.text,
              ));
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.black87),
            )),
      ],
    );
  }

  Widget _otpButton(String id) {
    return ElevatedButton(
      onPressed: () async {

        if(otp=='otp'){
          bool isValid = validateMobile(_countryCode.text + _phone.text);
          if (isValid) {
            setState(() {
              otp = 'getOtp';
            });
            _bloc.add(OtpEvent(
                phoneNumber: _phone.text, countryCode: _countryCode.text));
          }
        }
        else{
          if(code==''){
            Fluttertoast.showToast(msg: 'Enter Otp');
          }else{
            _bloc.add(OtpVerification(verificationId: id, smsCode: code));
          }
        }
      },
      child: Text(
        (otp == 'otp') ? "Generate Otp" : "Submit",
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
