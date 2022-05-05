import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_project/ui/pages/DashbordScreen.dart';

import '../../DataBase/user_database.dart';
import '../../data/userEntity.dart';
import '../../tesla_app/screens/base_screen.dart';
import '../Constants.dart';
import 'Home-Page.dart';
import 'custom_route.dart';
import 'package:hexcolor/hexcolor.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<int> addUsers(UserDatabase db , SignupData user) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    String surname ="" ;
    String username ="";
    String phoneNumber ="";
    String name ="";

    if(user != null){
      user.additionalSignupData?.forEach((key, value) {

         if (key == "Surname"){
           surname = value;
         }
         if (key == "Username"){
           username = value;
         }
         if (key == "phone_number"){
            phoneNumber =value;
         }
         if (key == "Name"){
            name=value;
         }

      });

    }
    User firstUser = User( name: name ,  surName : surname, phoneNumber : phoneNumber ,
        email : user.name.toString() , birthday :"" , adresse: "", username:username, password: user.password.toString() );
    debugPrint(firstUser.name + firstUser.phoneNumber);

    return await db.userDAO.inserUser(firstUser);
  }

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  static const routeName = '/log';
  late UserDatabase database;
  late User user ;

  @override
  void initState() {
    super.initState();

      setState(() {
        $FloorUserDatabase
            .databaseBuilder('user_database.db')
            .build()
            .then((value) async {
          this.database = value;
          //this.addUsers(this.database);

        });
  });
  }

  List<User>  users =[];
  List<User> userss =[];

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
       users = await database.userDAO.finduserByemail(data.name.toString());
       userss = await database.userDAO.finduserBypassword(data.password.toString());

       debugPrint("user succ" + users.length.toString());
      if (users.length<=0) {
        return 'User not exists';
      }

      if (userss.length <=0 ) {
        return 'Password does not match';
      }

      if(users != null) {
        user = users.first;
        debugPrint("first user " + user.name.toString());
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('user register   ${data.additionalSignupData}');

    return Future.delayed(loginTime).then((_) async {
      int id = await this.addUsers(this.database, data) ;
      debugPrint("id user " + id.toString());
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) async {
    List<User>  users = await database.userDAO.finduserBypassword(name);

    return Future.delayed(loginTime).then((_) {
      if (users.length < 0) {
        return 'User not exists';
      }
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
   // final theme = Theme.of(context);
    ThemeData theme = Theme.of(context);

    return
      FlutterLogin(
        //logo2: const AssetImage('assets/image/logo2.png'),
        logo:const AssetImage('assets/image/logo.png'),
      //title: "gg",
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: _signupConfirm,
      onConfirmSignup: _signupConfirm,
      loginAfterSignUp: false,

      theme: LoginTheme(
          primaryColor: HexColor("#175989"),

          //accentColor: Colors. // bako
          /* cardTheme: new CardTheme(
             //color: Colors.indigo.shade200
           ),
*/
      ),
         loginProviders: [
       /* LoginProvider(
          button: Buttons.LinkedIn,
          label: 'Sign in with LinkedIn',
          callback: () async {
            return null;
          },
          providerNeedsSignUpCallback: () {
            // put here your logic to conditionally show the additional fields
            return Future.value(true);
          },
        ),*/
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            return null;
          },
        ),
        /*LoginProvider(
          icon: FontAwesomeIcons.githubAlt,
          callback: () async {
            debugPrint('start github sign in');
            await Future.delayed(loginTime);
            debugPrint('stop github sign in');
            return null;
          },
        ),*/
      ],
      termsOfService: [
        TermOfService(
            id: 'newsletter',
            mandatory: false,
            text: 'Newsletter subscription'),
        TermOfService(
            id: 'general-term',
            mandatory: true,
            text: 'Term of services',
            linkUrl: 'https://github.com/NearHuscarl/flutter_login'),
      ],
      additionalSignupFields: [
        const UserFormField(
            keyName: 'Username', icon: Icon(FontAwesomeIcons.userAlt)),
        const UserFormField(keyName: 'Name'),
        const UserFormField(keyName: 'Surname'),
        UserFormField(
          keyName: 'phone_number',
          displayName: 'Phone Number',
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            var phoneRegExp = RegExp(
                '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$');
            if (value != null &&
                value.length < 7 &&
                !phoneRegExp.hasMatch(value)) {
              return "This isn't a valid phone number";
            }
            return null;
          },
        ),
      ],
      initialAuthMode: AuthMode.login,

      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        debugPrint('user ' + _loginUser(loginData).toString());
        return _loginUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('email: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');
        debugPrint('user register   ${signupData}');


        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (var element in signupData.termsOfService) {
            debugPrint(
                ' - ${element.term.id}: ${element.accepted == true
                    ? 'accepted'
                    : 'rejected'}');
          }
        }
        return _signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {

          Navigator.pushNamed(context , '/app' , arguments: {"database" : this.database , "user" : this.user});
       // Navigator.pushNamed(context ,BaseScreen(database: this.database,user: this.user));
        //Get.to(BaseScreen(database: this.database,  user : this.user));


        /* Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context , arguments: {"user" : this.database }) => const DashboardScreen(),
        ));*/
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons:false,
    );
  }
}