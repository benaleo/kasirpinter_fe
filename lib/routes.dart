import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/tab/auth_change_password.dart';
import 'package:kasirpinter_fe/tab/auth_forgot_password_tab.dart';
import 'package:kasirpinter_fe/tab/auth_login_tab.dart';
import 'package:kasirpinter_fe/tab/auth_otp_tab.dart';
import 'package:kasirpinter_fe/tab/pos_order_tab.dart';
import 'package:kasirpinter_fe/web/login_web.dart';
import 'package:kasirpinter_fe/web/auth_otp_web.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return LoginTab();
              } else {
                return LoginTab();
              }
            },
          ),
        );
      case '/otp':
        return MaterialPageRoute(
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return AuthOtpTab();
              } else {
                return AuthOtpTab();
              }
            },
          ),
        );
      case '/change-password':
        return MaterialPageRoute(
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return AuthChangePasswordTab();
              } else {
                return AuthChangePasswordTab();
              }
            },
          ),
        );
      case '/forgot-password':
        return MaterialPageRoute(
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return AuthForgotPasswordTab();
              } else {
                return AuthForgotPasswordTab();
              }
            },
          ),
        );
      case '/pos-order':
        return MaterialPageRoute(
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return PosOrderTab();
              } else {
                return PosOrderTab();
              }
            },
          ),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return LoginWeb();
              } else {
                return LoginTab();
              }
            },
          ),
        );
    }
  }
}
