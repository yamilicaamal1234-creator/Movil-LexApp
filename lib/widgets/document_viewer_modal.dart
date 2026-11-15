import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';

class DocumentViewerModal extends StatefulWidget {
  final String fileName;
  final String caseNumber;
  final String size;
  final bool isPendingSignature;
  final String? customContent;

  const DocumentViewerModal({
    super.key,
    required this.fileName,
    this.caseNumber = '#LX-2024-8841',
    this.size = '245 KB',
    this.isPendingSignature = false,
    this.customContent,
  });

  static Future<void> show(
    BuildContext context, {
    String? fileName,
    String? title,
    String caseNumber = '#LX-2024-8841',
    String? size,
    String? subtitle,
    String? docType,
    bool? isPending,
    bool? allowSign,
    String? content,
  }) {
    final effectiveName = fileName ?? title ?? 'documento.pdf';
    final effectiveSize = size ?? subtitle ?? '245 KB';
    final effectivePending = isPending ?? allowSign ?? false;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DocumentViewerModal(
        fileName: effectiveName,
        caseNumber: caseNumber,
        size: effectiveSize,
        isPendingSignature: effectivePending,
        customContent: content,
      ),
    );
  }

  @override
  State<DocumentViewerModal> createState() => _DocumentViewerModalState();
}

class _DocumentViewerModalState extends State<DocumentViewerModal> {
  bool _downloading = false;
  double _progress = 0.0;
  bool _downloaded = false;

  Future<void> _downloadFile() async {
    setState(() {
      _downloading = true;
      _progress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() => _progress = i / 10.0);
    }

    if (!mounted) return;
    setState(() {
      _downloading = false;
      _downloaded = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.navy,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.emerald, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Guardado en Descargas: ${widget.fileName}',
                style: const TextStyle(color: AppColors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Abrir',
          textColor: AppColors.emerald,
          onPressed: () {},
        ),
      ),
    );
  }

