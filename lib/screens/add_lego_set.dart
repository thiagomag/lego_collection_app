import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/lego_set.dart';
import '../database_helper.dart';

class AddLegoSetScreen extends StatefulWidget {
  @override
  _AddLegoSetScreenState createState() => _AddLegoSetScreenState();
}

class _AddLegoSetScreenState extends State<AddLegoSetScreen> {
  final _nameController = TextEditingController();
  final _linkController = TextEditingController();
  final _piecesController = TextEditingController();
  final _priceController = TextEditingController();
  List<File> _images = [];

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery
    );
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _saveLegoSet() async {
    final name = _nameController.text;
    final officialPage = _linkController.text;
    final pieces = int.tryParse(_piecesController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final imagePaths = _images.map((image) => image.path).toList();

    final newLegoSet = LegoSet(
      name: name,
      officialPage: officialPage,
      imagePaths: imagePaths,
      pieces: pieces,
      price: price,
    );

    await DatabaseHelper().insertLegoSet(newLegoSet.toMap());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar coleção Legu'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveLegoSet,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(labelText: 'Link da página oficial'),
            ),
            TextField(
              controller: _piecesController,
              decoration: InputDecoration(labelText: 'Numero de peças'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _pickImage(false),
              child: Text('Selecione uma imagem da galeria'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(true),
              child: Text('Tire uma foto'),
            ),
            SizedBox(height: 10),
            _images.isNotEmpty
                ? Wrap(
              spacing: 8,
              children: _images.map((image) {
                return Image.file(image, width: 100, height: 100);
              }).toList(),
            )
                : Text('Nenhuma imagem selecionada'),
          ],
        ),
      ),
    );
  }
}
