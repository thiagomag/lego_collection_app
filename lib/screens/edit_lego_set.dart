import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lego_collection_app/database_helper.dart';
import 'package:lego_collection_app/models/lego_set.dart';

class EditLegoSetScreen extends StatefulWidget {
  final LegoSet legoSet;

  EditLegoSetScreen({required this.legoSet});

  @override
  _EditLegoSetScreenState createState() => _EditLegoSetScreenState();
}

class _EditLegoSetScreenState extends State<EditLegoSetScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _officialPage;
  List<String> _imagePaths = [];
  int? _pieces;
  double? _price;

  @override
  void initState() {
    super.initState();
    // Preencher os campos com os dados existentes
    _name = widget.legoSet.name;
    _officialPage = widget.legoSet.officialPage;
    _imagePaths = List.from(widget.legoSet.imagePaths);
    _pieces = widget.legoSet.pieces;
    _price = widget.legoSet.price;
  }

  Future<void> _saveLegoSet() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      LegoSet updatedLegoSet = LegoSet(
        id: widget.legoSet.id, // Usa o id existente
        name: _name!,
        officialPage: _officialPage!,
        imagePaths: _imagePaths,
        pieces: _pieces!,
        price: _price!,
      );

      await DatabaseHelper().updateLegoSet(updatedLegoSet); // Atualiza o conjunto existente
      Navigator.pop(context, true); // Retorna para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Conjunto LEGO"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveLegoSet,
          ),
        ],
      ),
      body: SingleChildScrollView( // Adiciona a rolagem
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Nome'),
                  onSaved: (value) {
                    _name = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um nome.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _officialPage,
                  decoration: InputDecoration(labelText: 'Página Oficial'),
                  onSaved: (value) {
                    _officialPage = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a URL.';
                    }
                    return null;
                  },
                ),
                // Adicione aqui os campos para inserir imagens, peças e preço
                TextFormField(
                  initialValue: _pieces.toString(),
                  decoration: InputDecoration(labelText: 'Número de Peças'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _pieces = int.tryParse(value!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o número de peças.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _price = double.tryParse(value!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o preço.';
                    }
                    return null;
                  },
                ),
                // Adicione um botão ou widget para adicionar imagens
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para adicionar imagens
                  },
                  child: Text("Adicionar Imagens"),
                ),
                // Exibir as imagens adicionadas
                Wrap(
                  spacing: 8.0,
                  children: _imagePaths.map((path) {
                    return Image.file(
                      File(path),
                      width: 100,
                      height: 100,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
