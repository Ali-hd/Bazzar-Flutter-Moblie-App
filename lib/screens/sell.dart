import 'dart:convert';
import 'dart:io';
import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/models/post.dart';
import 'package:bazzar/services/api.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bazzar/shared/data.dart';
import 'package:bazzar/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SellScreen extends StatefulWidget {
  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int currentIndex = 1;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");

  // File imagePath;
  List<String> images = [];
  bool loading = false;
  bool didUploadError = false;

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<UserProvider>(context, listen: false).getAccount;
    _submitForm(Map values) async {
      print(values);
      final data = SellPost(
          title: values['title'],
          description: values['description'].trim(),
          location: values['location'].toLowerCase(),
          images: images);
      dynamic response = await API().sellPost(data);
      if (jsonDecode(response.body)['msg'] == 'post created successfully') {
        showAlert(context, true);
      } else {
        showAlert(context, false);
      }
      _fbKey.currentState.reset();
      titleController.text = "";
      descriptionController.text = "";
      setState(() {
        images = [];
      });
    }

    final List<Widget> _thumbnails = images.length > 0
        ? images.map<Widget>((item) {
            return Stack(
              children: [
                GalleryExampleItem(
                  imagePath: item,
                  onTap: () {
                    open(context, images.indexOf(item));
                  },
                ),
                Positioned(
                  left: 4,
                  top: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        images.remove(item);
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                )
              ],
            );
          }).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a post'),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: FormBuilder(
          key: _fbKey,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildFormField('title'),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildFormField('description'),
                  SizedBox(height: 20),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 3, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    child: FormBuilderDropdown(
                      onTap: (){
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      attribute: "location",
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      ),
                      hint: Text(
                        'Select your location',
                        style: TextStyle(fontSize: 15),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                      validators: [
                        FormBuilderValidators.required(
                            errorText: 'Please choose a location')
                      ],
                      items: locations
                          .map((gender) => DropdownMenuItem(
                              value: gender, child: Text("$gender")))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Upload your images',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildUploadBtn('Take a photo', Icons.add_a_photo,
                              ImageSource.camera, account),
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.black54,
                          ),
                          _buildUploadBtn('Choose from gallery',
                              Icons.photo_library, ImageSource.gallery, account)
                        ],
                      ),
                    ),
                  ),
                  didUploadError
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Please upload at least 1 image',
                            style:
                                TextStyle(color: Colors.red[400], fontSize: 12),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _thumbnails.length > 0 || loading
                          ? Expanded(
                              child: SizedBox(
                                height: 150,
                                child: Center(
                                    child: loading
                                        ? CircularProgressIndicator()
                                        : ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: _thumbnails)),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      width: 170,
                      child: RaisedButton(
                          elevation: 5.0,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: const Color(0xFF8D6E63),
                          child: Text(
                            'Sell Now',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          onPressed: () async {
                            if(account == null){
                                return showAlertAuth(context);
                              }
                            if (loading) {
                              return false;
                            }
                            if (images.length < 1) {
                              setState(() {
                                didUploadError = true;
                              });
                            }
                            if (_fbKey.currentState.saveAndValidate()) {
                              _submitForm(_fbKey.currentState.value);
                            }
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadImage(File imageFile) async {
    final response = await API().uploadImage(imageFile);
    response.stream.transform(utf8.decoder).listen((value) {
      setState(() {
        images.add(jsonDecode(value)['imageUrl']);
        didUploadError = false;
        loading = false;
      });
    });
    // child: imagePath != null ? Image.file(imagePath) : Text('Loading')
  }

  void showAlert(BuildContext context, bool success) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              // title: ,
              content: Text(success
                  ? "Post created successfully"
                  : "Error creating post"),
              actions: [
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  void showAlertAuth(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertAuth());
  }

  void open(BuildContext context, final int index) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => GalleryPhotoViewWrapper(
        galleryItems: images,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        initialIndex: index,
        scrollDirection: Axis.horizontal,
      ),
    ));
  }

  Widget _buildUploadBtn(String text, IconData icon, ImageSource source, Map<String, dynamic> account) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          ClipOval(
            child: Material(
              child: InkWell(
                onTap: () async {
                  if(account == null){
                     return showAlertAuth(context);
                  }
                  FocusScope.of(context).requestFocus(new FocusNode());
                  PickedFile pickedFile = await ImagePicker()
                      .getImage(source: source, imageQuality: 40);
                  print('file page:+===> ${pickedFile.path}');
                  if (pickedFile != null) {
                    setState(() {
                      // imagePath = File(pickedFile.path);
                      loading = true;
                    });
                    await uploadImage(File(pickedFile.path));
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.transparent),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              color: const Color(0xFF8D6E63),
            ),
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget _buildFormField(String type) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          const Radius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: FormBuilderTextField(
                controller: type == 'description'
                    ? descriptionController
                    : titleController,
                attribute: type,
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'OpenSans',
                    fontSize: 15),
                maxLines: type == 'description' ? null : 1,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.grey[500],
                    width: 2,
                  )),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  hintText: 'Enter your $type',
                  hintStyle: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'OpenSans',
                      fontSize: 15),
                ),
                validators: [
                  FormBuilderValidators.required(
                      errorText: 'Please enter your $type')
                ]),
          ),
        ],
      ),
    );
  }
}
