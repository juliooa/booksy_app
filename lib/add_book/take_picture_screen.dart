import 'package:booksy_app/add_book/display_picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _cameraController;

  Future<void> initialize() async {
    var camerasList = await availableCameras();
    _cameraController = CameraController(
      camerasList.first,
      ResolutionPreset.high,
    );

    return _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tomar foto de libro')),
      body: FutureBuilder<void>(
        future: initialize(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Text("Ocurrió un error. Error: ${snapshot.error}")),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                color: Colors.black,
                child: Center(child: CameraPreview(_cameraController)));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _takePicture(context);
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  void _takePicture(BuildContext context) async {
    var image = await _cameraController.takePicture();

    var result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          imagePath: image.path,
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      Navigator.pop(context, result);
    }
  }
}
