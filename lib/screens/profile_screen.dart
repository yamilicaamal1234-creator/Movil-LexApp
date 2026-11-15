import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../services/app_data_service.dart';
import '../core/theme/theme_mode_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataService>(
      builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Perfil',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        child: Icon(Icons.person, size: 46),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.user.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.user.email,
                              style: TextStyle(
                                color: AppColors.slate,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Identidad eIDAS validada',
                                style: TextStyle(
                                  color: AppColors.emerald,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              '2 Casos activos • 1 En revisión',
                              style: TextStyle(
                                color: AppColors.slate,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _SectionTitle('Cuenta'),
              _option(
                context,
                Icons.person_outline,
                'Información personal',
                AppRoutes.security,
              ),
              _option(
                context,
                Icons.shield_outlined,
                'Seguridad',
                AppRoutes.security,
              ),
              _option(
                context,
                Icons.notifications_none,
                'Notificaciones',
                AppRoutes.security,
              ),
              const SizedBox(height: 12),
              const _SectionTitle('Apariencia'),
              Consumer<ThemeModeController>(
                builder: (context, themeController, _) {
                  final label = switch (themeController.themeMode) {
                    ThemeMode.light => 'Claro',
                    ThemeMode.dark => 'Oscuro',
                    ThemeMode.system => 'Predeterminado al sistema',
                  };
                  return Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      leading: const Icon(
                        Icons.palette_outlined,
                        color: AppColors.emerald,
                      ),
                      title: const Text(
                        'Modo de la aplicación',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(label),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showThemePicker(context, themeController),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              const _SectionTitle('Facturación'),
              _option(
                context,
                Icons.credit_card,
                'Métodos de pago',
                AppRoutes.paymentMethods,
              ),
              _option(
                context,
                Icons.lock_outline,
                'Privacidad',
                AppRoutes.security,
              ),
              const SizedBox(height: 12),
              const _SectionTitle('Soporte'),
              _option(context, Icons.help_outline, 'Ayuda y soporte', ''),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                ),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Certificación ISO/IEC 27001 • LexApp v2.4.1',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.slate, fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemePicker(
    BuildContext context,
    ThemeModeController themeController,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Modo de la aplicación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              _themeOption(
                sheetContext,
                themeController,
                ThemeMode.system,
                Icons.settings_suggest_outlined,
                'Predeterminado al sistema',
                'Usa la apariencia configurada en el dispositivo',
              ),
              _themeOption(
                sheetContext,
                themeController,
                ThemeMode.light,
                Icons.light_mode_outlined,
                'Modo claro',
                'Fondos claros y texto oscuro',
              ),
              _themeOption(
                sheetContext,
                themeController,
                ThemeMode.dark,
                Icons.dark_mode_outlined,
                'Modo oscuro',
                'Fondos oscuros y texto claro',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeOption(
    BuildContext sheetContext,
    ThemeModeController themeController,
    ThemeMode mode,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final selected = themeController.themeMode == mode;
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? AppColors.emerald : AppColors.slate,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: selected
            ? const Icon(Icons.check_circle, color: AppColors.emerald)
            : null,
        onTap: () async {
          await themeController.setThemeMode(mode);
          if (sheetContext.mounted) Navigator.pop(sheetContext);
        },
      ),
    );
  }

  Widget _option(
    BuildContext context,
    IconData icon,
    String label,
    String? route,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(icon, color: AppColors.emerald),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right),
        onTap: route == null || route.isEmpty
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label disponible próximamente')),
                );
              }
            : () => Navigator.pushNamed(context, route),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
