import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'dart:developer';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    initCamera();
    initTflite();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late CameraImage imgCamera;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var output = ''.obs;
  var listData = <dynamic>[].obs;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      log("Permission denied");
    }
  }

  initTflite() async {
    await Tflite.loadModel(
      model: "assets/best-fp16.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    try {
      var detector = await Tflite.runModelOnFrame(
          bytesList: image.planes.map((e) {
            return e.bytes;
          }).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          numResults: 1,
          rotation: 90,
          threshold: 0.4,
          asynch: true);

      if (detector != null) {
        log("Result is $detector");
        String lbl = 'Label: ' + (detector[0]['label']).toString();
        String cnf = 'Confidence: ' + (detector[0]['confidence']).toString();
        RxString lblRxString = RxString(lbl);
        RxString cnfRxString = RxString(cnf);
        output("${lblRxString.value}\n${cnfRxString.value}");
        // updateListData(detector);
      }
    } catch (e) {
      log("$e");
    }
  }

  updateListData(List<dynamic> newData) {
    listData.assignAll(newData);
    output.value = listData.join(', ');
  }
}
