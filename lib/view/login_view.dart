
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Widget/Login_widget.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //these two late final are to use later and be inisalise before used
  //text controller is used for TextField
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    //implement initState it's the  first statae build when fluter bild your wedjet to init your widjet
    //inasilisation of the verible
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: loginWidget(_email, _password, context)
    );
  }
}
