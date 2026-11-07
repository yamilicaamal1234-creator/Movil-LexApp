class ContactValidator {
  static final RegExp phoneRegex = RegExp(
    r'(?:\+?\d{1,3}[\s.-]?)?(?:\(?\d{2,4}\)?[\s.-]?)\d{3,4}[\s.-]?\d{4}|\b\d{10,15}\b',
  );
  static final RegExp emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  static String? findRestrictedContact(String text) {
    if (emailRegex.hasMatch(text)) {
      return 'No está permitido enviar correos directos por este canal.';
    }
    if (phoneRegex.hasMatch(text)) {
      return 'No está permitido enviar números telefónicos por este canal.';
    }
    return null;
  }
}
