import 'package:flutter/material.dart';
import 'package:brekete_connect/utils/routes.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              AppRoutes.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black)),
        /* title: Text(
              'New Complaint',
              style: TextStyle(
                color: Color.fromARGB(255, 49, 76, 190),
              ),
            ), */
      ),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
