import 'package:chat_app/bloc/bloc_event.dart';
import 'package:chat_app/bloc/bloc_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc_main.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    _bloc.add(MainPageEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      body: Container(
          child: BlocProvider(
        create: (_) => _bloc,
        child: BlocBuilder<AuthPage, ChatState>(builder: (context, state) {
          if (state is MainPageState) {
            return _mainPage(context);
          } else if (state is InitialState) {
            return _loginForm(context);
          } else if (state is LogOutState) {
            return _loginForm(context);
          } else if (state is FirstPageState) {
            return _firstPage(context);
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
    );
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
          OutlinedButton(
              onPressed: () {
                _bloc.add(LogOutEvent());
              },
              child: const Icon(Icons.logout, color: Colors.black87))
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.amber,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.5),
            width: MediaQuery.of(context).size.width*0.85,
           height: MediaQuery.of(context).size.height*0.1,
            child: Row(
              children: [
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),borderSide:BorderSide(color: Colors.blueAccent,width: 2)
                    ),
                    hintStyle: const TextStyle(color: Colors.green),
                    hintText: "Enter Message",
                    labelText: "Message",
                    labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
                IconButton(
                    onPressed:(){

                    }, icon: Icon(Icons.send_outlined))
              ],
            ),
          ),

        ],
      ),

    );
  }

  //******************LOGIN PAGE BUTTON AND FIELD*************************

  Widget _loginForm(BuildContext context) {
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
          _emailField(),
          _passwordField(),
          _signUpButton(),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          icon: Icon(Icons.mail_rounded),
          hintText: "Email Address",
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _passwordController,
        decoration: const InputDecoration(
          icon: Icon(Icons.remove_red_eye_rounded),
          hintText: "Password",
          labelText: "Password",
          labelStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
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
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
        onPressed: () {
          _bloc.add(LoginButtonEvent(
              email: _emailController.text,
              password: _passwordController.text));
        },
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.black87),
        ));
  }

  Widget _loadingState(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
