import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SellScreen extends StatefulWidget {
  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  uploadImage(File imageFile) async {    
      var stream = new http.ByteStream(imageFile.openRead());
      stream.cast();
      var length = await imageFile.length();
      var uri = Uri.parse("https://bazaar-api-v1.herokuapp.com/post/upload");
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path), contentType: MediaType('image', 'jpeg'));

      // add file to multipart
      request.files.add(multipartFile);

      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      return response.statusCode.toString();
    }
  String state = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter File Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(state)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
          print('file page:+===> ${pickedFile.path}');
          var res = await uploadImage(File(pickedFile.path));
          setState(() {
            state = res;
            print(res);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}