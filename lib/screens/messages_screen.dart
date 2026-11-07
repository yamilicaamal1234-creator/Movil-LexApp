import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../services/app_data_service.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String filter = 'Todos';
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataService>(
      builder: (context, data, _) {
        final query = searchController.text.trim().toLowerCase();
        final visible = data.conversations.where((conversation) {
          if (filter == 'No leídos' && conversation.unreadCount == 0) {
            return false;
          }
          if (filter == 'Archivados') return false;
          if (query.isEmpty) return true;
          return conversation.lawyer.toLowerCase().contains(query) ||
              conversation.caseNumber.toLowerCase().contains(query) ||
              conversation.preview.toLowerCase().contains(query);
        }).toList();
        final unread = data.totalUnreadMessages;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mensajes',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  unread == 0 ? 'Al día' : '$unread nuevos',
                  style: TextStyle(
                    fontSize: 12,
                    color: unread == 0 ? AppColors.slate : AppColors.emerald,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.chat);
                },
                tooltip: 'Nuevo mensaje',
                icon: const Icon(Icons.edit_square),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '🔒 Canal seguro cifrado E2E • Secreto profesional',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar conversaciones',
                  ),
                ),
              ),
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  children:
                      ['Todos', 'No leídos', 'Casos activos', 'Archivados']
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
                                onSelected: (_) =>
                                    setState(() => filter = label),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay conversaciones para mostrar',
                          style: TextStyle(color: AppColors.slate),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final conversation = visible[index];
                          final originalIndex = data.conversations.indexOf(
                            conversation,
                          );
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: Stack(
                                children: [
                                  const CircleAvatar(
                                    radius: 27,
                                    child: Icon(Icons.person),
                                  ),
                                  if (conversation.online)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppColors.emerald,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              title: Text(
                                conversation.lawyer,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    conversation.caseNumber,
                                    style: const TextStyle(
                                      color: AppColors.emerald,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    conversation.preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.slate,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    conversation.time,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.slate,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (conversation.unreadCount > 0)
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: AppColors.emerald,
                                      child: Text(
                                        '${conversation.unreadCount}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.done_all,
                                      size: 16,
                                      color: AppColors.blue,
                                    ),
                                ],
                              ),
                              onTap: () async {
                                data.markConversationRead(originalIndex);
                                await Navigator.pushNamed(
                                  context,
                                  AppRoutes.chat,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
