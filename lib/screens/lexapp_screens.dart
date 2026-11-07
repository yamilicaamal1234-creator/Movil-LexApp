import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../services/app_data_service.dart';
import '../models/lexapp_models.dart';
import 'main_screen.dart';

class MainScreenRoute extends StatelessWidget {
  final int initialIndex;
  const MainScreenRoute({super.key, this.initialIndex = 0});
  @override
  Widget build(BuildContext context) => MainScreen(initialIndex: initialIndex);
}

class _Page extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  const _Page({required this.title, required this.child, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.navy,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: actions,
      ),
      body: SafeArea(child: child),
    );
  }
}

class LoginScreenLex extends StatefulWidget {
  const LoginScreenLex({super.key});
  @override
  State<LoginScreenLex> createState() => _LoginScreenLexState();
}

class _LoginScreenLexState extends State<LoginScreenLex> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.lock_outline,
                color: AppColors.emerald,
                size: 34,
              ),
              const SizedBox(height: 18),
              const Text(
                'Bienvenido a LexApp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 36),
              _darkField('Correo electrónico', Icons.mail_outline),
              const SizedBox(height: 16),
              TextField(
                obscureText: obscure,
                style: const TextStyle(color: AppColors.white),
                decoration: _inputDecoration('Contraseña', Icons.lock_outline)
                    .copyWith(
                      suffixIcon: IconButton(
                        color: AppColors.white,
                        icon: Icon(
                          obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.forgot),
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.otpLogin),
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFF334155))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'O continúa con',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFF334155))),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, color: AppColors.white),
                label: const Text(
                  'Google',
                  style: TextStyle(color: AppColors.white),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
              const SizedBox(height: 22),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.clientRegister),
                child: const Text(
                  '¿No tienes una cuenta?  Crear cuenta',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _darkField(String hint, IconData icon) => TextField(
    keyboardType: TextInputType.emailAddress,
    style: const TextStyle(color: AppColors.white),
    decoration: _inputDecoration(hint, icon),
  );

  InputDecoration _inputDecoration(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
        filled: true,
        fillColor: const Color(0xFF0F2744),
      );
}

class OtpScreen extends StatefulWidget {
  final String title;
  final String destination;
  final bool registrationStep;
  const OtpScreen({
    super.key,
    required this.title,
    required this.destination,
    this.registrationStep = false,
  });
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controllers = List.generate(6, (_) => TextEditingController());
  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Page(
    title: widget.title,
    actions: widget.registrationStep
        ? [
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Chip(
                label: Text(
                  'PASO 2 DE 2',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.slate,
                  ),
                ),
              ),
            ),
          ]
        : null,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (widget.registrationStep) ...[
            Row(
              children: List.generate(
                2,
                (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: index == 0 ? 6 : 0),
                    decoration: BoxDecoration(
                      color: AppColors.emerald,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          const Text(
            'Se envió un código temporal al correo ri••••••••@gmail.com',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.slate),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (i) => SizedBox(
                width: 48,
                height: 58,
                child: TextField(
                  controller: controllers[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.isNotEmpty && i < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  decoration: const InputDecoration(
                    counterText: '',
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Reenviar código en 00:46',
            style: TextStyle(color: AppColors.slate),
          ),
          TextButton(onPressed: () {}, child: const Text('Reenviar código')),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              widget.destination,
              (_) => false,
            ),
            child: Text(
              widget.destination == AppRoutes.newPassword
                  ? 'Verificar código'
                  : 'Verificar código',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver al inicio de sesión'),
          ),
        ],
      ),
    ),
  );
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: 'ricardo.hernandez@email.com',
    );
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (_) => false,
          ),
          child: const Text('< Volver al login'),
        ),
        leadingWidth: 130,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Chip(
              avatar: CircleAvatar(
                radius: 3,
                backgroundColor: AppColors.emerald,
              ),
              label: Text('Paso 1 de 3'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restart_alt_rounded,
                      size: 44,
                      color: AppColors.emerald,
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: 2,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.emerald,
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 18,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recupera tu contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingresa el correo electrónico asociado a tu cuenta y te enviaremos las instrucciones para restablecer tu contraseña.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.slate),
            ),
            const SizedBox(height: 28),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Correo electrónico',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Obligatorio',
                  style: TextStyle(color: AppColors.slate, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.slate),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Asegúrate de tener acceso a esta bandeja de entrada.',
                    style: TextStyle(color: AppColors.slate, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final valid = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(controller.text.trim());
                if (!valid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingresa un correo electrónico válido'),
                    ),
                  );
                  return;
                }
                Navigator.pushNamed(context, AppRoutes.recoveryOtp);
              },
              child: const Text('Enviar instrucciones ->'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              ),
              child: const Text('Volver a iniciar sesión'),
            ),
            const SizedBox(height: 16),
            Card(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.emerald, width: 4),
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.support_agent_outlined,
                          color: AppColors.emerald,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '¿Sin acceso a tu correo registrado? Contacta con nuestro equipo para iniciar la validación de identidad jurídica mediante protocolo eIDAS.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Solicitar soporte de identidad ->'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Cifrado de alta seguridad de 256 bits • Cumplimiento RGPD & eIDAS',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.slate, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Crea una nueva contraseña',
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Nueva contraseña'),
          ),
          const SizedBox(height: 14),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirmar nueva contraseña',
            ),
          ),
          const SizedBox(height: 18),
          const LinearProgressIndicator(
            value: .75,
            minHeight: 7,
            color: AppColors.emerald,
          ),
          const SizedBox(height: 12),
          const Text(
            '✓ Mínimo 8 caracteres\n✓ Una letra mayúscula\n✓ Número\n✓ Carácter especial',
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Contraseña actualizada'),
                  content: const Text('Tu contraseña se guardó correctamente.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Volver a iniciar sesión'),
                    ),
                  ],
                ),
              );
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              }
            },
            child: const Text('Guardar nueva contraseña'),
          ),
        ],
      ),
    ),
  );
}

