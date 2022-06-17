import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_project/ui/pages/SignIn.dart';
import '../../data/userEntity.dart';


import '../../DataBase/user_database.dart';
import '../constant.dart';
import '../widget/LoginSignupButton.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {

  late UserDatabase database;
  User? user ;

  Future<bool> checklogin(String email , String password) async {

    List<User>  users = await database.userDAO.finduserByemail(email.toString());

    debugPrint(users.length.toString());

    if (users.isNotEmpty ){
      user=users.first;
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    $FloorUserDatabase
        .databaseBuilder('user_database.db')
        .build()
        .then((value) async {
      database = value;

      setState(() {});
    });
  }
  final formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Form(
        key: formkey,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Email";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Password";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            )),
                      ),
                      const SizedBox(height: 80),
                      LoginSignupButton(
                        title: 'Login',
                        ontapp: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            if( await checklogin(email,password)){
                               await   Navigator.pushNamed(context , '/home',arguments: {"user" : user });

                               setState(() {
                                 isloading = false;
                               });
                             }else {
                               await Navigator.of(context).push(
                                 MaterialPageRoute(
                                   builder: (contex) =>const userRegister(),
                                 ),
                               );
                             }

                             /*on FirebaseAuthException catch (e) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Ops! Login Failed"),
                                  content: Text('${e.message}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text('Okay'),
                                    )
                                  ],
                                ),
                              );
                              print(e);
                            }*/
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>const userRegister(),
                            ),
                          );
                        },
                        child: Row(
                          children: const [
                            Text(
                              "Don't have an Account ?",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black87),
                            ),
                            SizedBox(width: 10),
                            Hero(
                              tag: '1',
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
