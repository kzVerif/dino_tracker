// lib/features/dino/pages/dino_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dinosaur.dart';
import '../providers/dino_provider.dart';

class DinoFormPage extends StatefulWidget {
  final Dinosaur? editing;
  const DinoFormPage({super.key, this.editing});

  @override
  State<DinoFormPage> createState() => _DinoFormPageState();
}

class _DinoFormPageState extends State<DinoFormPage> {
  final _form = GlobalKey<FormState>();
  late String _name, _period, _diet;
  double? _lengthM, _weightTons;
  String? _note;

  @override
  void initState() {
    super.initState();
    final d = widget.editing;
    _name = d?.name ?? '';
    _period = d?.period ?? 'Late Cretaceous';
    _diet = d?.diet ?? 'carnivore';
    _lengthM = d?.lengthM;
    _weightTons = d?.weightTons;
    _note = d?.note;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.read<DinoProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.editing == null ? 'เพิ่มไดโนเสาร์' : 'แก้ไขไดโนเสาร์')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (v) => v == null || v.trim().length < 2 ? 'กรอกชื่ออย่างน้อย 2 ตัวอักษร' : null,
                onSaved: (v) => _name = v!.trim(),
              ),
              DropdownButtonFormField(
                value: _period,
                items: const [
                  DropdownMenuItem(value: 'Triassic', child: Text('Triassic')),
                  DropdownMenuItem(value: 'Jurassic', child: Text('Jurassic')),
                  DropdownMenuItem(value: 'Early Cretaceous', child: Text('Early Cretaceous')),
                  DropdownMenuItem(value: 'Late Cretaceous', child: Text('Late Cretaceous')),
                ],
                onChanged: (v) => setState(()=> _period = v as String),
                decoration: const InputDecoration(labelText: 'ยุค'),
              ),
              DropdownButtonFormField(
                value: _diet,
                items: const [
                  DropdownMenuItem(value: 'carnivore', child: Text('Carnivore')),
                  DropdownMenuItem(value: 'herbivore', child: Text('Herbivore')),
                  DropdownMenuItem(value: 'omnivore', child: Text('Omnivore')),
                ],
                onChanged: (v) => setState(()=> _diet = v as String),
                decoration: const InputDecoration(labelText: 'รูปแบบการกิน'),
              ),
              TextFormField(
                initialValue: _lengthM?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'ความยาว (เมตร)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _lengthM = v!.isEmpty ? null : double.parse(v),
              ),
              TextFormField(
                initialValue: _weightTons?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'น้ำหนัก (ตัน)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _weightTons = v!.isEmpty ? null : double.parse(v),
              ),
              TextFormField(
                initialValue: _note ?? '',
                decoration: const InputDecoration(labelText: 'โน้ต'),
                maxLines: 3,
                onSaved: (v) => _note = v,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('บันทึก'),
                onPressed: () async {
                  if (!_form.currentState!.validate()) return;
                  _form.currentState!.save();
                  final d = Dinosaur(
                    id: widget.editing?.id,
                    name: _name,
                    period: _period,
                    diet: _diet,
                    lengthM: _lengthM,
                    weightTons: _weightTons,
                    note: _note,
                    favorite: widget.editing?.favorite ?? false,
                    createdAt: widget.editing?.createdAt,
                  );
                  if (widget.editing == null) {
                    await p.add(d);
                  } else {
                    await p.edit(d);
                  }
                  if (mounted) Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