class LawyerWebScreen extends StatelessWidget {
  const LawyerWebScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page(
    title: 'LexApp para Abogados',
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.desktop_windows_outlined,
            size: 96,
            color: AppColors.emerald,
          ),
          const SizedBox(height: 20),
          const Text(
            'LexApp para Abogados está optimizado para la plataforma Web',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ingresa desde tu ordenador para gestionar tus casos con todas las herramientas disponibles.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.slate),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Ir a LexApp Web'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () {}, child: const Text('Copiar enlace')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    ),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _accepted = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _hasLength => _passwordController.text.length >= 8;
  bool get _hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _passwordsMatch =>
      _confirmController.text.isNotEmpty &&
      _confirmController.text == _passwordController.text;

  void _submit() {
    final email = _emailController.text.trim();
    final emailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    String? error;
    if (_nameController.text.trim().isEmpty) {
      error = 'Ingresa tu nombre completo.';
    } else if (!emailValid) {
      error = 'Ingresa un correo electrónico válido.';
    } else if (!_hasLength || !_hasUppercase || !_hasNumber) {
      error = 'La contraseña debe cumplir todos los requisitos.';
    } else if (!_passwordsMatch) {
      error = 'Las contraseñas no coinciden.';
    } else if (!_accepted) {
      error = 'Acepta los términos y la política de privacidad.';
    }
    setState(() => _error = error);
    if (error == null) {
      Navigator.pushNamed(context, AppRoutes.registerOtp);
    }
  }

  void _showLegal(String title) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            const Text(
              'Documento informativo de LexApp. Este contenido es una simulación de la política correspondiente.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.navy,
                    ),
                    label: const Text(
                      'Volver',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'PASO 1 DE 2',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F8F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: AppColors.emerald,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'REGISTRO CLIENTE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Empieza a gestionar tus trámites y servicios jurídicos de forma 100% digital y remota.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.slate,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              _label('Nombre completo'),
              _textField(
                controller: _nameController,
                hint: 'Ej. Carlos Mendoza',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _label('Correo electrónico'),
              _textField(
                controller: _emailController,
                hint: 'ejemplo@correo.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: AppColors.slate),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Te enviaremos la confirmación de tus trámites',
                      style: TextStyle(fontSize: 12, color: AppColors.slate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _label('Contraseña')),
                  const Text(
                    'Mín. 8 caracteres',
                    style: TextStyle(fontSize: 12, color: AppColors.slate),
                  ),
                ],
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (_) => setState(() {}),
                decoration: _inputDecoration(Icons.lock_outline, '••••••••')
                    .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.slate,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _validationChip('8+ letras', _hasLength),
                  _validationChip('Mayúscula', _hasUppercase),
                  _validationChip('Número', _hasNumber),
                ],
              ),
              const SizedBox(height: 16),
              _label('Confirmar contraseña'),
              TextField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                onChanged: (_) => setState(() {}),
                decoration: _inputDecoration(Icons.lock_outline, '••••••••')
                    .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.slate,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
              ),
              if (_confirmController.text.isNotEmpty) ...[
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      _passwordsMatch
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      size: 15,
                      color: _passwordsMatch
                          ? AppColors.emerald
                          : AppColors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _passwordsMatch
                          ? 'Las contraseñas coinciden'
                          : 'Las contraseñas no coinciden',
                      style: TextStyle(
                        fontSize: 12,
                        color: _passwordsMatch
                            ? AppColors.emerald
                            : AppColors.red,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _accepted,
                      activeColor: AppColors.emerald,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) =>
                          setState(() => _accepted = value ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: AppColors.slate,
                        ),
                        children: [
                          const TextSpan(text: 'Acepto los '),
                          TextSpan(
                            text: 'Términos de Servicio',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  _showLegal('Términos de Servicio'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                              color: AppColors.navy,
                            ),
                          ),
                          const TextSpan(text: ' y la '),
                          TextSpan(
                            text: 'Política de Privacidad',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  _showLegal('Política de Privacidad'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                              color: AppColors.navy,
                            ),
                          ),
                          const TextSpan(text: ' de LexApp.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(fontSize: 12, color: AppColors.red),
                ),
              ],
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Crear cuenta ->',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'O CONTINÚA CON',
                      style: TextStyle(fontSize: 11, color: AppColors.slate),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(color: AppColors.border),
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'G',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Continuar con Google',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: AppColors.slate),
                      children: [
                        TextSpan(text: '¿Ya tienes una cuenta? '),
                        TextSpan(
                          text: 'Inicia sesión',
                          style: TextStyle(
                            color: AppColors.emerald,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF8F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: AppColors.emerald,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Datos protegidos con cifrado de grado judicial de 256 bits',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: AppColors.slate),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(icon, hint),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.slate),
      prefixIcon: Icon(icon, color: AppColors.slate, size: 20),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _validationChip(String label, bool valid) {
    final color = valid ? AppColors.emerald : AppColors.slate;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: valid ? const Color(0xFFE6F8F1) : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: valid ? AppColors.emerald : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            valid ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataService>(
      builder: (context, data, _) {
        return _Page(
          title: 'Notificaciones',
          actions: [
            TextButton(
              onPressed: data.notifications.isEmpty
                  ? null
                  : data.markAllNotificationsRead,
              child: const Text('Marcar todas como leídas'),
            ),
          ],
          child: data.notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: AppColors.slate,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No tienes notificaciones nuevas',
                        style: TextStyle(
                          color: AppColors.slate,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: data.notifications.map((notification) {
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0x1A00B87B),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: AppColors.emerald,
                          ),
                        ),
                        title: Text(
                          notification.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(notification.subtitle),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          data.openNotification(notification);
                          Navigator.pushNamed(context, notification.route);
                        },
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}

class SearchLawyerScreen extends StatelessWidget {
  const SearchLawyerScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Buscar abogado',
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: '¿Qué tipo de ayuda legal necesitas?',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _Chip('Todas', true),
              _Chip('Civil'),
              _Chip('Laboral'),
              _Chip('Penal'),
              _Chip('Familiar'),
              _Chip('Administrativo'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(2, (i) => _lawyerCard(context, i)),
      ],
    ),
  );

  Widget _lawyerCard(BuildContext context, int i) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.border,
                child: Icon(
                  i == 0 ? Icons.person_outline : Icons.person_2_outlined,
                  color: AppColors.navy,
                  size: 34,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i == 0 ? 'Dra. Sofía Valenzuela' : 'Lic. María López',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      '✓ Verificación colegial',
                      style: TextStyle(color: AppColors.emerald, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            i == 0
                ? 'Derecho Civil • 8 años • ★ 4.9'
                : 'Derecho Laboral • 6 años • ★ 4.8',
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${i == 0 ? '65' : '58'} MXN',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.lawyerProfile),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 44),
                ),
                child: const Text('Ver perfil'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  const _Chip(this.label, [this.selected = false]);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.emerald,
      labelStyle: TextStyle(
        color: selected ? AppColors.white : AppColors.slate,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class LawyerProfileScreen extends StatelessWidget {
  const LawyerProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Perfil del abogado',
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(radius: 46, child: Icon(Icons.person, size: 54)),
        const SizedBox(height: 12),
        const Text(
          'Dra. Sofía Valenzuela',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const Text(
          'Derecho Civil • Cédula 8841',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.slate),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Universidad Nacional Autónoma\n8 años de experiencia\nContratos, arrendamiento, familia y litigios civiles.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Disponible hoy para videoconsulta',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.contract),
          child: const Text(r'Contratar asesoría ($65 MXN)'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.chat),
          child: const Text('Enviar mensaje preliminar'),
        ),
      ],
    ),
  );
}

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});
  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  String selected = 'Videoconsulta telemática';
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Solicitar asesoría',
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Dra. Sofía Valenzuela',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: selected,
          items: const [
            DropdownMenuItem(
              value: 'Videoconsulta telemática',
              child: Text(r'Videoconsulta (45 min, $65 MXN)'),
            ),
            DropdownMenuItem(
              value: 'Revisión contractual',
              child: Text(r'Revisión contractual ($95 MXN)'),
            ),
            DropdownMenuItem(
              value: 'Consulta escrita',
              child: Text(r'Consulta escrita ($45 MXN)'),
            ),
          ],
          onChanged: (value) => setState(() => selected = value ?? selected),
        ),
        const SizedBox(height: 14),
        const TextField(
          maxLines: 5,
          decoration: InputDecoration(labelText: 'Describe tu necesidad legal'),
        ),
        const SizedBox(height: 14),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _PriceRow('Honorarios', r'$65.00 MXN'),
                _PriceRow('Custodia LexApp Escrow', r'$0.00 MXN'),
                _PriceRow('IVA 16%', r'$10.40 MXN'),
                Divider(),
                _PriceRow('Total', r'$75.40 MXN', bold: true),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '🔒 Tu pago permanece protegido en LexApp Escrow hasta confirmar el servicio.',
          style: TextStyle(color: AppColors.slate),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.payment),
          child: const Text('Continuar al pago seguro'),
        ),
      ],
    ),
  );
}

