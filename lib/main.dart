import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:prac/Home/home_screen.dart';



void main() {
  return runApp(Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'ComicNeue',
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.yellow,
          color: Colors.red,
          elevation: 5,
          shadowColor: Colors.yellow,
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
          titleSmall: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
      routes: {
        HomeScreen.routeName : (ctx) => HomeScreen(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final url = "https://prod.gcf.education/auth/v1/ekidz/login/";
  final admissionNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool loginSuccessText = false;
  String message = '';
  bool isSelected = false;

  void toggleImage() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  Future<void> checkCredentials() async{

    if (admissionNumberController.text.isEmpty == true ||
        passwordController.text.isEmpty == true|| isSelected == false) {
      setState(() {
        message = "fill all the fields";
      });
      return;
    }
    var bytes = utf8.encode(passwordController.text);
    var md5hash = md5.convert(bytes);
    var passwordMd5 = md5hash.toString().toLowerCase();


    final response = await http.post(Uri.parse(url), body: {
      'username' :  admissionNumberController.text,
      'password' : passwordMd5,
    });
    print(admissionNumberController.text);
    print(passwordController.text);

      if(response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if(responseBody['data'].isEmpty == true) {
          setState(() {
            message = responseBody['message'];
            print(responseBody);
          });
        } else {
          // setState(() {
          //   message = "loginSuccess";
          // });
          setState(() {
            message = '';
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          });

        }

      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [

                Image(
                  image: AssetImage("assets/images/login_banner.png"),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 250,
                ),
                Positioned(
                  top: 35,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 50,
                        width: 180,
                      ),
                      Text(
                        "Welcome to nLearn Kids",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Container(
                        width: 220,
                        child: Text(
                          'Use login details shared to your '
                          'registered phone number',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Container(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Admission Number',
                      ),
                      controller: admissionNumberController,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Enter Password'),
                      controller: passwordController,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: toggleImage,
                            icon: Image.asset(
                              isSelected
                                  ? 'assets/images/checkBoxSelected.png'
                                  : 'assets/images/checkBox.png',
                              height: 25,
                              width: 25,
                            )),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'By Proceeding ,you are automatically accepting to',
                              style: Theme.of(context).textTheme.titleSmall,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'T&C and  Privacy policy',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: checkCredentials,
                        child: Padding(
                            padding: EdgeInsets.all(10), child: Text('Login')),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Text(message, style: TextStyle(color: Colors.red),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
