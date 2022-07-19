import 'package:flutter/material.dart';


import 'components/body.dart';



class HealthScreen extends StatelessWidget{
  static String routeName = "/health";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
      ),
      body: Body(),

    );
  }

  }
  