class _PriceRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _PriceRow(this.label, this.value, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Pago seguro',
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'SSL / PCI-DSS certificados',
          style: TextStyle(
            color: AppColors.emerald,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Total a pagar: \$75.40 MXN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Número de tarjeta',
            prefixIcon: Icon(Icons.credit_card),
          ),
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: 'Nombre del titular'),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: TextField(decoration: InputDecoration(labelText: 'MM/AA')),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'CVC'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          value: true,
          onChanged: (_) {},
          title: const Text('Guardar tarjeta de forma segura'),
        ),
        const Text(
          'Si el letrado no asiste, puedes solicitar reembolso.',
          style: TextStyle(color: AppColors.slate),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.confirmation,
            (route) => route.isFirst,
          ),
          child: const Text('Pagar ahora'),
        ),
      ],
    ),
  );
}

class AdditionalChargeScreen extends StatelessWidget {
  const AdditionalChargeScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Cobro adicional',
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  Text('Caso #1024', style: TextStyle(color: AppColors.slate)),
                  SizedBox(height: 10),
                  Text(
                    'Revisión y elaboración de documentación adicional',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '\$1,500.00 MXN',
                    style: TextStyle(
                      fontSize: 26,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.payment),
            child: const Text('Continuar al pago'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.caseDetail),
            child: const Text('Volver al caso'),
          ),
        ],
      ),
    ),
  );
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Contratación confirmada',
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0x1A00B87B),
            child: Icon(Icons.check_circle, size: 62, color: AppColors.emerald),
          ),
          const SizedBox(height: 18),
          const Text(
            '¡Contratación confirmada!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Expediente #LX-2024-8841',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text('Dra. Sofía Valenzuela'),
                  SizedBox(height: 4),
                  Text('Videoconsulta telemática • \$75.40 MXN'),
                  SizedBox(height: 10),
                  Chip(
                    label: Text(
                      'Pago confirmado',
                      style: TextStyle(color: AppColors.white),
                    ),
                    backgroundColor: AppColors.emerald,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.caseDetail),
            child: const Text('Ver mi caso'),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.shell,
              (_) => false,
            ),
            child: const Text('Volver al inicio'),
          ),
        ],
      ),
    ),
  );
}

