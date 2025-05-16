// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:resqtrack1/authentication/login_screen.dart';
// import 'package:resqtrack1/methods/common_methods.dart';
// import 'package:resqtrack1/pages/home_page.dart';
// import 'package:resqtrack1/widgets/loading_dialog.dart';
//
// class SignupScreen extends StatefulWidget
// {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen>
// {
//   TextEditingController userNametextEditingController = TextEditingController();
//   TextEditingController userPhonetextEditingController = TextEditingController();
//   TextEditingController emailtextEditingController = TextEditingController();
//   TextEditingController passwordtextEditingController = TextEditingController();
//   CommonMethods cMethods = CommonMethods();
//
//
//   checkIfNetworkIsAvailable()
//   {
//     cMethods.checkConnectivity(context);
//
//     signUpFormAvailable();
//   }
//
//   signUpFormAvailable()
//   {
//     if(userNametextEditingController.text.trim().length < 3)
//       {
//         cMethods.displaySnackbar("Your name must be atleast 4 letters long.", context);
//       }
//     else if(userPhonetextEditingController.text.trim().length < 7)
//       {
//         cMethods.displaySnackbar("Invalid Phone Number.", context);
//       }
//     else if(!emailtextEditingController.text.contains("@"))
//       {
//         cMethods.displaySnackbar("Invalid Email Format", context);
//       }
//     else if(passwordtextEditingController.text.trim().length < 5)
//       {
//         cMethods.displaySnackbar("your password must be at least 8 characters.", context);
//       }
//     else
//       {
//         registerNewUser();
//       }
//   }
//
//   registerNewUser() async
//   {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext) => LoadingDialog(messageText: "Registering your account..."),
//     );
//
//     final User? userFirebase = (
//       await FirebaseAuth.instance.createUserWithEmailAndPassword
//       (
//         email: emailtextEditingController.text.trim(),
//         password: passwordtextEditingController.text.trim(),
//       ).catchError((errorMsg)
//       {
//         cMethods.displaySnackbar(errorMsg.toString(), context);
//       })
//     ).user;
//
//     if(!context.mounted) return;
//     Navigator.pop(context);
//
//     DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
//     Map userDataMap =
//         {
//           "name": userNametextEditingController.text.trim(),
//           "email": emailtextEditingController.text.trim(),
//           "phone": userPhonetextEditingController.text.trim(),
//           "id": userFirebase.uid,
//           "blockStatus": "no",
//         };
//     userRef.set(userDataMap);
//
//     Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));
//   }
//
//   @override
//   Widget build(BuildContext context)
//   {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//
//           Image.asset(
//               "assets/images/logo.png",
//           ),
//
//           const Text(
//             "Create a User\'s Account",
//             style:TextStyle(
//               fontSize: 26,
//               fontWeight: FontWeight.bold,
//             )
//           ),
//
//           //text field + button
//           Padding(
//               padding: const EdgeInsets.all(22),
//               child: Column(
//                 children:[
//
//                   TextField(
//                     controller: userNametextEditingController,
//                     keyboardType: TextInputType.text,
//                     decoration:const InputDecoration(
//                       labelText: "User Name",
//                       labelStyle: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 22,),
//
//                   TextField(
//                     controller: emailtextEditingController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration:const InputDecoration(
//                       labelText: "User Email",
//                       labelStyle: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 22,),
//
//                   TextField(
//                     controller: userPhonetextEditingController,
//                     keyboardType: TextInputType.text,
//                     decoration:const InputDecoration(
//                       labelText: "User Phone",
//                       labelStyle: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 22,),
//
//                   TextField(
//                     controller: passwordtextEditingController,
//                     obscureText: true,
//                     keyboardType: TextInputType.text,
//                     decoration:const InputDecoration(
//                       labelText: "User Password",
//                       labelStyle: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 32,),
//
//                   ElevatedButton(
//                       onPressed: ()
//                     {
//                       checkIfNetworkIsAvailable();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purple,
//                       padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 20,),
//                     ),
//                     child: const Text(
//                       "Sign up"
//                     ),
//                   )
//                 ]
//               )
//           ),
//               const SizedBox(height: 12,),
//
//
//               TextButton(
//                 onPressed: ()
//                 {
//                   Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
//                 },
//                 child: const Text(
//                   "Already have an account? Login here.",
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resqtrack1/authentication/login_screen.dart';
import 'package:resqtrack1/methods/common_methods.dart';
import 'package:resqtrack1/pages/home_page.dart';
import 'package:resqtrack1/screens/map_screen.dart';
import 'package:resqtrack1/widgets/loading_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNametextEditingController = TextEditingController();
  TextEditingController userPhonetextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signUpFormAvailable();
  }

  signUpFormAvailable() {
    if (userNametextEditingController.text.trim().length < 3) {
      cMethods.displaySnackbar("Your name must be at least 4 letters long.", context);
    } else if (userPhonetextEditingController.text.trim().length < 7) {
      cMethods.displaySnackbar("Invalid Phone Number.", context);
    } else if (!emailtextEditingController.text.contains("@")) {
      cMethods.displaySnackbar("Invalid Email Format", context);
    } else if (passwordtextEditingController.text.trim().length < 5) {
      cMethods.displaySnackbar("Your password must be at least 8 characters.", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext) => LoadingDialog(messageText: "Registering your account..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailtextEditingController.text.trim(),
      password: passwordtextEditingController.text.trim(),
    ).catchError((errorMsg) {
      cMethods.displaySnackbar(errorMsg.toString(), context);
    })).user;

    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      "name": userNametextEditingController.text.trim(),
      "email": emailtextEditingController.text.trim(),
      "phone": userPhonetextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    userRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => const MapScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset("assets/images/logo.png"),
              const Text(
                "Create a User's Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: userNametextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: userPhonetextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Phone",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: passwordtextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Password",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      ),
                      child: const Text("Sign up"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
                },
                child: const Text(
                  "Already have an account? Login here.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
