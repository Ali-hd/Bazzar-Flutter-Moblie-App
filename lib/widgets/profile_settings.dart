import 'dart:convert';
import 'dart:io';
import 'package:bazzar/Providers/providers.dart';
import 'package:bazzar/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bazzar/services/api.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfileSettings({Key key, this.user}) : super(key: key);
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  void initState() {
    super.initState();
    profileImg = widget.user['profileImg'];
  }

  String profileImg;
  bool uploadingImage = false;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context, listen: false);
    _submitForm(Map values) async {
      print(values);
      final data = EditProfile(
        firstname: values['firstname'],
        description: values['description'],
        location: values['location'],
        profileImg: profileImg,
      );
      final res = await providerUser.editProfile(widget.user['username'], data);
      print(res);
      if (res != null) {
        _fbKey.currentState.reset();
        Navigator.pop(context);
        // showAlert(context, true);
      } else {
        // showAlert(context, false);
      }
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'firstname': widget.user['firstName'],
                    'description': widget.user['description'],
                    'location': widget.user['location']
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: profileImg,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 110,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          padding: EdgeInsets.all(40),
                                          width: 110,
                                          height: 110,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                const Color(0xFF8D6E63)),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          radius: 55,
                                          backgroundImage: NetworkImage(
                                              'https://i.imgur.com/iV7Sdgm.jpg'),
                                        ),
                                      ),
                                      Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: ClipOval(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              color: const Color(0xFF8D6E63),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text('Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(height: 10),
                            _buildFormField('firstname'),
                            SizedBox(height: 20),
                            Text('Bio',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(height: 10),
                            _buildFormField('description'),
                            SizedBox(height: 20),
                            Text('Location',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(height: 10),
                            _buildFormField('location'),
                            SizedBox(height: 20),
                            _buildSaveButton(_submitForm)
                          ])),
                )
              ],
            ),
          ),
        ),
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
              attribute: type,
              style: TextStyle(
                  color: Colors.black87, fontFamily: 'OpenSans', fontSize: 15),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(Function _submitForm) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        width: 130,
        child: RaisedButton(
            elevation: 5.0,
            padding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: const Color(0xFF8D6E63),
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            onPressed: () async {
              // if (loading) {
              //   return false;
              // }
              // if (images.length < 1) {
              //   setState(() {
              //     didUploadError = true;
              //   });
              // }
              if (_fbKey.currentState.saveAndValidate()) {
                _submitForm(_fbKey.currentState.value);
              }
            }),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () async {
                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void uploadImage(File imageFile) async {
    final response = await API().uploadImage(imageFile);
    response.stream.transform(utf8.decoder).listen((value) {
      setState(() {
        profileImg = jsonDecode(value)['imageUrl'];
        uploadingImage = false;
      });
    });
  }

  void _pickImage(ImageSource source) async {
    PickedFile pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      uploadingImage = true;
    });
    if (pickedFile != null) {
      uploadImage(File(pickedFile.path));
    }
  }
}