class CaseDetailLexScreen extends StatelessWidget {
  const CaseDetailLexScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Caso #LX-2024-8841',
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppColors.emerald,
          child: ListTile(
            textColor: AppColors.white,
            iconColor: AppColors.white,
            leading: const Icon(Icons.videocam_outlined),
            title: const Text('Videollamada hoy a las 17:00'),
            trailing: const Text(
              'Unirse',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, AppRoutes.waitingRoom),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              'Dra. Sofía Valenzuela',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('Derecho Civil • Abogada asignada'),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Línea de tiempo procesal',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 14),
                _Timeline('Caso abierto'),
                _Timeline('Documentación revisada'),
                _Timeline('Propuesta aceptada'),
                _Timeline('Cita telemática programada'),
                _Timeline('Resolución final', active: false),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.documents),
          icon: const Icon(Icons.folder_open_outlined),
          label: const Text('Ver documentos'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.chat),
          icon: const Icon(Icons.chat_outlined),
          label: const Text('Contactar abogada'),
        ),
      ],
    ),
  );
}

class _Timeline extends StatelessWidget {
  final String label;
  final bool active;
  const _Timeline(this.label, {this.active = true});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(
          active ? Icons.check_circle : Icons.radio_button_unchecked,
          color: active ? AppColors.emerald : AppColors.slate,
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    ),
  );
}

class CaseDocumentsScreen extends StatefulWidget {
  const CaseDocumentsScreen({super.key});
  @override
  State<CaseDocumentsScreen> createState() => _CaseDocumentsScreenState();
}

class _CaseDocumentsScreenState extends State<CaseDocumentsScreen> {
  final List<PlatformFile> _uploadedFiles = [];

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      withData: false,
      withReadStream: false,
    );
    if (!mounted || result == null || result.files.isEmpty) return;
    setState(() => _uploadedFiles.insertAll(0, result.files));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${result.files.length} archivo${result.files.length == 1 ? '' : 's'} agregado${result.files.length == 1 ? '' : 's'} al expediente',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _Page(
    title: '#LX-2024-8841 • Documentos',
    actions: [
      IconButton(onPressed: _pickDocument, icon: const Icon(Icons.add)),
    ],
    child: Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              _Chip('Todos', true),
              _Chip('Contratos'),
              _Chip('Identificación'),
              _Chip('Legal'),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _document(context, 'adenda_clausula_penal.pdf', true),
              _document(context, 'contrato_arrendamiento.pdf', false),
              _document(context, 'identificacion_cliente.pdf', false),
              for (final file in _uploadedFiles) _uploadedDocument(file),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton.icon(
            onPressed: _pickDocument,
            icon: const Icon(Icons.upload_file),
            label: const Text('+ Subir nuevo documento'),
          ),
        ),
      ],
    ),
  );

  Widget _uploadedDocument(PlatformFile file) {
    final bytes = file.size;
    final size = bytes < 1024
        ? '$bytes B'
        : bytes < 1024 * 1024
        ? '${(bytes / 1024).toStringAsFixed(1)} KB'
        : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.attach_file_rounded,
          color: AppColors.emerald,
        ),
        title: Text(
          file.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text('$size • Archivo agregado'),
        trailing: const Icon(
          Icons.check_circle_rounded,
          color: AppColors.emerald,
        ),
      ),
    );
  }

  Widget _document(BuildContext context, String name, bool pending) => Card(
    child: ListTile(
      leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.red),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: pending
          ? const Text(
              'Pendiente de tu firma',
              style: TextStyle(color: AppColors.red),
            )
          : null,
      trailing: pending
          ? TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.signature),
              child: const Text('Firmar documento'),
            )
          : null,
    ),
  );
}

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});
  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final points = <Offset>[];
  bool legalAccepted = false;
  String method = 'Trazo en pantalla';
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Firma digital',
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'adenda_clausula_penal.pdf',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: method,
          items: const [
            DropdownMenuItem(
              value: 'Trazo en pantalla',
              child: Text('Trazo en pantalla'),
            ),
            DropdownMenuItem(value: 'SMS OTP', child: Text('SMS OTP')),
          ],
          onChanged: (value) => setState(() => method = value ?? method),
        ),
        const SizedBox(height: 12),
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() => points.add(details.localPosition));
            },
            onPanEnd: (_) => points.add(const Offset(-1, -1)),
            child: CustomPaint(
              painter: _SignaturePainter(points),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: legalAccepted,
          onChanged: (value) => setState(() => legalAccepted = value ?? false),
          title: Text('Acepto el marco legal eIDAS para esta firma digital.'),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        ElevatedButton(
          onPressed: legalAccepted
              ? () async {
                  await showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: const Text('Documento firmado correctamente'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Aceptar'),
                        ),
                      ],
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              : null,
          child: const Text('Firmar documento'),
        ),
      ],
    ),
  );
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  _SignaturePainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navy
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < points.length - 1; i++) {
      if (points[i].dx >= 0 && points[i + 1].dx >= 0) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}

class ChatScreenLex extends StatefulWidget {
  const ChatScreenLex({super.key});
  @override
  State<ChatScreenLex> createState() => _ChatScreenLexState();
}

class _ChatScreenLexState extends State<ChatScreenLex> {
  final controller = TextEditingController();
  final messages = <Map<String, dynamic>>[
    {'text': 'Hola Ricardo, revisé tu consulta.', 'mine': false},
    {'text': 'Gracias, doctora. Tengo el contrato listo.', 'mine': true},
    {
      'text': 'Perfecto. Puedes subirlo desde el expediente.',
      'mine': false,
      'file': true,
    },
  ];
  static final phoneOrEmail = RegExp(
    r'(?:\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b)|(?:\b\d{10}\b)',
    caseSensitive: false,
  );

