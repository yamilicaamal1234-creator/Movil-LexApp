class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String birthDate;
  final String taxId;
  const UserProfile({
    required this.name,
    required this.email,
    this.phone = '',
    this.address = '',
    this.birthDate = '',
    this.taxId = '',
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? birthDate,
    String? taxId,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      taxId: taxId ?? this.taxId,
    );
  }
}

class LawyerModel {
  final String name;
  final String specialty;
  final String credentials;
  final double rating;
  final double fee;
  const LawyerModel({
    required this.name,
    required this.specialty,
    required this.credentials,
    required this.rating,
    required this.fee,
  });
}

class CaseModel {
  final String number;
  final String area;
  final String subject;
  final String lawyer;
  final double progress;
  final String status;
  const CaseModel({
    required this.number,
    required this.area,
    required this.subject,
    required this.lawyer,
    required this.progress,
    required this.status,
  });
}

class ConversationModel {
  final String lawyer;
  final String caseNumber;
  final String time;
  final String preview;
  int unreadCount;
  final bool online;

  ConversationModel({
    required this.lawyer,
    required this.caseNumber,
    required this.time,
    required this.preview,
    required this.unreadCount,
    required this.online,
  });
}

class AppNotificationModel {
  final String title;
  final String subtitle;
  final String route;
  bool read;

  AppNotificationModel({
    required this.title,
    required this.subtitle,
    required this.route,
    this.read = false,
  });
}

class PaymentCardModel {
  final String brand;
  final String lastFour;
  final String holderName;
  final String expiry;
  final bool defaultCard;

  const PaymentCardModel({
    required this.brand,
    required this.lastFour,
    required this.holderName,
    required this.expiry,
    this.defaultCard = false,
  });

  PaymentCardModel copyWith({bool? defaultCard}) {
    return PaymentCardModel(
      brand: brand,
      lastFour: lastFour,
      holderName: holderName,
      expiry: expiry,
      defaultCard: defaultCard ?? this.defaultCard,
    );
  }
}
