import 'package:flutter/material.dart';
import '../models/lego_set.dart';
import '../database_helper.dart';
import 'add_lego_set.dart';
import 'edit_lego_set.dart';
import 'lego_set_detail.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LegoSet> _legoSets = [];

  @override
  void initState() {
    super.initState();
    _loadLegoSets();
  }

  Future<void> _loadLegoSets() async {
    final data = await DatabaseHelper().getLegoSets();
    setState(() {
      _legoSets = data.map((e) => LegoSet.fromMap(e)).toList();
    });
  }

  Future<void> _deleteLegoSet(int id) async {
    await DatabaseHelper().deleteLegoSet(id);
    _loadLegoSets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coleção de Legos'),
      ),
      body: ListView.builder(
        itemCount: _legoSets.length,
        itemBuilder: (context, index) {
          final legoSet = _legoSets[index];
          return GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Editar'),
                        onTap: () {
                          Navigator.pop(context); // Fechar o modal antes de navegar
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditLegoSetScreen(legoSet: legoSet),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Deletar'),
                        onTap: () {
                          _deleteLegoSet(legoSet.id!);
                          Navigator.pop(context); // Fechar o modal
                        },
                      ),
                    ],
                  );
                },
              );
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LegoSetDetailScreen(legoSet: legoSet),
                ),
              );
            },
            child: ListTile(
              title: Text(legoSet.name),
              subtitle: Text('Peças: ${legoSet.pieces}'),
              leading: legoSet.imagePaths.isNotEmpty
                  ? Image.file(File(legoSet.imagePaths[0]), width: 50, height: 50)
                  : Icon(Icons.image),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLegoSetScreen()),
          );
          _loadLegoSets(); // Recarrega os dados após adicionar um novo conjunto
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