  String _getDocumentBody() {
    if (widget.customContent != null) return widget.customContent!;
    final name = widget.fileName.toLowerCase();

    if (name.contains('adenda') || name.contains('clausula')) {
      return '''ADENDA MODIFICATORIA DE CLÁUSULA PENAL

EXPEDIENTE: ${widget.caseNumber}
FECHA DE EMISIÓN: 14 de Noviembre de 2026
LETRADA RESPONSABLE: Dra. Sofía Valenzuela (Cédula Colegial 8841)

CLÁUSULA PRIMERA (OBJETO):
Las partes acuerdan de común acuerdo modificar el numeral 8.2 del contrato principal relativo a las penalizaciones por demora en el cumplimiento de obligaciones contractuales.

CLÁUSULA SEGUNDA (NUEVA REDACCIÓN):
"La penalidad convencional aplicable se reduce al 1.5% mensual sobre saldo insoluto, estableciendo un período de gracia de 5 días hábiles previo a la ejecución de garantías".

CLÁUSULA TERCERA (VIGENCIA Y RATIFICACIÓN):
Ambas partes ratifican en todas sus demás cláusulas y términos el contrato base, reconociendo plena validez legal a través de la plataforma LexApp bajo el marco normativo eIDAS y de firma electrónica avanzada.

CLÁUSULA CUARTA (JURISDICCIÓN):
Para la resolución de cualquier controversia, las partes se someten a los juzgados competentes de la jurisdicción civil correspondiente.''';
    } else if (name.contains('arrendamiento') || name.contains('contrato')) {
      return '''CONTRATO DE ARRENDAMIENTO INMOBILIARIO

EXPEDIENTE: ${widget.caseNumber}
CERTIFICACIÓN DIGITAL: LEX-SEC-99214

CLÁUSULA PRIMERA (DEL INMUEBLE):
El ARRENDADOR otorga en arrendamiento el inmueble objeto del presente contrato en favor del ARRENDATARIO, quien lo recibe a su entera satisfacción y en óptimas condiciones de habitabilidad.

CLÁUSULA SEGUNDA (RENTA MENSUAL):
El precio convenido por concepto de renta mensual es el estipulado en las condiciones particulares, pagadero dentro de los primeros 5 días de cada período natural.

CLÁUSULA TERCERA (DEPÓSITO EN GARANTÍA):
El importe entregado en custodia permanecerá protegido en fideicomiso LexApp Escrow hasta la entrega formal y desocupación del inmueble sin adeudos de suministros ni desperfectos.

DOCUMENTO FIRMADO Y PROTOCOLIZADO ELECTRÓNICAMENTE.''';
    } else if (name.contains('identificacion') || name.contains('ident')) {
      return '''CERTIFICADO DE VERIFICACIÓN DE IDENTIDAD OFICIAL

EXPEDIENTE VINCULADO: ${widget.caseNumber}
SISTEMA DE VERIFICACIÓN: LexApp eIDAS Level 3 Biometric Check
ESTADO: IDENTIDAD CONFIRMADA Y VALIDADA

DATOS BIOMÉTRICOS Y REGISTRALES:
• Titular verificado mediante cotejo biométrico oficial.
• Cédula / Documento de Identidad Nacional cotejado ante registro gubernamental.
• Cifrado de resguardo: AES-256 bits con sello de tiempo criptográfico RFC-3161.
• Caducidad de la validación: 31 de Diciembre de 2028.

El presente documento es copia fidedigna certificada de la identificación aportada por el cliente para el inicio del patrocinio legal.''';
    }

    return '''EXPEDIENTE LEGAL LEXAPP: ${widget.caseNumber}
DOCUMENTO: ${widget.fileName}
ESTADO: Certificado y resguardado en la nube jurídica LexApp.

El contenido de este archivo forma parte del acervo probatorio y documental del caso en curso. Ha sido revisado y aprobado por el abogado asignado cumpliendo con los estándares de secrecía profesional y confidencialidad procesal.''';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.line,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fileName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${widget.caseNumber} • ${widget.size}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.slate,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  tooltip: 'Cerrar',
                ),
              ],
            ),
          ),

          // Status Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isPendingSignature
                  ? AppColors.red.withValues(alpha: 0.1)
                  : AppColors.emerald.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.isPendingSignature
                    ? AppColors.red.withValues(alpha: 0.3)
                    : AppColors.emerald.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isPendingSignature
                      ? Icons.error_outline
                      : Icons.verified_user_outlined,
                  size: 18,
                  color: widget.isPendingSignature
                      ? AppColors.red
                      : AppColors.emerald,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.isPendingSignature
                        ? 'Documento pendiente de firma electrónica'
                        : 'Documento certificado con validez legal eIDAS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.isPendingSignature
                          ? AppColors.red
                          : AppColors.emerald,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_downloading)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: AppColors.line,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.emerald,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Descargando archivo... ${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 10),

          // Document Sheet Content (Legal paper simulation)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0C1B2E) : const Color(0xFFFAFBFD),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Official header stamp
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.emerald,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.gavel,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'LEXAPP LEGAL NETWORK',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  color: AppColors.emerald,
                                ),
                              ),
                              Text(
                                'FE PÚBLICA DIGITAL Y CUSTODIA SEGURA',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.slate,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.line,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'OFICIAL',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    SelectableText(
                      _getDocumentBody(),
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        fontFamily: 'monospace',
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 20),

                    // Digital Verification Hash
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'SELLO CRIPTOGRÁFICO DE VERIFICACIÓN:',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.slate,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'SHA-256: 4b22c7d91ae39b81f98d7120fa21e84a921d7841bc29',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                              color: AppColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Action Bar
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _downloading ? null : _downloadFile,
                      icon: Icon(
                        _downloaded ? Icons.check : Icons.download_rounded,
                        color: _downloaded ? AppColors.emerald : null,
                      ),
                      label: Text(
                        _downloaded ? 'Descargado' : 'Descargar',
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: BorderSide(
                          color: _downloaded ? AppColors.emerald : AppColors.line,
                        ),
                      ),
                    ),
                  ),
                  if (widget.isPendingSignature) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.signature);
                        },
                        icon: const Icon(Icons.draw_outlined),
                        label: const Text('Firmar ahora'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
