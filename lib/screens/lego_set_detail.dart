import 'package:flutter/material.dart';
import 'package:lego_collection_app/screens/edit_lego_set.dart';
import '../models/lego_set.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class LegoSetDetailScreen extends StatefulWidget {
  final LegoSet legoSet;

  LegoSetDetailScreen({required this.legoSet});

  @override
  _LegoSetDetailScreenState createState() => _LegoSetDetailScreenState();
}

class _LegoSetDetailScreenState extends State<LegoSetDetailScreen> {
  late LegoSet _legoSet;

  @override
  void initState() {
    super.initState();
    // Inicializa o _legoSet com o valor passado para a tela
    _legoSet = widget.legoSet;
  }

  void _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    var uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_legoSet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${_legoSet.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Número de peças: ${_legoSet.pieces}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Preço: R\$${_legoSet.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            if (_legoSet.officialPage.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _launchURL(_legoSet.officialPage);
                },
                child: Text(
                  'Página oficial: ${_legoSet.officialPage}',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            SizedBox(height: 20),
            Text('Imagens:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _legoSet.imagePaths.isNotEmpty
                ? SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _legoSet.imagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.file(
                      File(_legoSet.imagePaths[index]),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            )
                : Text('Sem imagens disponíveis'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Aguarda o retorno da tela de edição
                bool? updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditLegoSetScreen(legoSet: _legoSet),
                  ),
                );

                // Se houve uma atualização, recarrega os dados
                if (updated == true) {
                  setState(() {
                    // Recarrega o conjunto atualizado
                    _legoSet = _legoSet;  // Aqui você pode recarregar do banco de dados, se necessário
                  });
                }
              },
              child: Text('Editar coleção Lego'),
            ),
          ],
        ),
      ),
    );
  }
}
