import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'chat_screen.dart';

class CaseDetailScreen extends StatelessWidget {
  const CaseDetailScreen({
    super.key,
    this.title = 'Divorcio Mutuo Acuerdo',
    this.lawyer = 'Lic. Alejandro Garcia',
  });
  final String title;
  final String lawyer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalle del Caso',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Expediente: #2023-00452',
                  style: TextStyle(color: AppColors.slate),
                ),
                const SizedBox(height: 24),
                ...[
                  const _TimelineItem(
                    done: true,
                    title: 'Caso abierto',
                    subtitle: '12 Oct, 2023 · 09:30 AM',
                  ),
                  const _TimelineItem(
                    done: true,
                    title: 'Documentación revisada',
                    subtitle: '15 Oct, 2023 · 14:15 PM',
                  ),
                  const _TimelineItem(
                    progress: true,
                    title: 'En espera de firma',
                    subtitle: 'Pendiente de validación por notario',
                  ),
                  const _TimelineItem(
                    future: true,
                    title: 'Resolución final',
                    subtitle: 'Estimado para Nov 2023',
                    last: true,
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  'Documentos adjuntos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _document(),
                const SizedBox(height: 8),
                _document(
                  name: 'Anexo_Clausulas.pdf',
                  size: '1.8 MB · PDF',
                  color: AppColors.emerald,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            decoration: BoxDecoration(color: AppColors.surface),
            child: SafeArea(
              top: false,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Contactar Abogado'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _document({
    String name = 'Contrato_Servicios_Legales.pdf',
    String size = '2.4 MB · PDF',
    Color color = const Color(0xFFDC2626),
  }) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.line),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.picture_as_pdf_rounded, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                size,
                style: const TextStyle(fontSize: 12, color: AppColors.slate),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.download_rounded, color: AppColors.emerald),
        ),
      ],
    ),
  );
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    this.done = false,
    this.progress = false,
    this.future = false,
    this.last = false,
    required this.title,
    required this.subtitle,
  });
  final bool done, progress, future, last;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 78,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 42,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (!last)
                Positioned(
                  top: 36,
                  bottom: -4,
                  child: Container(
                    width: 2,
                    color: done ? AppColors.emerald : AppColors.line,
                  ),
                ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: done || progress
                      ? AppColors.emerald.withValues(alpha: .12)
                      : AppColors.line,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: done || progress
                        ? AppColors.emerald
                        : AppColors.line,
                    width: done ? 0 : 2,
                  ),
                ),
                child: done
                    ? const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: AppColors.emerald,
                      )
                    : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.slate),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