  bool _readMarked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_readMarked) {
      _readMarked = true;
      context.read<AppDataService>().markConversationRead(0);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    if (phoneOrEmail.hasMatch(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por seguridad de tu caso, no está permitido compartir datos personales o de contacto externos dentro de la plataforma',
          ),
        ),
      );
      return;
    }
    setState(() {
      messages.add({'text': text, 'mine': true});
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dra. Sofía Valenzuela',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Text(
              'En línea',
              style: TextStyle(fontSize: 12, color: AppColors.emerald),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Llamada de audio',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.waitingRoom,
              arguments: false,
            ),
            icon: const Icon(Icons.call_outlined),
          ),
          IconButton(
            tooltip: 'Videollamada',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.waitingRoom,
              arguments: true,
            ),
            icon: const Icon(Icons.videocam_outlined),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.caseDetail),
            child: const Text('Ver caso'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFE8F7F1),
            padding: const EdgeInsets.all(10),
            child: const Text(
              '🔒 Cifrado de extremo a extremo • Secreto profesional',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.emerald,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final message = messages[i];
                final mine = message['mine'] as bool;
                return Align(
                  alignment: mine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: mine ? AppColors.emerald : AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: mine ? AppColors.emerald : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'] as String,
                          style: TextStyle(
                            color: mine ? AppColors.white : AppColors.navy,
                          ),
                        ),
                        if (message['file'] == true) ...[
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.documents,
                            ),
                            child: const Text('Revisar y firmar'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final result = await FilePicker.pickFiles();
                      if (!mounted) return;
                      if (result == null || result.files.isEmpty) return;
                      final file = result.files.single;
                      if (!mounted) return;
                      setState(() {
                        messages.add({
                          'text': file.name,
                          'mine': true,
                          'file': true,
                        });
                      });
                      if (!mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Archivo adjunto: ${file.name}'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.emerald,
                    child: IconButton(
                      onPressed: send,
                      icon: const Icon(Icons.send, color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaitingRoomScreen extends StatefulWidget {
  final bool video;
  const WaitingRoomScreen({super.key, this.video = true});
  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  CameraController? _cameraController;
  bool mic = true;
  bool camera = true;
  String? _permissionMessage;

  @override
  void initState() {
    super.initState();
    _requestMediaPermissions();
  }

  Future<void> _requestMediaPermissions() async {
    final micStatus = await Permission.microphone.request();
    mic = micStatus.isGranted;

    if (widget.video) {
      final cameraStatus = await Permission.camera.request();
      camera = cameraStatus.isGranted;
      if (camera) await _startCamera();
    } else {
      camera = false;
    }

    if (!mounted) return;
    setState(() {
      _permissionMessage = (!micStatus.isGranted)
          ? 'Activa el permiso de micrófono para hablar.'
          : (widget.video && !camera)
          ? 'Activa el permiso de cámara para compartir video.'
          : null;
    });
  }

  Future<void> _startCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final preferred = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        preferred,
        ResolutionPreset.medium,
        enableAudio: mic,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      _cameraController?.dispose();
      _cameraController = controller;
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      setState(() => _permissionMessage = 'No fue posible iniciar la cámara.');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Page(
    title: 'Sala de espera',
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 48)),
        const SizedBox(height: 10),
        const Text(
          'Dra. Sofía Valenzuela',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const Text(
          'Caso #LX-2024-8841 • Hoy 17:00',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child:
              widget.video &&
                  camera &&
                  _cameraController?.value.isInitialized == true
              ? CameraPreview(_cameraController!)
              : Center(
                  child: Icon(
                    widget.video ? Icons.videocam_off_outlined : Icons.call,
                    size: 80,
                    color: AppColors.white,
                  ),
                ),
        ),
        if (_permissionMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            _permissionMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.red),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controlButton(
              mic ? Icons.mic : Icons.mic_off,
              'Micrófono',
              mic,
              () => setState(() => mic = !mic),
            ),
            const SizedBox(width: 16),
            if (widget.video)
              _controlButton(
                camera ? Icons.videocam : Icons.videocam_off,
                'Cámara',
                camera,
                () async {
                  if (!camera) {
                    final status = await Permission.camera.request();
                    if (status.isGranted) {
                      await _startCamera();
                    }
                  } else {
                    await _cameraController?.dispose();
                    _cameraController = null;
                  }
                  if (mounted) {
                    setState(() => camera = _cameraController != null);
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'El abogado ya está en la reunión',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.emerald,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.videoCall,
            arguments: widget.video,
          ),
          child: Text(
            widget.video
                ? 'Unirse a la videollamada'
                : 'Unirse a la llamada de audio',
          ),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    ),
  );

  Widget _controlButton(
    IconData icon,
    String label,
    bool active,
    VoidCallback onPressed,
  ) => Column(
    children: [
      CircleAvatar(
        radius: 26,
        backgroundColor: active ? AppColors.emerald : AppColors.slate,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: AppColors.white),
        ),
      ),
      const SizedBox(height: 6),
      Text(label),
    ],
  );
}

class VideoCallScreen extends StatefulWidget {
  final bool video;
  const VideoCallScreen({super.key, this.video = true});
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  CameraController? _cameraController;
  bool mic = true;
  bool camera = true;

  @override
  void initState() {
    super.initState();
    _startMedia();
  }

  Future<void> _startMedia() async {
    mic = (await Permission.microphone.request()).isGranted;
    if (widget.video) {
      camera = (await Permission.camera.request()).isGranted;
      if (camera) await _startCamera();
    } else {
      camera = false;
    }
    if (mounted) setState(() {});
  }

  Future<void> _startCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final preferred = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        preferred,
        ResolutionPreset.medium,
        enableAudio: mic,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      _cameraController?.dispose();
      _cameraController = controller;
      setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF071324),
    body: SafeArea(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(radius: 58, child: Icon(Icons.person, size: 72)),
                SizedBox(height: 14),
                Text(
                  'Dra. Sofía Valenzuela',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Text('00:02:18', style: TextStyle(color: Color(0xB3FFFFFF))),
              ],
            ),
          ),
          if (widget.video)
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                width: 110,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.navySoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.white),
                ),
                clipBehavior: Clip.antiAlias,
                child: camera && _cameraController?.value.isInitialized == true
                    ? CameraPreview(_cameraController!)
                    : const Icon(
                        Icons.person_outline,
                        color: AppColors.white,
                        size: 54,
                      ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _callButton(
                  mic ? Icons.mic : Icons.mic_off,
                  () => setState(() => mic = !mic),
                ),
                if (widget.video)
                  _callButton(
                    camera ? Icons.videocam : Icons.videocam_off,
                    () async {
                      if (!camera) {
                        final status = await Permission.camera.request();
                        if (status.isGranted) {
                          await _startCamera();
                        }
                      } else {
                        await _cameraController?.dispose();
                        _cameraController = null;
                      }
                      if (mounted) {
                        setState(() => camera = _cameraController != null);
                      }
                    },
                  ),
                _callButton(
                  Icons.description_outlined,
                  () => Navigator.pushNamed(context, AppRoutes.documents),
                ),
                _callButton(
                  Icons.call_end,
                  () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.caseDetail,
                    (route) => route.isFirst,
                  ),
                  red: true,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _callButton(
    IconData icon,
    VoidCallback onPressed, {
    bool red = false,
  }) => CircleAvatar(
    radius: 25,
    backgroundColor: red ? AppColors.red : AppColors.navySoft,
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.white),
    ),
  );
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataService>(
      builder: (context, data, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              label: const Text('Volver'),
            ),
            leadingWidth: 110,
            title: const Text(
              'Métodos de pago',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: Icon(
                    Icons.shield,
                    size: 16,
                    color: AppColors.emerald,
                  ),
                  label: Text(
                    'PCI-DSS',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.emerald),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pago seguro',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Tus datos están protegidos con cifrado de grado bancario',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < data.paymentCards.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PaymentCardTile(
                    card: data.paymentCards[i],
                    onDefault: () => data.setDefaultPaymentCard(i),
                    onDelete: () => _confirmDelete(context, data, i),
                  ),
                ),
              ElevatedButton.icon(
                onPressed: () => _showAddCard(context, data),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Agregar nueva tarjeta'),
              ),
              const SizedBox(height: 22),
              const Text(
                'Tus últimos movimientos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _paymentMovement(
                context,
                'A tu favor',
                'Consulta jurídica • 28 Oct 2026',
                '-\$ 850 MXN',
                AppColors.red,
              ),
              _paymentMovement(
                context,
                'Depósito reembolsado',
                'Caso #LX-2024-8841 • 22 Oct 2026',
                '+\$ 2,400 MXN',
                AppColors.emerald,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF8F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: AppColors.emerald,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Certificación ISO/IEC 27001',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.slate,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentMovement(
    BuildContext context,
    String title,
    String subtitle,
    String amount,
    Color amountColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8F8F2),
          child: Icon(Icons.receipt_long_outlined, color: AppColors.emerald),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.w800, color: amountColor),
        ),
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text('$subtitle\n\nMonto: $amount\nEstado: Completado'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppDataService data,
    int index,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar tarjeta'),
        content: const Text('¿Deseas eliminar esta tarjeta de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      data.removePaymentCard(index);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tarjeta eliminada')));
      }
    }
  }

  Future<void> _showAddCard(BuildContext context, AppDataService data) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddPaymentCardSheet(data: data),
    );
  }
}

