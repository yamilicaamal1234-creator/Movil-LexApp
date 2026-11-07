import 'package:flutter/foundation.dart';
import '../models/lexapp_models.dart';

class AppDataService extends ChangeNotifier {
  UserProfile user = const UserProfile(
    name: 'Ricardo Hernández',
    email: 'ricardo.hernandez@email.com',
    phone: '+52 55 1234 5678',
    address: 'Av. Reforma 123, Ciudad de México',
    birthDate: '12/05/1990',
    taxId: 'HERM900512ABC',
  );

  final lawyers = const [
    LawyerModel(
      name: 'Dra. Sofía Valenzuela',
      specialty: 'Derecho Civil',
      credentials: 'Cédula colegial 8841',
      rating: 4.9,
      fee: 65,
    ),
    LawyerModel(
      name: 'Lic. María López',
      specialty: 'Derecho Laboral',
      credentials: 'Cédula colegial 7712',
      rating: 4.8,
      fee: 58,
    ),
  ];

  final cases = const [
    CaseModel(
      number: '#LX-2024-8841',
      area: 'Civil',
      subject: 'Revisión de contrato de arrendamiento',
      lawyer: 'Dra. Sofía Valenzuela',
      progress: 0.72,
      status: 'Cita hoy 17:00 hs',
    ),
    CaseModel(
      number: 'Caso #1024',
      area: 'Laboral',
      subject: 'Revisión de prestación laboral',
      lawyer: 'Lic. María López',
      progress: 0.45,
      status: 'En negociación',
    ),
  ];

  final List<PaymentCardModel> paymentCards = [
    const PaymentCardModel(
      brand: 'VISA',
      lastFour: '4582',
      holderName: 'RICARDO HERNANDEZ',
      expiry: '08/29',
      defaultCard: true,
    ),
    const PaymentCardModel(
      brand: 'MASTERCARD',
      lastFour: '8104',
      holderName: 'RICARDO HERNANDEZ',
      expiry: '11/28',
    ),
  ];

  bool pinEnabled = true;
  String? pinHash;
  bool biometricEnabled = true;
  bool strongSignatureAuth = true;
  bool twoFactorEnabled = true;
  bool messageNotifications = true;
  bool caseNotifications = true;
  bool signatureNotifications = true;
  bool paymentNotifications = true;
  bool meetingNotifications = true;
  bool cameraPermission = false;
  bool locationPermission = false;
  bool storagePermission = true;
  bool deviceNotificationsPermission = true;

  void updateProfile(UserProfile profile) {
    user = profile;
    notifyListeners();
  }

  void updateSetting(String key, bool value) {
    switch (key) {
      case 'pin':
        pinEnabled = value;
        break;
      case 'biometric':
        biometricEnabled = value;
        break;
      case 'strongSignature':
        strongSignatureAuth = value;
        break;
      case 'twoFactor':
        twoFactorEnabled = value;
        break;
      case 'messages':
        messageNotifications = value;
        break;
      case 'cases':
        caseNotifications = value;
        break;
      case 'signatures':
        signatureNotifications = value;
        break;
      case 'payments':
        paymentNotifications = value;
        break;
      case 'meetings':
        meetingNotifications = value;
        break;
      case 'camera':
        cameraPermission = value;
        break;
      case 'location':
        locationPermission = value;
        break;
      case 'storage':
        storagePermission = value;
        break;
      case 'deviceNotifications':
        deviceNotificationsPermission = value;
        break;
    }
    notifyListeners();
  }

  void setPin(String pin) {
    pinHash = pin.split('').reversed.join();
    pinEnabled = true;
    notifyListeners();
  }

  bool verifyPin(String pin) {
    if (pinHash == null) return false;
    return pinHash == pin.split('').reversed.join();
  }

  void addPaymentCard(PaymentCardModel card) {
    if (paymentCards.isEmpty) {
      card = card.copyWith(defaultCard: true);
    }
    paymentCards.add(card);
    notifyListeners();
  }

  void setDefaultPaymentCard(int index) {
    for (var i = 0; i < paymentCards.length; i++) {
      paymentCards[i] = paymentCards[i].copyWith(defaultCard: i == index);
    }
    notifyListeners();
  }

  void removePaymentCard(int index) {
    if (index < 0 || index >= paymentCards.length) return;
    final removedDefault = paymentCards[index].defaultCard;
    paymentCards.removeAt(index);
    if (removedDefault && paymentCards.isNotEmpty) {
      paymentCards[0] = paymentCards[0].copyWith(defaultCard: true);
    }
    notifyListeners();
  }

  final List<AppNotificationModel> notifications = [
    AppNotificationModel(
      title: 'Nuevo mensaje',
      subtitle: 'Dra. Sofía Valenzuela',
      route: '/chat',
    ),
    AppNotificationModel(
      title: 'Documento pendiente de firma',
      subtitle: 'adenda_clausula_penal.pdf',
      route: '/signature',
    ),
    AppNotificationModel(
      title: 'Solicitud de cobro adicional',
      subtitle: 'Caso #1024',
      route: '/additional-charge',
    ),
    AppNotificationModel(
      title: 'Videollamada hoy a las 17:00',
      subtitle: 'Caso #LX-2024-8841',
      route: '/waiting-room',
    ),
    AppNotificationModel(
      title: 'Actualización de caso',
      subtitle: 'Documentación revisada',
      route: '/case-detail',
    ),
  ];

  final List<ConversationModel> conversations = [
    ConversationModel(
      lawyer: 'Dra. Sofía Valenzuela',
      caseNumber: 'Caso #LX-2024-8841',
      time: '16:52',
      preview: 'He preparado la adenda con la reducción de penalización...',
      unreadCount: 2,
      online: true,
    ),
    ConversationModel(
      lawyer: 'Lic. María López',
      caseNumber: 'Caso #1024',
      time: '14:45',
      preview: 'Te envié el documento para revisión.',
      unreadCount: 1,
      online: false,
    ),
    ConversationModel(
      lawyer: 'Dr. Marcos Alarcón',
      caseNumber: 'Caso #LX-2024-7910',
      time: 'Ayer',
      preview: 'La documentación quedó completa para revisión.',
      unreadCount: 0,
      online: false,
    ),
  ];

  bool get hasUnreadNotifications =>
      notifications.any((notification) => !notification.read);
  int get totalUnreadMessages => conversations.fold(
    0,
    (total, conversation) => total + conversation.unreadCount,
  );

  void openNotification(AppNotificationModel notification) {
    notification.read = true;
    notifications.remove(notification);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    notifications.clear();
    notifyListeners();
  }

  void markConversationRead(int index) {
    if (index >= 0 &&
        index < conversations.length &&
        conversations[index].unreadCount > 0) {
      conversations[index].unreadCount = 0;
      notifyListeners();
    }
  }

  void addUnreadMessage(int index, {int amount = 1}) {
    if (index >= 0 && index < conversations.length) {
      conversations[index].unreadCount += amount;
      notifyListeners();
    }
  }
}
