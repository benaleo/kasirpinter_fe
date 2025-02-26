import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/mobile/auth_login_mobile.dart';
import 'package:kasirpinter_fe/mobile/ms_product_mobile.dart';
import 'package:kasirpinter_fe/mobile/pos_dashboard_mobile.dart';
import 'package:kasirpinter_fe/mobile/pos_menu_mobile.dart';
import 'package:kasirpinter_fe/splash_screen.dart';
import 'package:kasirpinter_fe/splash_screen_mobile.dart';
import 'package:kasirpinter_fe/tab/auth_change_password.dart';
import 'package:kasirpinter_fe/tab/auth_forgot_password_tab.dart';
import 'package:kasirpinter_fe/tab/auth_login_tab.dart';
import 'package:kasirpinter_fe/tab/auth_otp_tab.dart';
import 'package:kasirpinter_fe/tab/ms_product_form_tab.dart';
import 'package:kasirpinter_fe/tab/ms_product_tab.dart';
import 'package:kasirpinter_fe/tab/ms_product_category_tab.dart';
import 'package:kasirpinter_fe/tab/pos_dashboard_tab.dart';
import 'package:kasirpinter_fe/tab/pos_menu_tab.dart';
import 'package:kasirpinter_fe/tab/pos_order_tab.dart';
import 'package:kasirpinter_fe/tab/pos_setting_tab.dart';
import 'package:kasirpinter_fe/web/login_web.dart';

import 'mobile/pos_order_mobile.dart';

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
                return LoginMobile();
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
                return LoginMobile();
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
                return SplashScreenMobile();
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
                return PosDashboardMobile();
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
                return PosOrderMobile();
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
                return PosMenuMobile();
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
                return MsProductMobile();
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
                return MsProductMobile();
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
