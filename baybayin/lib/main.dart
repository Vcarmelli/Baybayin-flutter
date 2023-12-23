import 'package:flutter/material.dart';
import 'package:baybayin/views/camera_view.dart';
import 'package:baybayin/controller/scan_controller.dart';
import 'package:baybayin/controller/scan_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Get.put(ScanController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baybayin AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
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
            child: ListView(
              children: [
                wordSection,
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(
                        top: 70, right: 10, bottom: 10, left: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromRGBO(38, 1, 4, 1.0),
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraView()),
                        );
                      },
                      child: Text(
                        'Open Camera',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromRGBO(38, 1, 4, 1.0),
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetectImage()),
                        );
                      },
                      child: Text(
                        'Gallery',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // _loading == false
                //     ? Column(children: [
                //         Container(
                //           height: 200,
                //           width: 200,
                //           child: Image.file(_image),
                //         ),
                //         scanController.imagePrediction != null
                //             ? Obx(() => Text(
                //                   'Output: ${scanController.imagePrediction}',
                //                   style: GoogleFonts.montserrat(
                //                     textStyle: const TextStyle(
                //                       fontSize: 18,
                //                     ),
                //                   ),
                //                 ))
                //             : const Text('WALA')
                //       ])
                //     : Container(child: const Text('WALANG IMAGE'),)
              ],
            )));
  }

  Widget wordSection = Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(40),
          child: Text(
            'WORD OF THE DAY',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          width: 300,
          height: 350,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(217, 217, 217, 0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
              child: Text(
            'Tap to reveal',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ),
      ],
    ),
  );
}
