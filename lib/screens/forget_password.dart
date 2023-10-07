import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:login_and_register/main.dart';
import 'package:login_and_register/services/database.dart';
import 'package:login_and_register/utils/Utility.dart';
import 'package:path/path.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late SimpleFontelicoProgressDialog _dialog;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  Future<bool> isLoad = Future<bool>.value(false);
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String? downloadUrl = "";
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    _dialog = SimpleFontelicoProgressDialog(context: this.context, barrierDimisable: false);
    _asyncMethod();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
      downloadUrl = await ref.getDownloadURL();
      setState(() {
        log(downloadUrl.toString());
      });
    } catch (e) {
      print('error occured');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }


  Future<void> _asyncMethod() async {


    await Future.delayed(Duration(seconds: 1));
    isLoad = Future<bool>.value(true);
    setState(() {});
  }

  Future<void> _deleteImage() async {
    setState(() {
      _photo = null;
    });
  }

  String generateRandomString(int len) {
    var r = m.Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var textStyle = Theme.of(context).textTheme;


    return Title(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Image.asset('assets/images/logo.png',
                      width: 250,
                      height: 120,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
                                child: Text("ตั้งรหัสผ่านใหม่", style: GoogleFonts.getFont('Kanit',
                                    fontSize: 20, fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal, color: Colors.black54),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                  child: Center(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color:Utility.color6,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          height: 55,
                                          padding: EdgeInsets.all(5.0),
                                          child: TextField(
                                            controller: usernameController,
                                            autocorrect: true,
                                            style: GoogleFonts.getFont('Kanit',
                                                fontSize: 15, fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal, color: Colors.black54),
                                            decoration: InputDecoration(
                                              hintText: 'username',
                                              hintStyle: GoogleFonts.lato(
                                                textStyle: Theme.of(context).textTheme.headline4,
                                                fontSize: 14, fontWeight: FontWeight.bold, height: 2.0,
                                                fontStyle: FontStyle.normal, color: Utility.color3,),
                                              filled: true, border: InputBorder.none, fillColor: Utility.color6,
                                            ),
                                          )))),
                              Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                  child: Center(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Utility.color6,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          height: 55,
                                          padding: EdgeInsets.all(5.0),
                                          child: TextField(
                                            obscureText: hidePassword,
                                            controller: newPasswordController,
                                            autocorrect: true,
                                            style: GoogleFonts.getFont('Kanit',
                                                fontSize: 15, fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal, color:Colors.black54),
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: hidePassword
                                                    ? Icon(Icons.visibility_off,color: Utility.color7,)
                                                    : Icon(Icons.visibility),
                                                onPressed: () {
                                                  setState(() {
                                                    hidePassword = !hidePassword;
                                                  });
                                                },),
                                              hintText: 'new password',
                                              hintStyle: GoogleFonts.lato(
                                                textStyle: Theme.of(context).textTheme.headline4,
                                                fontSize: 14, fontWeight: FontWeight.bold, height: 2.0,
                                                fontStyle: FontStyle.normal, color: Utility.color3,),
                                              filled: true, border: InputBorder.none, fillColor: Utility.color6,
                                            ),
                                          )))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 20, right: 10, top: 10),
                            child: GestureDetector(
                              onTap: () async {

                                String username = usernameController.text.toString();
                                String newPassword = newPasswordController.text.toString();

                                if(username.isEmpty || newPassword.isEmpty){
                                  _dialogsCheck(context);
                                }else{
                                  DocumentReference doc_username = FirebaseFirestore.instance.collection("users").doc(username);
                                  await doc_username.get().then((doc) async {
                                    if (doc.exists) {
                                      String resUsername = doc['username'].toString();
                                      if(resUsername.endsWith(username)){
                                        _dialog.show(message: 'รอสักครู่...', type: SimpleFontelicoProgressDialogType.normal);
                                        await DatabaseService().updatePasswords(username: username.toString().trim(), password: newPassword.toString().trim());
                                        _dialogsSuccess(context);
                                      }else{
                                        _dialogs(context,"Username ไม่ถูกต้อง");
                                      }

                                    } else {
                                      _dialogs(context,"Username ไม่ถูกต้อง");
                                      print('Document does not exist.');
                                    }
                                  });
                                }
                              },
                              child: Container(
                                width: 380,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Utility.color4,
                                      Utility.color4,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'ลืมรหัสผ่าน',
                                    style: GoogleFonts.getFont('Kanit',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      )
      );

  }
  Future _dialogs(context,title) {
    return
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("แจ้งเตือน"),
            content: new Text(title),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                child:  GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    decoration:
                    BoxDecoration(gradient:
                    LinearGradient(colors: [Utility.color5, Utility.color5,], begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                      borderRadius:
                      BorderRadius.circular(70),
                      boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(5, 5), blurRadius: 10,
                      )
                      ],
                    ),
                    child: Center(
                      child: Text('ตกลง', style: GoogleFonts.getFont('Kanit', fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),



            ],
          );
        },
      );
  }
  Future _dialogsSuccess(context) {
    _dialog.hide();
    return
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("แจ้งเตือน"),
            content: new Text("ตั้งรหัสผ่านใหม่สำเร็จ"),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                child:  GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContextcontext) {return MyApp();},), (_) => false,
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration:
                    BoxDecoration(gradient:
                    LinearGradient(colors: [Utility.color4, Utility.color4,], begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                      borderRadius:
                      BorderRadius.circular(70),
                      boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(5, 5), blurRadius: 10,
                      )
                      ],
                    ),
                    child: Center(
                      child: Text('ตกลง', style: GoogleFonts.getFont('Kanit', fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          );
        },
      );
  }
  Future _dialogsCheck(context) {
    return
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("แจ้งเตือน"),
            content: new Text("กรุณากรอกข้อมูลให้ครบ"),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                child:  GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    decoration:
                    BoxDecoration(gradient:
                    LinearGradient(colors: [Utility.color5, Utility.color5,], begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                      borderRadius:
                      BorderRadius.circular(70),
                      boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(5, 5), blurRadius: 10,
                      )
                      ],
                    ),
                    child: Center(
                      child: Text('ตกลง', style: GoogleFonts.getFont('Kanit', fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),



            ],
          );
        },
      );
  }

}
