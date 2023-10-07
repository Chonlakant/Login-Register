import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:login_and_register/main.dart';
import 'package:login_and_register/screens/profile.dart';
import 'package:login_and_register/services/database.dart';
import 'package:login_and_register/utils/Utility.dart';
import 'package:path/path.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late SimpleFontelicoProgressDialog _dialog;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController firsttLastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  Future<bool> isLoad = Future<bool>.value(false);

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String? downloadUrl = "";

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
                      width: 350,
                      height: 120,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
                                  child: Text("สมัครสมาชิก", style: GoogleFonts.getFont('Kanit',
                                      fontSize: 20, fontWeight: FontWeight.w500,
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

                                          hintText: 'Username',
                                          hintStyle: GoogleFonts.lato(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 12, fontWeight: FontWeight.bold,
                                            height: 2.0, fontStyle: FontStyle.normal, color: Utility.color3,),
                                          filled: true,
                                          border: InputBorder.none,
                                          fillColor: Utility.color6,
                                        ),
                                      ),
                                    ),
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
                                              controller: passwordController,
                                              autocorrect: true,
                                              style: GoogleFonts.getFont('Kanit',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.black54),
                                              decoration: InputDecoration(
                                                hintText: 'Password',
                                                hintStyle: GoogleFonts.lato(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  height: 2.0,
                                                  fontStyle: FontStyle.normal,
                                                  color: Utility.color3,),
                                                filled: true,
                                                border: InputBorder.none,
                                                fillColor: Utility.color6,
                                              ),
                                            )))),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                  child: Center(
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      child: TextField(
                                        controller: confirmPasswordController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        minLines: 1,
                                        autocorrect: true,
                                        style: GoogleFonts.getFont('Kanit',
                                            fontSize: 15, fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal, color: Colors.black54),
                                        decoration: InputDecoration(
                                          hintText: 'Comfirm Password',
                                          hintStyle: GoogleFonts.lato(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            height: 2.0,
                                            fontStyle: FontStyle.normal,
                                            color: Utility.color3,
                                          ),
                                          filled: true,
                                          border: InputBorder.none,
                                          fillColor: Utility.color6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                  child: Center(
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      child: TextField(
                                        maxLength: 10,
                                        keyboardType: TextInputType.phone,
                                        controller: phoneController,
                                        maxLines: 5,
                                        minLines: 1,
                                        autocorrect: true,
                                        style: GoogleFonts.getFont('Kanit',
                                            fontSize: 15, fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal, color: Colors.black54),
                                        decoration: InputDecoration(
                                          hintText: 'Phone',
                                          counterText: "",
                                          hintStyle: GoogleFonts.lato(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            height: 2.0,
                                            fontStyle: FontStyle.normal,
                                            color: Utility.color3,
                                          ),
                                          filled: true,
                                          border: InputBorder.none,
                                          fillColor: Utility.color6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 10,bottom: 10),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      height: 55,
                                      padding: EdgeInsets.all(5.0),
                                      child: TextField(
                                        controller: firsttLastNameController,
                                        autocorrect: true,
                                        style: GoogleFonts.getFont('Kanit',
                                            fontSize: 15, fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal, color: Colors.black54),
                                        decoration: InputDecoration(
                                          hintText: 'ชื่อ-นามสกุล',
                                          hintStyle: GoogleFonts.lato(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            height: 2.0,
                                            fontStyle: FontStyle.normal,
                                            color: Utility.color3,
                                          ),
                                          filled: true,
                                          border: InputBorder.none,
                                          fillColor: Utility.color6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                                  child: GestureDetector(
                                    onTap: () async {
                                      _showPicker(context);
                                    },
                                    child:
                                    Center(
                                      child: _photo != null ?
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: <Widget>[
                                          Container(
                                            width: 380,
                                            height: 170,
                                            child: Image.file(_photo!,fit: BoxFit.fill,),
                                          ),
                                          Positioned(
                                            child:
                                            GestureDetector(
                                              onTap: () async {
                                                _deleteImage();
                                              },
                                              child:
                                              Image.asset('assets/images/ic_delete.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                            right: 0,
                                            left: 0,
                                            bottom: -1,
                                          ),
                                        ],
                                      ) :Container(
                                          height: 170,
                                          width: 380,
                                          color: Utility.color6,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(padding: EdgeInsets.only(top: 10),
                                                child: Image.asset('assets/images/ic_plus.png', width: 50, height: 50,),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  'อัพโหลดภาพถ่ายประจำตัว',
                                                  style: GoogleFonts.getFont('Kanit',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400,
                                                      fontStyle: FontStyle.normal,
                                                      color: Utility.color3),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),

                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                            child:
                            GestureDetector(
                              onTap: () {
                                String username = usernameController.text.toString();
                                String password = passwordController.text.toString();
                                String confirmPassword = confirmPasswordController.text.toString();
                                String firstLast = firsttLastNameController.text.toString();
                                String phone = phoneController.text.toString();

                                log("downloadUrl"+downloadUrl.toString());

                                if(username.isEmpty || password.isEmpty || confirmPassword.isEmpty ||
                                    firstLast.isEmpty || phone.isEmpty || _photo == null){
                                  _dialogsCheck(context);
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0))),
                                        contentPadding: EdgeInsets.only(top: 10.0),
                                        content: Container(
                                          width: 200.0,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Center(
                                                child: Text("แจ้งเตือน",
                                                    style: GoogleFonts.getFont('Kanit',
                                                        fontSize: 24, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Utility.color3)),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                height: 4.0,
                                              ),
                                              Center(
                                                child: Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10, top: 5),
                                                  child: Text("คุณต้องการสมัครสมาชิกใช่หรือไม่", style: GoogleFonts.getFont('Kanit', fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Utility.color3)),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(flex: 1,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 20),
                                                          child: GestureDetector(
                                                            onTap: () async {
                                                              _dialog.show(message: 'รอสักครู่...', type: SimpleFontelicoProgressDialogType.normal);
                                                              await Future.delayed(Duration(seconds: 5));
                                                              await DatabaseService().createUser(username: username, password: password.trim(),
                                                                  confirm_password: confirmPassword.trim(),firstLast: firstLast,
                                                                  profileUrl: downloadUrl.toString(),
                                                                  phone: phone.toString());

                                                              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                  context) {
                                                                    return Profile(username: username.toString(),);
                                                                  },
                                                                ),
                                                                    (_) => false,
                                                              );

                                                            },
                                                            child: Container(
                                                              width: 180,
                                                              height: 50,
                                                              decoration:
                                                              BoxDecoration(
                                                                gradient:
                                                                LinearGradient(
                                                                  colors: [Utility.color4, Utility.color4,],
                                                                  begin: Alignment.topLeft,
                                                                  end: Alignment.bottomRight,),
                                                                borderRadius: BorderRadius.circular(70),
                                                                boxShadow: [
                                                                  BoxShadow(color: Colors.black12, offset: Offset(5, 5), blurRadius: 10,
                                                                  )
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text('ตกลง', style: GoogleFonts.getFont('Kanit',
                                                                    fontSize: 15, fontWeight:
                                                                    FontWeight.w400,
                                                                    fontStyle: FontStyle.normal,
                                                                    color: Colors.white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20,
                                                              top: 10,
                                                              bottom: 20),
                                                          child:

                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              width: 180,
                                                              height: 50,
                                                              decoration:
                                                              BoxDecoration(
                                                                gradient:
                                                                LinearGradient(
                                                                  colors: [Utility.color5, Utility.color5,
                                                                  ],
                                                                  begin: Alignment.topLeft,
                                                                  end: Alignment.bottomRight,
                                                                ),
                                                                borderRadius:
                                                                BorderRadius.circular(70),
                                                                boxShadow: [
                                                                  BoxShadow(color: Colors.black12,
                                                                    offset: Offset(5, 5),
                                                                    blurRadius: 10,
                                                                  )
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text('ยกเลิก',
                                                                  style: GoogleFonts.getFont(
                                                                      'Kanit', fontSize: 15,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                      fontStyle:
                                                                      FontStyle.normal,
                                                                      color: Colors.white),
                                                                ),
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
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }

                              },
                              child: Container(
                                width: 380,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Utility.color4, Utility.color4,],
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
                                    'สมัครสมาชิก',
                                    style: GoogleFonts.getFont('Kanit',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
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

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget> [
                        Text("", maxLines: 1,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20, right: 22, top: 0, bottom: 20),
                            child: Container(
                              alignment: Alignment.centerRight,
                              child:   Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child:  _haveLogin(context)
                              ),
                            )
                        ),
                        Text("", maxLines: 1,
                        ),
                      ]),

                ],
              )),
        ),
      )
      );

  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  Widget _haveLogin(context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child:
                  GestureDetector(
                      onTap: () async {

                      },
                      child:
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 20),
                            child: Text("คุณมีบัญชีผู้ใช้งานแล้ว ? ",
                              style: GoogleFonts.getFont('Kanit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: Utility.color8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 20),
                            child:   GestureDetector(
                              onTap: () async {
                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (BuildContext
                                    context) {
                                      return MyApp();
                                    },
                                  ),
                                      (_) => false,
                                );
                              },
                              child:
                              Text("เข้าสู่ระบบ",
                                style: GoogleFonts.getFont('Kanit',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Utility.color2),
                              ),
                            ),
                          ),
                        ],
                      )


                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
