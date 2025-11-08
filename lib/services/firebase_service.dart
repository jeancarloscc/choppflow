import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService {
  final CollectionReference items = FirebaseFirestore.instance.collection('items');
  final CollectionReference history = FirebaseFirestore.instance.collection('history');

  // Cache para evitar múltiplas instâncias do stream
  Stream<QuerySnapshot>? _cachedStream;

  Stream<QuerySnapshot> streamAllItems() {
    // Reutiliza o stream se já existir
    _cachedStream ??= items
        .orderBy('name')
        .snapshots(includeMetadataChanges: false); // Ignora mudanças de metadata
    return _cachedStream!;
  }

  Stream<QuerySnapshot> streamAvailableItems() => items
      .where('available', isEqualTo: true)
      .orderBy('name')  // ← Reativar quando o índice estiver criado!
      .snapshots(includeMetadataChanges: false);


  Future<void> toggleAvailability(String id, bool current, String? userId) async {
    final ref = items.doc(id);
    await ref.update({
      'available': !current,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': userId,
    });
    await history.add({
      'itemId': id,
      'action': !current ? 'set_available' : 'set_unavailable',
      'by': userId,
      'at': FieldValue.serverTimestamp(),
    });
  }


  Future<DocumentReference> createItem(Map<String, dynamic> data) async {
    return await items.add(data);
  }


  Future<void> updateItem(String id, Map<String, dynamic> data) async {
    await items.doc(id).update(data);
  }


  Future<void> deleteItem(String id) async {
    await items.doc(id).delete();
  }
}