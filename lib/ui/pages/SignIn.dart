import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/userEntity.dart';
import '../constant.dart';
import '../widget/LoginSignupButton.dart';

class userRegister extends StatefulWidget {
  const userRegister({Key? key}) : super(key: key);

  @override
  State<userRegister> createState() => _userRegisterState();
}

class _userRegisterState extends State<userRegister> {
  final formkey = GlobalKey<FormState>();
  String name = '';
  String lastName  ='';
  String phoneNumber ='';
  String mail ='';
  String birthday='';
  String adresse ='';
  bool isloading = false;
  late UserDatabase database;

  Future<int> addUsers(UserDatabase db , String nom ,String lastName,String phoneNumber , String email ,String  birthday , String adresse) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    User firstUser = User( name: nom, surName : lastName, phoneNumber : phoneNumber , email : email , birthday :birthday , adresse: adresse, username: '', password: '' );
    return await db.userDAO.inserUser(firstUser);
  }

  @override
  void initState() {
    super.initState();
    $FloorUserDatabase
        .databaseBuilder('user_database.db')
        .build()
        .then((value) async {
      this.database = value;

      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,size: 30,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isloading
          ? Center(
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
                  EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: '1',
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          mail = value.toString().trim();
                        },
                        validator: (value) => (value!.isEmpty)
                            ? ' Please enter email'
                            : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                        ),
                      ),


                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          name = value.toString().trim();
                        },
                        validator: (value) => (value!.isEmpty)
                            ? ' Please enter name'
                            : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Name',
                          prefixIcon: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          lastName= value.toString().trim();
                        },
                        validator: (value) => (value!.isEmpty)
                            ? ' Please enter last name'
                            : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Last Name',
                          prefixIcon: Icon(
                            Icons.supervised_user_circle_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phoneNumber = value.toString().trim();
                        },
                        validator: (value) => (value!.isEmpty)
                            ? ' Please enter phone Number'
                            : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Phone Number',
                          prefixIcon: Icon(
                            Icons.add_call,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          phoneNumber = value.toString().trim();
                        },
                        validator: (value) => (value!.isEmpty)
                            ? ' Please enter phone birthday'
                            : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Phone birthday',
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        onChanged: (value) {
                          phoneNumber = value.toString().trim();
                        },
                        validator: (value) => (value!.isEmpty)
                            ? ' Please enter adresse'
                            : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your adresse',
                          prefixIcon: Icon(
                            Icons.add_location_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                      LoginSignupButton(
                        title: 'Register',
                        ontapp: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });

                              await this.addUsers(database , name , lastName , mail , phoneNumber,birthday,adresse );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.blueGrey,
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(

                                        'Sucessfully Register.You Can Login Now'),
                                  ),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            Navigator.pushNamed(context , '/users');
                              setState(() {
                                isloading = false;
                              });

                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                      ),
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