class _PaymentCardTile extends StatelessWidget {
  final PaymentCardModel card;
  final VoidCallback onDefault;
  final VoidCallback onDelete;
  const _PaymentCardTile({
    required this.card,
    required this.onDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: card.brand == 'VISA'
            ? const LinearGradient(
                colors: [Color(0xFF087A57), Color(0xFF00A77A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF12345E), Color(0xFF315C82)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                card.brand,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                color: AppColors.white,
                onSelected: (value) {
                  if (value == 'default') onDefault();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'default', child: Text('Predeterminar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
                icon: const Icon(Icons.more_vert, color: AppColors.white),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '••••  ••••  ••••  ${card.lastFour}',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 17,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  card.holderName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                card.expiry,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (card.defaultCard) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Predeterminada',
                style: TextStyle(
                  color: AppColors.emerald,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddPaymentCardSheet extends StatefulWidget {
  final AppDataService data;
  const _AddPaymentCardSheet({required this.data});
  @override
  State<_AddPaymentCardSheet> createState() => _AddPaymentCardSheetState();
}

class _AddPaymentCardSheetState extends State<_AddPaymentCardSheet> {
  final name = TextEditingController();
  final number = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();
  bool showCvv = false;
  String? error;

  @override
  void dispose() {
    name.dispose();
    number.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  String get digits => number.text.replaceAll(RegExp(r'\D'), '');

  void save() {
    final cleanExpiry = expiry.text.trim();
    final validExpiry = RegExp(
      r'^(0[1-9]|1[0-2])\/\d{2}$',
    ).hasMatch(cleanExpiry);
    if (name.text.trim().isEmpty ||
        digits.length < 12 ||
        !validExpiry ||
        cvv.text.length < 3) {
      setState(() => error = 'Completa todos los datos correctamente.');
      return;
    }
    final brand = digits.startsWith('4')
        ? 'VISA'
        : (digits.startsWith('5') ? 'MASTERCARD' : 'TARJETA');
    widget.data.addPaymentCard(
      PaymentCardModel(
        brand: brand,
        lastFour: digits.substring(digits.length - 4),
        holderName: name.text.trim().toUpperCase(),
        expiry: cleanExpiry,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarjeta agregada correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Agregar tarjeta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  tooltip: 'Cerrar',
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: name,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Nombre del titular',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: number,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
              ],
              decoration: const InputDecoration(
                labelText: 'Número de tarjeta',
                prefixIcon: Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiry,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    onChanged: (value) {
                      if (value.length == 4) {
                        expiry.text =
                            '${value.substring(0, 2)}/${value.substring(2)}';
                        expiry.selection = TextSelection.collapsed(
                          offset: expiry.text.length,
                        );
                      }
                    },
                    decoration: const InputDecoration(labelText: 'MM/AA'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: cvv,
                    obscureText: !showCvv,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => showCvv = !showCvv),
                        icon: Icon(
                          showCvv ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(error!, style: const TextStyle(color: AppColors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: save,
              child: const Text('Guardar tarjeta'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataService>(
      builder: (context, data, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              label: const Text('Volver'),
            ),
            leadingWidth: 110,
            title: const Text(
              'Configuración y Seguridad',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: Icon(
                    Icons.verified,
                    size: 16,
                    color: AppColors.emerald,
                  ),
                  label: Text(
                    '100% seguro',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCBEDE0)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.emerald),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tu cuenta cuenta con protección reforzada y cifrado de extremo a extremo.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.slate,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Cuenta',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Información personal'),
                      subtitle: Text(data.user.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showPersonalInfo(context, data),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.mail_outline,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Correo certificado'),
                      subtitle: Text(data.user.email),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showEmailChange(context, data),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Seguridad y autenticación',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.pin_outlined,
                        color: AppColors.emerald,
                      ),
                      title: const Text('PIN de seguridad'),
                      subtitle: Text(
                        data.pinEnabled
                            ? 'PIN configurado y activo'
                            : 'PIN desactivado',
                      ),
                      trailing: Switch(
                        value: data.pinEnabled,
                        onChanged: (value) async {
                          if (!value) {
                            data.updateSetting('pin', false);
                          } else {
                            await _showPinSetup(context, data);
                          }
                        },
                      ),
                      onTap: () => _showPinSetup(context, data),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.fingerprint,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Biometría / Face ID / Huella'),
                      value: data.biometricEnabled,
                      onChanged: (value) =>
                          data.updateSetting('biometric', value),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.lock_outline,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Autenticación reforzada para firma'),
                      value: data.strongSignatureAuth,
                      onChanged: (value) =>
                          data.updateSetting('strongSignature', value),
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.password_outlined,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Autenticación en dos pasos'),
                      value: data.twoFactorEnabled,
                      onChanged: (value) =>
                          data.updateSetting('twoFactor', value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Permisos del dispositivo',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _permissionTile(
                      context,
                      data,
                      icon: Icons.photo_camera_outlined,
                      title: 'Cámara',
                      key: 'camera',
                      value: data.cameraPermission,
                    ),
                    _permissionTile(
                      context,
                      data,
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación',
                      key: 'location',
                      value: data.locationPermission,
                    ),
                    _permissionTile(
                      context,
                      data,
                      icon: Icons.notifications_none_outlined,
                      title: 'Notificaciones',
                      key: 'deviceNotifications',
                      value: data.deviceNotificationsPermission,
                    ),
                    _permissionTile(
                      context,
                      data,
                      icon: Icons.folder_outlined,
                      title: 'Almacenamiento',
                      key: 'storage',
                      value: data.storagePermission,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Configuración de notificaciones',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _notificationSwitch(
                      data,
                      'Nuevos mensajes',
                      data.messageNotifications,
                      'messages',
                    ),
                    _notificationSwitch(
                      data,
                      'Actualizaciones de casos',
                      data.caseNotifications,
                      'cases',
                    ),
                    _notificationSwitch(
                      data,
                      'Solicitudes de firma',
                      data.signatureNotifications,
                      'signatures',
                    ),
                    _notificationSwitch(
                      data,
                      'Pagos y provisiones',
                      data.paymentNotifications,
                      'payments',
                    ),
                    _notificationSwitch(
                      data,
                      'Reuniones virtuales',
                      data.meetingNotifications,
                      'meetings',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Datos y privacidad',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.download_outlined,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Descargar mis datos'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _exportData(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.cleaning_services_outlined,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Limpiar caché'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmDataAction(
                        context,
                        'Limpiar caché',
                        'Se eliminará la caché temporal de la aplicación.',
                        'Caché limpiada correctamente',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.restore,
                        color: AppColors.emerald,
                      ),
                      title: const Text('Restaurar configuración'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmDataAction(
                        context,
                        'Restaurar configuración',
                        'Se restaurarán los ajustes predeterminados de seguridad.',
                        'Configuración restaurada',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: AppColors.red,
                      ),
                      title: const Text(
                        'Solicitar eliminación de cuenta',
                        style: TextStyle(color: AppColors.red),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmDataAction(
                        context,
                        'Eliminar cuenta',
                        'Esta acción requiere confirmación adicional y eliminará permanentemente tu cuenta.',
                        'Solicitud de eliminación registrada',
                        destructive: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Privacidad y cifrado de grado judicial · 256 bits',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.slate, fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationSwitch(
    AppDataService data,
    String title,
    bool value,
    String key,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (value) => data.updateSetting(key, value),
    );
  }

  Widget _permissionTile(
    BuildContext context,
    AppDataService data, {
    required IconData icon,
    required String title,
    required String key,
    required bool value,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.emerald),
      title: Text(title),
      subtitle: Text(value ? 'Permiso habilitado' : 'Permiso deshabilitado'),
      value: value,
      onChanged: (enabled) {
        data.updateSetting(key, enabled);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title ${enabled ? 'habilitado' : 'deshabilitado'}'),
          ),
        );
      },
    );
  }

  Future<void> _showPersonalInfo(
    BuildContext context,
    AppDataService data,
  ) async {
    final name = TextEditingController(text: data.user.name);
    final phone = TextEditingController(text: data.user.phone);
    final address = TextEditingController(text: data.user.address);
    final birthDate = TextEditingController(text: data.user.birthDate);
    final taxId = TextEditingController(text: data.user.taxId);
    String? error;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Información personal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close),
                          tooltip: 'Cerrar',
                        ),
                      ],
                    ),
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: address,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: birthDate,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      onTap: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: DateTime(1990, 5, 12),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selected != null) {
                          setSheetState(() {
                            birthDate.text =
                                '${selected.day.toString().padLeft(2, '0')}/'
                                '${selected.month.toString().padLeft(2, '0')}/'
                                '${selected.year}';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: taxId,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'RFC / Identificación',
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        error!,
                        style: const TextStyle(color: AppColors.red),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (name.text.trim().isEmpty ||
                            phone.text.trim().isEmpty ||
                            address.text.trim().isEmpty ||
                            birthDate.text.trim().isEmpty) {
                          setSheetState(() {
                            error = 'Completa todos los campos obligatorios.';
                          });
                          return;
                        }
                        data.updateProfile(
                          data.user.copyWith(
                            name: name.text.trim(),
                            phone: phone.text.trim(),
                            address: address.text.trim(),
                            birthDate: birthDate.text.trim(),
                            taxId: taxId.text.trim(),
                          ),
                        );
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Información personal actualizada'),
                          ),
                        );
                      },
                      child: const Text('Guardar cambios'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    name.dispose();
    phone.dispose();
    address.dispose();
    birthDate.dispose();
    taxId.dispose();
  }

  Future<void> _showEmailChange(
    BuildContext context,
    AppDataService data,
  ) async {
    final email = TextEditingController(text: data.user.email);
    final password = TextEditingController();
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Cambiar correo electrónico'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Nuevo correo',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña actual',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        error!,
                        style: const TextStyle(color: AppColors.red),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final validEmail = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email.text.trim());
                    if (!validEmail) {
                      setDialogState(() => error = 'Ingresa un correo válido.');
                    } else if (email.text.trim() == data.user.email) {
                      setDialogState(
                        () => error = 'Ingresa una dirección diferente.',
                      );
                    } else if (password.text.isEmpty) {
                      setDialogState(
                        () => error = 'Confirma tu contraseña actual.',
                      );
                    } else {
                      Navigator.pop(dialogContext);
                      await _showEmailOtp(context, data, email.text.trim());
                    }
                  },
                  child: const Text('Enviar código'),
                ),
              ],
            );
          },
        );
      },
    );
    email.dispose();
    password.dispose();
  }

  Future<void> _showEmailOtp(
    BuildContext context,
    AppDataService data,
    String newEmail,
  ) async {
    final otp = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Verifica tu correo'),
        content: TextField(
          controller: otp,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: const InputDecoration(
            labelText: 'Código de 6 dígitos',
            hintText: '123456',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, otp.text == '123456'),
            child: const Text('Verificar'),
          ),
        ],
      ),
    );
    otp.dispose();
    if (confirmed == true) {
      data.updateProfile(data.user.copyWith(email: newEmail));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo actualizado correctamente')),
        );
      }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código incorrecto. No se realizó el cambio.'),
        ),
      );
    }
  }

  Future<void> _showPinSetup(BuildContext context, AppDataService data) async {
    final current = TextEditingController();
    final pin = TextEditingController();
    final confirm = TextEditingController();
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(data.pinHash == null ? 'Crear PIN' : 'Cambiar PIN'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data.pinEnabled && data.pinHash != null)
                      TextField(
                        controller: current,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'PIN actual',
                        ),
                      ),
                    if (data.pinEnabled && data.pinHash != null)
                      const SizedBox(height: 10),
                    TextField(
                      controller: pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Nuevo PIN (4-6 dígitos)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: confirm,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Confirmar PIN',
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        error!,
                        style: const TextStyle(color: AppColors.red),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (data.pinEnabled &&
                        data.pinHash != null &&
                        !data.verifyPin(current.text)) {
                      setDialogState(
                        () => error = 'El PIN actual no es correcto.',
                      );
                      return;
                    }
                    if (!(pin.text.length == 4 || pin.text.length == 6)) {
                      setDialogState(
                        () => error = 'El PIN debe tener 4 o 6 dígitos.',
                      );
                      return;
                    }
                    if (pin.text != confirm.text) {
                      setDialogState(() => error = 'Los PIN no coinciden.');
                      return;
                    }
                    data.setPin(pin.text);
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PIN configurado correctamente'),
                      ),
                    );
                  },
                  child: const Text('Guardar PIN'),
                ),
              ],
            );
          },
        );
      },
    );
    current.dispose();
    pin.dispose();
    confirm.dispose();
  }

  Future<void> _exportData(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (context.mounted) Navigator.pop(context);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exportación de datos preparada')),
      );
    }
  }

  Future<void> _confirmDataAction(
    BuildContext context,
    String title,
    String message,
    String successMessage, {
    bool destructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: destructive
                ? ElevatedButton.styleFrom(backgroundColor: AppColors.red)
                : null,
            child: Text(destructive ? 'Confirmar solicitud' : 'Confirmar'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    }
  }
}
