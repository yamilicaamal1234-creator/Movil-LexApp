import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../services/app_data_service.dart';
import '../widgets/document_viewer_modal.dart';
import 'main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.emerald, width: 2),
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${context.watch<AppDataService>().user.name.trim().split(' ').first}',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Cliente verificado • Todo en orden',
                          style: TextStyle(
                            color: AppColors.emerald,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        Consumer<AppDataService>(
                          builder: (context, data, _) {
                            if (!data.hasUnreadNotifications) {
                              return const SizedBox.shrink();
                            }
                            return Positioned(
                              right: -1,
                              top: -1,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: AppColors.emerald,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.navySoft : AppColors.navy,
                  borderRadius: BorderRadius.circular(16),
                  border: isDark
                      ? Border.all(color: AppColors.darkBorder)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Encuentra tu abogado digital',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _HomeChip('Mercantil'),
                        _HomeChip('Laboral'),
                        _HomeChip('Inmobiliario'),
                        _HomeChip('Fiscal'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.search),
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Buscar abogado'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado actual',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                child: Icon(Icons.person, size: 34),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Próxima reunión virtual',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Dra. Elena Ramos • Hoy, 16:30 hs',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.darkSlate
                                            : AppColors.slate,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Videollamada en vivo',
                                      style: TextStyle(
                                        color: AppColors.emerald,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.waitingRoom,
                                ),
                                icon: const Icon(
                                  Icons.videocam_rounded,
                                  color: AppColors.emerald,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.waitingRoom,
                            ),
                            child: const Text('Entrar a la sala'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Casos en curso',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          _progress('LX-2024-8841', 0.85),
                          const SizedBox(height: 8),
                          _progress('Caso #1024', 0.40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: _quick(
                      context,
                      Icons.work_outline,
                      'Mis casos',
                      '2 activos',
                      AppRoutes.shell,
                      1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _quick(
                      context,
                      Icons.chat_bubble_outline,
                      'Mensajes',
                      '1 no leído',
                      AppRoutes.shell,
                      2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _quick(
                      context,
                      Icons.description_outlined,
                      'Documentos',
                      '1 por firmar',
                      AppRoutes.documents,
                      null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Actividad reciente',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  _activity(
                    context,
                    'Documento pendiente de firma',
                    'Urgente • Hace 12 min',
                    AppColors.red,
                    AppRoutes.signature,
                    'Firmar ahora',
                  ),
                  _activity(
                    context,
                    'Tienes un nuevo mensaje',
                    'Dra. Sofía Valenzuela',
                    AppColors.emerald,
                    AppRoutes.chat,
                    null,
                  ),
                  _activity(
                    context,
                    'Tu abogado envió un documento',
                    'adenda_modificacion_clausula_penal.pdf',
                    AppColors.blue,
                    AppRoutes.documents,
                    null,
                    onTapCustom: () => DocumentViewerModal.show(
                      context,
                      title: 'adenda_modificacion_clausula_penal.pdf',
                      subtitle: 'Documento legal de modificación',
                      docType: 'PDF',
                      allowSign: true,
                    ),
                  ),
                  _activity(
                    context,
                    'Pago confirmado',
                    '\$75.40 MXN • Folio LX-2024-1182',
                    AppColors.emerald,
                    AppRoutes.confirmation,
                    null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progress(String label, double value) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              color: AppColors.emerald,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 7,
          color: AppColors.emerald,
        ),
      ),
    ],
  );

  Widget _quick(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String route,
    int? tab,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        if (tab != null) {
          MainScreen.switchTab(context, tab);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        height: 112,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.emerald),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    theme.textTheme.bodyLarge?.color ??
                    (isDark ? AppColors.white : AppColors.navy),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkSlate : AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activity(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    String route,
    String? action, {
    VoidCallback? onTapCustom,
  }) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      onTap: onTapCustom ?? () => Navigator.pushNamed(context, route),
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(Icons.description_outlined, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSlate
              : AppColors.slate,
        ),
      ),
      trailing: action == null
          ? const Icon(Icons.chevron_right, size: 18)
          : TextButton(
              onPressed: onTapCustom ?? () => Navigator.pushNamed(context, route),
              child: Text(action),
            ),
    ),
  );
}

class _HomeChip extends StatelessWidget {
  final String label;
  const _HomeChip(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0x22FFFFFF),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0x55FFFFFF)),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
