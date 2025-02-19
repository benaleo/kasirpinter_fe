import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/splash_screen.dart';
import 'package:kasirpinter_fe/tab/auth_change_password.dart';
import 'package:kasirpinter_fe/tab/auth_forgot_password_tab.dart';
import 'package:kasirpinter_fe/tab/auth_login_tab.dart';
import 'package:kasirpinter_fe/tab/auth_otp_tab.dart';
import 'package:kasirpinter_fe/tab/ms_product_form_tab.dart';
import 'package:kasirpinter_fe/tab/ms_product_form_tab.dart';
import 'package:kasirpinter_fe/tab/ms_product_tab.dart';
import 'package:kasirpinter_fe/tab/ms_product_category_tab.dart';
import 'package:kasirpinter_fe/tab/pos_dashboard_tab.dart';
import 'package:kasirpinter_fe/tab/pos_menu_tab.dart';
import 'package:kasirpinter_fe/tab/pos_order_tab.dart';
import 'package:kasirpinter_fe/tab/pos_setting_tab.dart';
import 'package:kasirpinter_fe/web/login_web.dart';

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
      case '/login':
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
      case '/splash-screen':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return SplashScreen();
              } else {
                return SplashScreen();
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
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return PosDashboardTab();
              } else {
                return PosDashboardTab();
              }
            },
          ),
        );
      case '/pos-order':
        return MaterialPageRoute(
          settings: settings,
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
      case '/pos-menu':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return PosMenuTab();
              } else {
                return PosMenuTab();
              }
            },
          ),
        );
      case '/setting/product-category':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return MsProductCategoryTab();
              } else {
                return MsProductCategoryTab();
              }
            },
          ),
        );
      case '/setting/product-list':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return MsProductTab();
              } else {
                return MsProductTab();
              }
            },
          ),
        );
      case '/setting/product-list/add':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return MsProductFormTab();
              } else {
                return MsProductFormTab();
              }
            },
          ),
        );

      case '/setting/product':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return MsProductTab();
              } else {
                return MsProductTab();
              }
            },
          ),
        );

      case '/setting':
        return MaterialPageRoute(
          builder: (_) => LayoutBuilder(
            builder: (context, constraits) {
              if (constraits.maxWidth > 800) {
                return PosSettingTab();
              } else {
                return PosSettingTab();
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
