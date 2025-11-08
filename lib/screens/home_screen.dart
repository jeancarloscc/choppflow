import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../widgets/chopp_card.dart';
import 'edit_item_screen.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final FirebaseService _svc = FirebaseService();

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _svc.deleteItem(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Chopp - Vendedor'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _svc.streamAllItems(),
        builder: (context, snapshot) {
          // Mostra erro se houver
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Força rebuild do StreamBuilder
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Mostra loading inicial
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando chopps...'),
                ],
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          
          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_drink_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum item cadastrado'),
                  SizedBox(height: 8),
                  Text('Toque no + para adicionar', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            // Otimização: reutiliza widgets fora da tela
            cacheExtent: 200,
            itemBuilder: (ctx, i) {
              final d = docs[i];
              final data = d.data() as Map<String, dynamic>;
              return ChoppCard(
                key: ValueKey(d.id), // Ajuda Flutter a identificar widgets únicos
                id: d.id,
                name: data['name'] ?? '',
                price: (data['price'] ?? 0).toDouble(),
                imageUrl: data['imageUrl'],
                available: data['available'] ?? false,
                onToggle: () async {
                  await _svc.toggleAvailability(d.id, data['available'] ?? false, null);
                },
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditItemScreen(id: d.id, data: data),
                  ),
                ),
                onDelete: () => _confirmDelete(context, d.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditItemScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}