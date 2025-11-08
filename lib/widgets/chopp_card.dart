import 'package:flutter/material.dart';

class ChoppCard extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final bool available;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ChoppCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.available,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: available ? Colors.green.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.local_drink,
            size: 30,
            color: available ? Colors.green.shade700 : Colors.grey,
          ),
        ),
        title: Text(name, style: TextStyle(fontSize: 16),),
        subtitle: Text('R\$ ${price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Switch dentro de SizedBox para manter tamanho estável
            SizedBox(
              width: 56,
              child: Switch(
                value: available,
                onChanged: (_) => onToggle(),
              ),
            ),
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
