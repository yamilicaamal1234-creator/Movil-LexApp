import 'package:flutter/material.dart';
import '../../screens/lexapp_screens.dart';
import '../../screens/splash_screen.dart';

class AppRoutes {
  static const m01Splash = '/M01';
  static const m02Login = '/M02';
  static const m02aOtpLogin = '/M02A';
  static const m02bForgot = '/M02B';
  static const m02cRecoveryOtp = '/M02C';
  static const m02dNewPassword = '/M02D';
  static const clientRegister = '/client-register';
  static const m04LawyerWeb = '/M04';
  static const m05Register = '/M05';
  static const m05aRegisterOtp = '/M05A';
  static const m06Home = '/M06';
  static const m06aNotifications = '/M06A';
  static const m07Search = '/M07';
  static const m08LawyerProfile = '/M08';
  static const m09Contract = '/M09';
  static const m10Payment = '/M10';
  static const m10aAdditionalCharge = '/M10A';
  static const m11Confirmation = '/M11';
  static const m12Cases = '/M12';
  static const m13CaseDetail = '/M13';
  static const m14Documents = '/M14';
  static const m15Signature = '/M15';
  static const m16Messages = '/M16';
  static const m17Chat = '/M17';
  static const m18aWaitingRoom = '/M18A';
  static const m18VideoCall = '/M18';
  static const m19Profile = '/M19';
  static const m20PaymentMethods = '/M20';
  static const m21Security = '/M21';
  static const splash = '/';
  static const login = '/login';
  static const otpLogin = '/otp-login';
  static const forgot = '/forgot';
  static const recoveryOtp = '/recovery-otp';
  static const newPassword = '/new-password';
  static const lawyerWeb = '/lawyer-web';
  static const register = '/register';
  static const registerOtp = '/register-otp';
  static const shell = '/home';
  static const notifications = '/notifications';
  static const search = '/search';
  static const lawyerProfile = '/lawyer-profile';
  static const contract = '/contract';
  static const payment = '/payment';
  static const additionalCharge = '/additional-charge';
  static const confirmation = '/confirmation';
  static const caseDetail = '/case-detail';
  static const documents = '/documents';
  static const signature = '/signature';
  static const chat = '/chat';
  static const waitingRoom = '/waiting-room';
  static const videoCall = '/video-call';
  static const paymentMethods = '/payment-methods';
  static const security = '/security';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case m01Splash:
        page = const SplashScreen();
        break;
      case login:
      case m02Login:
        page = const LoginScreenLex();
        break;
      case otpLogin:
      case m02aOtpLogin:
        final otpArgs = settings.arguments as Map<String, dynamic>?;
        page = OtpScreen(
          title: otpArgs?['title'] as String? ?? 'Verifica tu identidad',
          destination: otpArgs?['destination'] as String? ?? shell,
          email: otpArgs?['email'] as String?,
          expectedCode: otpArgs?['code'] as String?,
        );
        break;
      case forgot:
      case m02bForgot:
        page = const ForgotPasswordScreen();
        break;
      case recoveryOtp:
      case m02cRecoveryOtp:
        final recoveryArgs = settings.arguments as Map<String, dynamic>?;
        page = OtpScreen(
          title: 'Verifica tu correo electrónico',
          destination: newPassword,
          email: recoveryArgs?['email'] as String?,
          expectedCode: recoveryArgs?['code'] as String?,
        );
        break;
      case newPassword:
      case m02dNewPassword:
        page = const NewPasswordScreen();
        break;
      case lawyerWeb:
      case m04LawyerWeb:
        page = const LawyerWebScreen();
        break;
      case register:
      case clientRegister:
      case m05Register:
        page = const RegisterScreen();
        break;
      case registerOtp:
      case m05aRegisterOtp:
        final regArgs = settings.arguments as Map<String, dynamic>?;
        page = OtpScreen(
          title: 'Verifica tu correo electrónico',
          destination: shell,
          registrationStep: true,
          email: regArgs?['email'] as String?,
          expectedCode: regArgs?['code'] as String?,
        );
        break;
      case notifications:
      case m06aNotifications:
        page = const NotificationsScreen();
        break;
      case search:
      case m07Search:
        page = const SearchLawyerScreen();
        break;
      case lawyerProfile:
      case m08LawyerProfile:
        page = const LawyerProfileScreen();
        break;
      case contract:
      case m09Contract:
        page = const ContractScreen();
        break;
      case payment:
      case m10Payment:
        page = const PaymentScreen();
        break;
      case additionalCharge:
      case m10aAdditionalCharge:
        page = const AdditionalChargeScreen();
        break;
      case confirmation:
      case m11Confirmation:
        page = const ConfirmationScreen();
        break;
      case caseDetail:
      case m13CaseDetail:
        page = const CaseDetailLexScreen();
        break;
      case documents:
      case m14Documents:
        page = const CaseDocumentsScreen();
        break;
      case signature:
      case m15Signature:
        page = const SignatureScreen();
        break;
      case chat:
      case m17Chat:
        page = const ChatScreenLex();
        break;
      case waitingRoom:
      case m18aWaitingRoom:
        page = WaitingRoomScreen(
          video: settings.arguments is bool ? settings.arguments as bool : true,
        );
        break;
      case videoCall:
      case m18VideoCall:
        page = VideoCallScreen(
          video: settings.arguments is bool ? settings.arguments as bool : true,
        );
        break;
      case paymentMethods:
      case m20PaymentMethods:
        page = const PaymentMethodsScreen();
        break;
      case security:
      case m21Security:
        page = const SecurityScreen();
        break;
      case shell:
      case m06Home:
        page = const MainScreenRoute(initialIndex: 0);
        break;
      case m12Cases:
        page = const MainScreenRoute(initialIndex: 1);
        break;
      case m16Messages:
        page = const MainScreenRoute(initialIndex: 2);
        break;
      case m19Profile:
        page = const MainScreenRoute(initialIndex: 3);
        break;
      default:
        page = settings.name == login
            ? const LoginScreenLex()
            : const MainScreenRoute();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
