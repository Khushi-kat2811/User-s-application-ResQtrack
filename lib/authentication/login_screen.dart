// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:resqtrack1/authentication/signup_screen.dart';
// import 'package:resqtrack1/global/global_var.dart';
// import 'package:resqtrack1/methods/common_methods.dart';
// import 'package:resqtrack1/pages/home_page.dart';
// import 'package:resqtrack1/widgets/loading_dialog.dart';
//
// class LoginScreen extends StatefulWidget
// {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
// {
//   TextEditingController emailtextEditingController = TextEditingController();
//   TextEditingController passwordtextEditingController = TextEditingController();
//   CommonMethods cMethods = CommonMethods();
//
//
//   checkIfNetworkIsAvailable()
//   {
//     cMethods.checkConnectivity(context);
//
//     signInFormValidation();
//   }
//
//   signInFormValidation()
//   {
//     if(!emailtextEditingController.text.contains("@"))
//     {
//       cMethods.displaySnackbar("Invalid Email Format", context);
//     }
//     else if(passwordtextEditingController.text.trim().length < 5)
//     {
//       cMethods.displaySnackbar("your password must be at least 8 characters.", context);
//     }
//     else
//     {
//       signInUser();
//     }
//   }
//
//   signInUser() async
//   {
//   showDialog(
//   context: context,
//   barrierDismissible: false,
//   builder: (BuildContext) => LoadingDialog(messageText: "Logging in..."),
//   );
//
//   final User? userFirebase = (
//   await FirebaseAuth.instance.signInWithEmailAndPassword
//   (
//   email: emailtextEditingController.text.trim(),
//   password: passwordtextEditingController.text.trim(),
//   ).catchError((errorMsg)
//   {
//   cMethods.displaySnackbar(errorMsg.toString(), context);
//   })
//   ).user;
//
//   if(!context.mounted) return;
//   Navigator.pop(context);
//
//   if(userFirebase != null)
//     {
//       DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
//       userRef.once().then((snap)
//       {
//           if(snap.snapshot.value != null)
//             {
//               if((snap.snapshot.value as Map)["blockStatus"] == "no")
//                 {
//                   userName = (snap.snapshot.value as Map)["name"];
//                   Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
//                 }
//               else
//                 {
//                   FirebaseAuth.instance.signOut();
//                   cMethods.displaySnackbar("You are blocked. Contact admin: xyz@gmail.com", context);
//                 }
//             }
//           else
//             {
//               FirebaseAuth.instance.signOut();
//               cMethods.displaySnackbar("User does not exist.", context);
//             }
//       });
//     }
//
// }
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
//               Image.asset(
//                 "assets/images/logo.png",
//               ),
//
//               const Text(
//                   "Login as User",
//                   style:TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   )
//               ),
//
//               //text field + button
//               Padding(
//                   padding: const EdgeInsets.all(22),
//                   child: Column(
//                       children:[
//
//                         TextField(
//                           controller: emailtextEditingController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration:const InputDecoration(
//                             labelText: "User Email",
//                             labelStyle: TextStyle(
//                               fontSize: 14,
//                             ),
//                           ),
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 22,),
//
//                         TextField(
//                           controller: passwordtextEditingController,
//                           obscureText: true,
//                           keyboardType: TextInputType.text,
//                           decoration:const InputDecoration(
//                             labelText: "User Password",
//                             labelStyle: TextStyle(
//                               fontSize: 14,
//                             ),
//                           ),
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 32,),
//
//                         ElevatedButton(
//                           onPressed: ()
//                           {
//                             checkIfNetworkIsAvailable();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.purple,
//                             padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 20,),
//                           ),
//                           child: const Text(
//                               "Log in"
//                           ),
//                         )
//                       ]
//                   )
//               ),
//               const SizedBox(height: 12,),
//
//
//               TextButton(
//                 onPressed: ()
//                 {
//                   Navigator.push(context, MaterialPageRoute(builder: (c)=>SignupScreen()));
//                 },
//                 child: const Text(
//                   "Don\'t have an Account? Register Here",
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
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:resqtrack1/authentication/signup_screen.dart';
// import 'package:resqtrack1/global/global_var.dart';
// import 'package:resqtrack1/methods/common_methods.dart';
// import 'package:resqtrack1/pages/home_page.dart';
// import 'package:resqtrack1/screens/map_screen.dart';
// import 'package:resqtrack1/widgets/loading_dialog.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailtextEditingController = TextEditingController();
//   TextEditingController passwordtextEditingController = TextEditingController();
//   CommonMethods cMethods = CommonMethods();
//
//   checkIfNetworkIsAvailable() {
//     cMethods.checkConnectivity(context);
//     signInFormValidation();
//   }
//
//   signInFormValidation() {
//     if (!emailtextEditingController.text.contains("@")) {
//       cMethods.displaySnackbar("Invalid Email Format", context);
//     } else if (passwordtextEditingController.text.trim().length < 5) {
//       cMethods.displaySnackbar("Your password must be at least 8 characters.", context);
//     } else {
//       signInUser();
//     }
//   }
//
//   signInUser() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext) => LoadingDialog(messageText: "Logging in..."),
//     );
//
//     final User? userFirebase = (await FirebaseAuth.instance
//         .signInWithEmailAndPassword(
//       email: emailtextEditingController.text.trim(),
//       password: passwordtextEditingController.text.trim(),
//     ).catchError((errorMsg) {
//       cMethods.displaySnackbar(errorMsg.toString(), context);
//     }))
//         .user;
//
//     if (!context.mounted) return;
//     Navigator.pop(context);
//
//     if (userFirebase != null) {
//       DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
//       userRef.once().then((snap) {
//         if (snap.snapshot.value != null) {
//           if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
//             userName = (snap.snapshot.value as Map)["name"];
//             Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
//           } else {
//             FirebaseAuth.instance.signOut();
//             cMethods.displaySnackbar("You are blocked. Contact admin: xyz@gmail.com", context);
//           }
//         } else {
//           FirebaseAuth.instance.signOut();
//           cMethods.displaySnackbar("User does not exist.", context);
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Image.asset("assets/images/logo.png"),
//
//               const Text(
//                 "Login as User",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(22),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: emailtextEditingController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: const InputDecoration(
//                         labelText: "User Email",
//                         labelStyle: TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 22),
//
//                     TextField(
//                       controller: passwordtextEditingController,
//                       obscureText: true,
//                       keyboardType: TextInputType.text,
//                       decoration: const InputDecoration(
//                         labelText: "User Password",
//                         labelStyle: TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//
//                     ElevatedButton(
//                       onPressed: () {
//                         checkIfNetworkIsAvailable();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
//                       ),
//                       child: const Text("Log in"),
//                     ),
//                     const SizedBox(height: 22),
//
//                     // New Map Button
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
//                       ),
//                       child: const Text("Open Map"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (c) => SignupScreen()));
//                 },
//                 child: const Text(
//                   "Don't have an Account? Register Here",
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
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
import 'package:resqtrack1/authentication/signup_screen.dart';
import 'package:resqtrack1/global/global_var.dart';
import 'package:resqtrack1/methods/common_methods.dart';
import 'package:resqtrack1/screens/map_screen.dart';
import 'package:resqtrack1/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailtextEditingController.text.contains("@")) {
      cMethods.displaySnackbar("Invalid Email Format", context);
    } else if (passwordtextEditingController.text.trim().length < 8) {
      cMethods.displaySnackbar("Your password must be at least 8 characters.", context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext) => LoadingDialog(messageText: "Logging in..."),
    );

    try {
      final User? userFirebase = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailtextEditingController.text.trim(),
        password: passwordtextEditingController.text.trim(),
      )).user;

      if (!context.mounted) return;
      Navigator.pop(context);

      if (userFirebase != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
        await userRef.once().then((snap) {
          if (snap.snapshot.value != null) {
            if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
              userName = (snap.snapshot.value as Map)["name"];
              Navigator.pushReplacementNamed(context, '/map');
            } else {
              FirebaseAuth.instance.signOut();
              cMethods.displaySnackbar("You are blocked. Contact admin: xyz@gmail.com", context);
            }
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackbar("User does not exist.", context);
          }
        });
      }
    } catch (error) {
      Navigator.pop(context);
      cMethods.displaySnackbar(error.toString(), context);
    }
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
                "Login as User",
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
                      controller: emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 22),

                    TextField(
                      controller: passwordtextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
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
                      child: const Text("Log in"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SignupScreen()));
                },
                child: const Text(
                  "Don't have an Account? Register Here",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

