import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});
  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  String filter = 'Activos (3)';
  final cases = const [
    (
      '#LX-2024-8841',
      'Derecho Civil',
      'Revisión cláusula de penalización en contrato de alquiler comercial',
      'Dra. Sofía Valenzuela',
      0.50,
      'Cita hoy 17:00 hs',
      AppColors.emerald,
    ),
    (
      '#1024',
      'Derecho Familiar',
      'Convenio regulador de guarda y custodia compartida',
      'Dr. Alejandro Prieto',
      0.60,
      'En negociación',
      AppColors.orange,
    ),
    (
      '#LX-2024-7910',
      'Derecho Laboral',
      'Impugnación de despido improcedente',
      'Dr. Marcos Alarcón',
      0.25,
      'Activo',
      AppColors.blue,
    ),
    (
      '#LX-2023-5120',
      'Derecho Bancario',
      'Reclamación cláusula suelo',
      'Dra. Valentina Cordero',
      1.00,
      'Finalizado con éxito',
      AppColors.slate,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mis casos', style: TextStyle(fontWeight: FontWeight.w800)),
            Text(
              '3 expedientes activos • 1 concluido',
              style: TextStyle(fontSize: 12, color: AppColors.slate),
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(118, 42),
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text(
              'Nuevo caso',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar expediente',
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children:
                  ['Todos (4)', 'Activos (3)', 'Finalizados (1)', 'Archivados']
                      .map(
                        (label) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: filter == label,
                            selectedColor: AppColors.emerald,
                            labelStyle: TextStyle(
                              color: filter == label
                                  ? AppColors.white
                                  : AppColors.slate,
                              fontWeight: FontWeight.w700,
                            ),
                            onSelected: (_) => setState(() => filter = label),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cases.length,
              itemBuilder: (_, index) {
                final item = cases[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.$1,
                                style: const TextStyle(
                                  color: AppColors.emerald,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: item.$7.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.$6,
                                style: TextStyle(
                                  color: item.$7,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.$2,
                          style: const TextStyle(
                            color: AppColors.slate,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.$3,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.$4,
                          style: const TextStyle(color: AppColors.slate),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: item.$5,
                            minHeight: 7,
                            color: AppColors.emerald,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(item.$5 * 100).round()}% • ${index == 0 ? 'Fase 2 de 4: Cita confirmada' : item.$6}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.slate,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.caseDetail,
                            ),
                            child: const Text(
                              'Ver expediente ->',
                              style: TextStyle(
                                color: AppColors.emerald,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
