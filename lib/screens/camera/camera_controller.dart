import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class CamaraController extends GetxController {
  final isLoading = false.obs;
  final cameras = <CameraDescription>[].obs;
  CameraController? cameraController;
  final lastPhoto = Rxn<XFile>();
  final error = RxnString();
  final lastSavedPath = RxnString();
  int selectedIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> init() async {
    try {
      isLoading.value = true;
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        error.value = 'Permiso de cámara denegado';
        return;
      }
      final available = await availableCameras();
      cameras.assignAll(available);
      if (available.isNotEmpty) {
        await _initControllerForIndex(selectedIndex);
      } else {
        error.value = 'No hay cámaras disponibles';
      }
    } catch (e) {
      error.value = 'Error inicializando la cámara: $e';
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> _initControllerForIndex(int index) async {
    try {
      cameraController?.dispose();
      cameraController = CameraController(cameras[index], ResolutionPreset.medium, enableAudio: false);
      await cameraController!.initialize();
      update();
    } catch (e) {
      error.value = 'Error inicializando cámara: $e';
      update();
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length < 2) return;
    selectedIndex = (selectedIndex + 1) % cameras.length;
    await _initControllerForIndex(selectedIndex);
  }

  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;
    if (cameraController!.value.isTakingPicture) return;
    try {
      final file = await cameraController!.takePicture();
      lastPhoto.value = file;
      // guardar en storage de la app
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${appDir.path}/photo_$timestamp.jpg';
      final savedFile = await File(file.path).copy(savedPath);
      lastSavedPath.value = savedFile.path;
      update();
    } catch (e) {
      error.value = 'Error al tomar foto: $e';
      update();
    }
  }
}
