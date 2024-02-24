import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:app_service/api_service.dart';

Dio dio = Dio();

class GridViewImage extends StatefulWidget {
  const GridViewImage({super.key});

  @override
  _GridViewImageState createState() => _GridViewImageState();
}

class _GridViewImageState extends State<GridViewImage> {
  List<XFile> selectedImages = [];
  String? selectedCheckBlock;
  TextEditingController snController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  Future<void> getImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 600,
    );
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        imageFileList!.addAll(selectedImages);
        print("Image List Length: ${imageFileList!.length}");
      });
    }
  }

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (pickedImage != null) {
      setState(() {
        imageFileList!.add(pickedImage);
      });
    }
  }

  _submitData() async {
    const path = 'https://united-tsm.com/services/mobileupload.php';

    if (imageFileList != null) {
      for (var i = 0; i < imageFileList!.length; i++) {
        XFile file = imageFileList![i];
        print(file.path);
        String filename = file.path.split('/').last;
        var byteData = await imageFileList![i].readAsBytes();
        List<int> imageData = byteData.buffer.asUint8List();

        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: filename,
          contentType: MediaType('image', 'jpg'),
        );

        FormData formData = FormData.fromMap({
          "image": multipartFile,
          "sn": ApiService.pmdata["sn"],
          "pmtype": selectedCheckBlock,
          "count": imageFileList!.length.toString(),
        });

        try {
          var response = await dio.post(path, data: formData);
          if (response.statusCode == 200) {
            print(response.data);
          }
        } catch (e) {
          print("Error uploading image: $e");
        }
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      imageFileList!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              "บันทึกการบริการ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 3, // Blur radius
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/forklift.png',
                              width: 120,
                              height: 120,
                            ),
                          ),

                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 120,
                            width: 2,
                            child: Container(
                              width: 3,
                              height: 120,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // SN display
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: Text('PN : CFG-27542-9734'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: Text('SN: ${ApiService.pmdata['sn']}'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(0),
                                child:
                                    Text('SN: ${ApiService.pmdata['cutname']}'),
                              ),
                              DropdownButton<String>(
                                value: selectedCheckBlock ?? 'No',
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedCheckBlock = value;
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'No',
                                    child: Text('เลือกประเภท Sevice'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'PDI',
                                    child: Text('PDI'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'PM',
                                    child: Text('PM'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Trobleshoot',
                                    child: Text('Trobleshoot'),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "อัปโหลดรูปถ่าย",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Container(
                width: double.infinity,
                height: 3,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),

            // Display Picture
            GridView.builder(
              shrinkWrap: true,
              itemCount: imageFileList!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Set a background color to ensure the container is visible
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Image.file(
                        File(imageFileList![index].path),
                        fit: BoxFit
                            .cover, // Ensure the image fills the container
                      ),
                      Positioned(
                        top: -6,
                        right: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete_forever_outlined),
                            color: Colors.black,
                            onPressed: () {
                              _removeImage(index);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      //getImages();
                      //getImages();
                      //Navigator.pushNamed(context, '/test');
                      _getImage(context, ImageSource.camera);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      backgroundColor: const Color.fromARGB(255, 117, 124, 129),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 3,
                    ),
                    child: Ink(
                      child: Container(
                        constraints:
                            const BoxConstraints(minWidth: 88, minHeight: 36),
                        alignment: Alignment.center,
                        child: const Text(
                          'ถ่ายภาพ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      getImages();
                      //getImage(context, ImageSource.gallery);
                      //Navigator.pushNamed(context, '/test');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 3,
                    ),
                    child: Ink(
                      child: Container(
                        constraints:
                            const BoxConstraints(minWidth: 88, minHeight: 36),
                        alignment: Alignment.center,
                        child: const Text(
                          'เลือกจากตัวเครื่อง',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('image Path : ${imageFileList}');
          //print('image length : ${imageFileList}');
          await _submitData();
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }

  // final ImagePicker imagePicker = ImagePicker();
  // List<XFile>? imageFileList = [];
}


//2nd



