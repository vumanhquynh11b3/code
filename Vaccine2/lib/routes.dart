import 'package:flutter/widgets.dart';
import 'package:vaccine2/screens/complete_profile/complete_profile_screen.dart';
import 'package:vaccine2/screens/forgot_password/forgot_password_screen.dart';
import 'package:vaccine2/screens/health_declaration/health_screen.dart';
import 'package:vaccine2/screens/home/home_screen.dart';
import 'package:vaccine2/screens/otp/otp_screen.dart';
import 'package:vaccine2/screens/profile/profile_screen.dart';
import 'package:vaccine2/screens/sign_in/sign_in_screen.dart';
import 'package:vaccine2/screens/sign_up/sign_up_screen.dart';
import 'package:vaccine2/screens/splash/splash_screen.dart';
import 'package:vaccine2/screens/update_info/update_info_screen.dart';
import 'package:vaccine2/screens/update_profile/update_profile_screen.dart';
import 'package:vaccine2/screens/vaccine_history/vaccine_history.dart';
import 'package:vaccine2/screens/vaccine_status/vaccine_status.dart';
import 'screens/Create_QR/create_qr_screen.dart';



// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  CreateQRScreen.routeName: (context) => CreateQRScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  HealthScreen.routeName: (context)=> HealthScreen(),
  // DetailsScreen.routeName: (context) => DetailsScreen(),
  // CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  UpdateProfile.routeName:(context)=>UpdateProfile(),
  UpdateInfo.routeName:(context)=>UpdateInfo(),
  VaccineHistory.routeName:(context)=>VaccineHistory(),
  VaccineStatus.routeName:(context)=>VaccineStatus()

};
