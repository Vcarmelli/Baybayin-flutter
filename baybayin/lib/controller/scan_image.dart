import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class DetectImage extends StatefulWidget {
  @override
  _DetectImageState createState() => _DetectImageState();
}

class _DetectImageState extends State<DetectImage> {
  bool loading = true;
  late File _image;
  List? _output;
  final imagepicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      pickImageGallery();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/best-fp16.tflite',
        labels: 'assets/labels.txt');
  }

  pickImageGallery() async {
    var image = await imagepicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectImage(_image);
  }

  detectImage(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 1,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = prediction;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Baybayin AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(38, 1, 4, 1.0),
          title: Center(
              child: Text(
            'Baybayin AI',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 22,
              ),
            ),
          )),
        ),
        body: Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(38, 1, 4, 1.0),
                  Color.fromRGBO(13, 13, 13, 1.0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: loading != true
                ? ListView(children: [
                    Container(
                      height: h * 0.7,
                      width: w * 0.9,
                      child: Image.file(_image),
                    ),
                    _output != null
                        ? Container(
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              'Label: ' +
                                  (_output?[0]['label'])
                                      .toString()
                                      .substring(2),
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        : const Text('WALANG LABEL'),
                    _output != null
                        ? Container(
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              'Confidence: ' +
                                  (_output?[0]['confidence']).toString(),
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        : const Text('WALANG CONFIDENCE'),
                  ])
                : const Icon(Icons.broken_image_outlined,
                    color: const Color.fromRGBO(217, 217, 217, 1), size: 250)),
      ),
    );
  }
}
