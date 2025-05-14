import 'package:flutter/material.dart';
import 'package:resqtrack1/authentication/signup_screen.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
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
                  "Login as User",
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

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 20,),
                          ),
                          child: const Text(
                              "Log in"
                          ),
                        )
                      ]
                  )
              ),
              const SizedBox(height: 12,),


              TextButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>SignupScreen()));
                },
                child: const Text(
                  "Don\'t have an Account? Register Here",
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

