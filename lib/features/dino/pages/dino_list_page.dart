// lib/features/dino/pages/dino_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../providers/dino_provider.dart';
import '../models/dinosaur.dart';
import 'dino_form_page.dart';

class DinoListPage extends StatefulWidget {
  const DinoListPage({super.key});

  @override
  State<DinoListPage> createState() => _DinoListPageState();
}

class _DinoListPageState extends State<DinoListPage> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DinoProvider>().fetch());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DinoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dino Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => p.setFavOnly((p.items.any((e) => !e.favorite)) ? true : null),
            tooltip: 'Favorite only',
          ),
          PopupMenuButton<String>(
            onSelected: (v) => p.setDietFilter(v == 'All' ? '' : v.toLowerCase()),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'All', child: Text('All diets')),
              PopupMenuItem(value: 'Carnivore', child: Text('Carnivore')),
              PopupMenuItem(value: 'Herbivore', child: Text('Herbivore')),
              PopupMenuItem(value: 'Omnivore', child: Text('Omnivore')),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'ค้นหาไดโนเสาร์...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _ctrl.text.isEmpty ? null : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () { _ctrl.clear(); p.setQuery(''); },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: p.setQuery,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: p.fetch,
              child: ListView.builder(
                itemCount: p.items.length,
                itemBuilder: (_, i) {
                  final d = p.items[i];
                  return Slidable(
                    key: ValueKey(d.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          icon: Icons.edit, label: 'Edit',
                          onPressed: (_) async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DinoFormPage(editing: d)),
                            );
                            if (updated == true) ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('อัปเดตสำเร็จ')),
                            );
                          },
                        ),
                        SlidableAction(
                          icon: Icons.delete, label: 'Delete', backgroundColor: Colors.red,
                          onPressed: (_) async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('ยืนยันลบ'),
                                content: Text('ลบ ${d.name}?'),
                                actions: [
                                  TextButton(onPressed: ()=>Navigator.pop(context,false), child: const Text('ยกเลิก')),
                                  ElevatedButton(onPressed: ()=>Navigator.pop(context,true), child: const Text('ลบ')),
                                ],
                              ),
                            ) ?? false;
                            if (ok) {
                              await p.remove(d.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('ลบ ${d.name} แล้ว'), action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () async {
                                    await p.add(d.copyWith(id:null));
                                  },
                                )),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(d.favorite ? Icons.star : Icons.star_border),
                        onPressed: () => p.edit(d.copyWith(favorite: !d.favorite)),
                      ),
                      title: Text(d.name),
                      subtitle: Text('${d.period} • ${d.diet}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context, MaterialPageRoute(builder: (_) => DinoFormPage(editing: d)),
                        );
                        if (updated == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('อัปเดตสำเร็จ')),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context, MaterialPageRoute(builder: (_) => const DinoFormPage()),
          );
          if (created == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('เพิ่มข้อมูลสำเร็จ')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
