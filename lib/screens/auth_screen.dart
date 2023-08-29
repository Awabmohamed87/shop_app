import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/authScreen';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromRGBO(215, 188, 117, 1).withOpacity(0.5),
              ],
              stops: [0, 1],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Text(
                      'Ready for Shopping',
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.headlineMedium!.color,
                          fontSize: 35,
                          fontFamily: 'Anton'),
                    ),
                  ),
                ),
                Flexible(
                  child: AuthCard(),
                  flex: deviceSize.width > 600 ? 2 : 1,
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
