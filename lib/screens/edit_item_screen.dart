import 'package:flutter/material.dart';
import '../services/firebase_service.dart';


class EditItemScreen extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? data;
  const EditItemScreen({super.key, this.id, this.data});


  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}


class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _available = true;
  bool _loading = false;
  final _svc = FirebaseService();


  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _nameCtrl.text = widget.data!['name'] ?? '';
      _priceCtrl.text = (widget.data!['price'] ?? '').toString();
      _descCtrl.text = widget.data!['description'] ?? '';
      _available = widget.data!['available'] ?? true;
    }
  }


  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _loading = true);
    try {
      final name = _nameCtrl.text.trim();
      final price = double.tryParse(_priceCtrl.text.replaceAll(',', '.')) ?? 0.0;
      final map = {
        'name': name,
        'price': price,
        'description': _descCtrl.text.trim(),
        'available': _available,
      };
      if (widget.id == null) {
        await _svc.createItem(map);
      } else {
        await _svc.updateItem(widget.id!, map);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Novo Item' : 'Editar Item'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, informe o nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                        border: OutlineInputBorder(),
                        prefixText: 'R\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, informe o preço';
                        }
                        final price = double.tryParse(value.replaceAll(',', '.'));
                        if (price == null || price <= 0) {
                          return 'Informe um preço válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Descrição (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Disponível'),
                      value: _available,
                      onChanged: (val) => setState(() => _available = val),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _save,
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}