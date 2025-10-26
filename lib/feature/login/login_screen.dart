import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smt_project/product/base/bloc/base_bloc.dart';
import 'package:smt_project/product/cache/locale_manager.dart';
import 'package:smt_project/product/constants/enums/locale_keys_enum.dart';

import '../../product/constants/enums/app_route_enums.dart';
import 'login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc loginBloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();


  void _submitForm() async {
    // toastService.showSuccessToast(
    //     context: context, title: "Thong bao", message: "Test thong bao");
    if (_formKey.currentState!.validate()) {
      // Form is valid, retrieve values from controllers
      final phone = _phoneController.text;
      final password = _passController.text;
      // final name = _nameController.text;
      loginBloc.handleLogin(context, phone, password);
      // registerBloc.registerUser(context, name, email, password);
      // Example: Print values (you can use them as needed)
      // print('Name: $name');
      log('Email: $phone');
      log('Password: $password');
      // print('Confirm Password: $confirmPassword');
      // You can now use these values (e.g., send to an API, save to a database, etc.)
    }
  }


  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Image.asset(
                "assets/images/login_1.png",
                width: 413,
                height: 457,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Color(0xFF755DC1),
                        fontSize: 27,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      // textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Số điện thoại',
                        labelStyle: TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF837E93),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF9F7BFF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _passController,
                      // textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF837E93),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF9F7BFF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SizedBox(
                        width: 329,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9F7BFF),
                          ),
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Row(
                    //   children: [
                    //     const Text(
                    //       'Don’t have an account?',
                    //       style: TextStyle(
                    //         color: Color(0xFF837E93),
                    //         fontSize: 13,
                    //         fontFamily: 'Poppins',
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 2.5,
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         // widget.controller.animateToPage(1,
                    //         //     duration: const Duration(milliseconds: 500),
                    //         //     curve: Curves.ease);
                    //       },
                    //       child: const Text(
                    //         'Sign Up',
                    //         style: TextStyle(
                    //           color: Color(0xFF755DC1),
                    //           fontSize: 13,
                    //           fontFamily: 'Poppins',
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // const Text(
                    //   'Forget Password?',
                    //   style: TextStyle(
                    //     color: Color(0xFF755DC1),
                    //     fontSize: 13,
                    //     fontFamily: 'Poppins',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkLogin() async {
    String token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    int exp = LocaleManager.instance.getIntValue(PreferencesKeys.EXP);
    int timeNow = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (token != "" && (exp - timeNow) > 7200) {
      if (mounted) {
        context.goNamed(AppRoutes.MAIN.name);
      }
    }
  }
}
