import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final List<(String, IconData, Color, String, String)> _uploadedFiles = [];

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      withData: false,
      withReadStream: false,
    );
    if (!mounted || result == null || result.files.isEmpty) return;

    final additions = result.files.map((file) {
      final extension = file.name.contains('.')
          ? file.name.split('.').last.toUpperCase()
          : 'ARCHIVO';
      final size = file.size < 1024
          ? '${file.size} B'
          : file.size < 1024 * 1024
          ? '${(file.size / 1024).toStringAsFixed(1)} KB'
          : '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB';
      return (
        extension,
        Icons.attach_file_rounded,
        AppColors.emerald,
        file.name,
        size,
      );
    }).toList();

    setState(() => _uploadedFiles.insertAll(0, additions));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${result.files.length} archivo(s) agregado(s)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final folders = [
      ('Contratos', '12 archivos'),
      ('Identificación', '3 archivos'),
      ('Legal IP', '5 archivos'),
      ('Otros', '2 archivos'),
    ];
    final files = [
      (
        'PDF',
        Icons.picture_as_pdf_rounded,
        const Color(0xFFDC2626),
        'Contrato_Arrendamiento.pdf',
        'Hace 2 horas',
      ),
      (
        'DOCX',
        Icons.description_rounded,
        const Color(0xFF2563EB),
        'Poder_Notarial.docx',
        'Ayer',
      ),
      (
        'IMG',
        Icons.image_rounded,
        const Color(0xFF7C3AED),
        'Identificacion_Oficial.jpg',
        '20 Oct 2023',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Documentos',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(
            onPressed: _pickDocument,
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.emerald,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: folders.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (_, i) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.folder_rounded,
                    color: AppColors.emerald,
                    size: 34,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    folders[i].$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    folders[i].$2,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Archivos Recientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          ...[..._uploadedFiles, ...files].map(
            (file) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: file.$3.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(file.$2, color: file.$3),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.$4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          '${file.$1} · ${file.$5}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.download_rounded,
                      color: AppColors.emerald,
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
