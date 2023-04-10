import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _scannedImage;
  Uint8List? _compressedImages;
    File? compressedImage;

    String compressedImagePath = "/storage/emulated/0/Download/";


  void _startScan(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(context);
    if (image != null) {
   


    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      image.path,
      "$compressedImagePath/scanned_image_${DateTime.now().millisecondsSinceEpoch}.webp",
      quality: 10,
      format: CompressFormat.webp
    );

    if (compressedFile != null) {
      setState(() {
        compressedImage = compressedFile;
      });
      print(await image.length());
      print(await compressedFile.length());
    }
    

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a file to save the image
      final file = File("$compressedImagePath/scanned_image_${DateTime.now().millisecondsSinceEpoch}.webp");
      print(file.path);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (compressedImage != null)
              Image.file(
                compressedImage!,
                width: 300,
                height: 300,
              ),
            if (compressedImage == null)
              const Text(
                'No Image Selected',
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startScan(context);
        },
        tooltip: 'Scan Document',
        child: const Icon(Icons.scanner),
      ),
    );
  }
}
