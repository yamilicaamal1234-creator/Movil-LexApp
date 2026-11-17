import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../services/api_service.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});
  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _solicitudes = [];
  List<Map<String, dynamic>> _propuestas = [];
  bool _loading = false;
  String? _error;

  final List<Map<String, dynamic>> _mockActiveCases = [
    {
      'numero': '#LX-2024-8841',
      'area': 'Derecho Civil',
      'asunto': 'Revisión cláusula de penalización en contrato de alquiler comercial',
      'abogado': 'Dra. Sofía Valenzuela',
      'progreso': 0.50,
      'estado': 'Cita hoy 17:00 hs',
      'color': AppColors.emerald,
    },
    {
      'numero': '#1024',
      'area': 'Derecho Familiar',
      'asunto': 'Convenio regulador de guarda y custodia compartida',
      'abogado': 'Dr. Alejandro Prieto',
      'progreso': 0.60,
      'estado': 'En negociación',
      'color': AppColors.orange,
    },
    {
      'numero': '#LX-2024-7910',
      'area': 'Derecho Laboral',
      'asunto': 'Impugnación de despido improcedente',
      'abogado': 'Dr. Marcos Alarcón',
      'progreso': 0.25,
      'estado': 'Activo',
      'color': AppColors.blue,
    },
    {
      'numero': '#LX-2023-5120',
      'area': 'Derecho Bancario',
      'asunto': 'Reclamación cláusula suelo',
      'abogado': 'Dra. Valentina Cordero',
      'progreso': 1.00,
      'estado': 'Finalizado con éxito',
      'color': AppColors.slate,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarDatos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1. GET /api/solicitudes-caso/mis-solicitudes (o solicitudes-mias)
      final solicitudes = await ApiService().listarMisSolicitudesCaso();

      // 2. GET /api/propuestas/mis-propuestas
      final propuestas = await ApiService().listarMisPropuestas();

      if (!mounted) return;
      setState(() {
        _solicitudes = solicitudes;
        _propuestas = propuestas;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final msg = ApiService.parseError(e);
      setState(() {
        _loading = false;
        _error = msg;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          content: Text(msg),
        ),
      );
    }
  }

  Future<void> _evaluarPropuesta(int idPropuesta, bool aceptar) async {
    setState(() => _loading = true);
    try {
      // PUT /api/propuestas/{id}
      final res = await ApiService().evaluarPropuesta(idPropuesta, aceptar: aceptar);
      if (!mounted) return;
      setState(() {
        _loading = false;
        final index = _propuestas.indexWhere(
          (p) => (p['idPropuesta'] ?? p['IdPropuesta']) == idPropuesta,
        );
        if (index != -1) {
          _propuestas[index]['estadoPropuesta'] = aceptar ? 'aceptada' : 'rechazada';
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: aceptar ? AppColors.emerald : AppColors.navy,
          behavior: SnackBarBehavior.floating,
          content: Text(
            res['mensaje']?.toString() ??
                (aceptar ? 'Propuesta aceptada con éxito.' : 'Propuesta rechazada.'),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      final msg = ApiService.parseError(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          content: Text(msg),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expedientes y Solicitudes', style: TextStyle(fontWeight: FontWeight.w800)),
            Text(
              'Gestión de casos, solicitudes y propuestas',
              style: TextStyle(fontSize: 12, color: AppColors.slate),
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(118, 42),
              backgroundColor: AppColors.emerald,
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
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _loading ? null : _cargarDatos,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.emerald,
          unselectedLabelColor: AppColors.slate,
          indicatorColor: AppColors.emerald,
          indicatorWeight: 3,
          tabs: [
            const Tab(text: 'Casos activos'),
            Tab(text: 'Solicitudes (${_solicitudes.length})'),
            Tab(text: 'Propuestas (${_propuestas.length})'),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B87B)),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildActiveCasesTab(),
                _buildSolicitudesTab(),
                _buildPropuestasTab(),
              ],
            ),
    );
  }

  // -------------------------------------------------------------
  // TAB 1: Casos Activos (M13 - Mock Reactivo)
  // -------------------------------------------------------------
  Widget _buildActiveCasesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockActiveCases.length,
      itemBuilder: (context, index) {
        final item = _mockActiveCases[index];
        final color = item['color'] as Color;
        final progress = item['progreso'] as double;
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
                        item['numero'] as String,
                        style: const TextStyle(
                          color: AppColors.emerald,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item['estado'] as String,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item['area'] as String,
                  style: const TextStyle(color: AppColors.slate, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  item['asunto'] as String,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  item['abogado'] as String,
                  style: const TextStyle(color: AppColors.slate),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    color: AppColors.emerald,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(progress * 100).round()}% completado',
                  style: const TextStyle(fontSize: 11, color: AppColors.slate),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.caseDetail),
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
    );
  }

  // -------------------------------------------------------------
  // TAB 2: Solicitudes de Caso (GET /api/solicitudes-caso/mis-solicitudes)
  // -------------------------------------------------------------
  Widget _buildSolicitudesTab() {
    if (_solicitudes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 54, color: AppColors.slate),
            const SizedBox(height: 12),
            const Text(
              'No tienes solicitudes de caso registradas.',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.slate),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
              child: const Text('Buscar un abogado'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF00B87B),
      onRefresh: _cargarDatos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _solicitudes.length,
        itemBuilder: (context, i) {
          final item = _solicitudes[i];
          final id = item['idSolicitud'] ?? item['IdSolicitud'] ?? '-';
          final titulo = item['titulo'] ?? item['Titulo'] ?? 'Solicitud de Asesoría';
          final abogado = item['nombreAbogado'] ?? item['NombreAbogado'] ?? 'Abogado asignado';
          final desc = item['descripcionProblema'] ?? item['DescripcionProblema'] ?? '';
          final estado = (item['estadoSolicitud'] ?? item['EstadoSolicitud'] ?? 'pendiente').toString();

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Solicitud #$id',
                        style: const TextStyle(
                          color: AppColors.emerald,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          estado.replaceAll('_', ' ').toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.emerald,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    titulo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text('Abogado: $abogado', style: const TextStyle(color: AppColors.slate)),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, height: 1.3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // TAB 3: Propuestas Recibidas (GET /api/propuestas/mis-propuestas)
  // -------------------------------------------------------------
  Widget _buildPropuestasTab() {
    if (_propuestas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.assignment_turned_in_outlined, size: 54, color: AppColors.slate),
            const SizedBox(height: 12),
            const Text(
              'No tienes propuestas recibidas por el momento.',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.slate),
            ),
            const SizedBox(height: 8),
            const Text(
              'Los abogados enviarán sus propuestas tras evaluar tus solicitudes.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.slate),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF00B87B),
      onRefresh: _cargarDatos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _propuestas.length,
        itemBuilder: (context, i) {
          final p = _propuestas[i];
          final id = (p['idPropuesta'] ?? p['IdPropuesta'] ?? 0) as int;
          final titulo = p['titulo'] ?? p['Titulo'] ?? 'Propuesta de Servicios';
          final abogado = p['nombreAbogado'] ?? p['NombreAbogado'] ?? 'Abogado';
          final desc = p['descripcionServicios'] ?? p['DescripcionServicios'] ?? '';
          final costo = (p['costoEstimadoMxn'] as num?)?.toDouble() ??
              (((p['costoEstimadoCentavos'] ?? 0) as num).toDouble() / 100.0);
          final dias = p['tiempoEstimadoDias'] ?? p['TiempoEstimadoDias'] ?? '-';
          final estado = (p['estadoPropuesta'] ?? p['EstadoPropuesta'] ?? 'enviada').toString().toLowerCase();

          final bool isPending = estado.contains('enviada') || estado.contains('pendiente');

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Propuesta #$id',
                        style: const TextStyle(
                          color: AppColors.emerald,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Chip(
                        label: Text(
                          estado.toUpperCase(),
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        backgroundColor: estado.contains('acept')
                            ? AppColors.emerald
                            : estado.contains('rechaz')
                                ? AppColors.red
                                : AppColors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    titulo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text('Abogado: $abogado', style: const TextStyle(color: AppColors.slate)),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Costo estimado', style: TextStyle(color: AppColors.slate, fontSize: 11)),
                          Text(
                            '\$${costo.toStringAsFixed(2)} MXN',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.emerald,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Tiempo de resolución', style: TextStyle(color: AppColors.slate, fontSize: 11)),
                          Text(
                            '$dias días estimados',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isPending) ...[
                    const Divider(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _evaluarPropuesta(id, false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.red,
                              side: const BorderSide(color: AppColors.red),
                            ),
                            child: const Text('Rechazar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _evaluarPropuesta(id, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emerald,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Aceptar propuesta'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
