import 'package:baybayin/controller/scan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    var scanController = Get.find<ScanController>();

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: h * 0.7,
                width: w,
                child: GetBuilder<ScanController>(
                  init: ScanController(),
                  builder: (controller) {
                    return Container(
                      child: controller.isCameraInitialized.value
                          ? AspectRatio(
                              aspectRatio: controller.cameraController.value.aspectRatio,
                              child: CameraPreview(controller.cameraController))
                          : const Center(child: Text("Loading preview...")),
                    );
                }),
              ),  
            ),           
            Center(    
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.all(10),
                child: Obx(() => Text(
                  '${scanController.output}',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
