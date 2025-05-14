import 'package:flutter/material.dart';
import 'package:resqtrack1/authentication/login_screen.dart';

class SignupScreen extends StatefulWidget
{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
{
  TextEditingController userNametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [

          Image.asset(
              "assets/images/logo.png",
          ),

          const Text(
            "Create a User\'s Account",
            style:TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            )
          ),

          //text field + button
          Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children:[

                  TextField(
                    controller: userNametextEditingController,
                    keyboardType: TextInputType.text,
                    decoration:const InputDecoration(
                      labelText: "User Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 22,),

                  TextField(
                    controller: emailtextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:const InputDecoration(
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
                  const SizedBox(height: 22,),

                  TextField(
                    controller: passwordtextEditingController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration:const InputDecoration(
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
                  const SizedBox(height: 32,),

                  ElevatedButton(
                      onPressed: ()
                    {
                        checkIfNetworkIsAvailable();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 20,),
                    ),
                    child: const Text(
                      "Sign up"
                    ),
                  )
                ]
              )
          ),
              const SizedBox(height: 12,),


              TextButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
                },
                child: const Text(
                  "Already have an account? Login here.",
                  style: TextStyle(
                    color: Colors.grey,
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