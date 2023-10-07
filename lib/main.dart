import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:login_and_register/screens/forget_password.dart';
import 'package:login_and_register/model/profileModel.dart';
import 'package:login_and_register/screens/register.dart';
import 'package:login_and_register/utils/Utility.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import 'screens/profile.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Future<bool> isLoad = Future<bool>.value(true);
  late SimpleFontelicoProgressDialog _dialog;
  bool hidePassword = true;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _dialog = SimpleFontelicoProgressDialog(context: this.context, barrierDimisable: false);
    _asyncMethod();
  }

  Future<void> _asyncMethod() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(

      child: FutureBuilder(
        future: isLoad,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return getBody();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ));

  Widget getBody() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Title(
        color: Colors.white,
        child: Scaffold(
          body:
          Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child:
                Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Image.asset('assets/images/logo.png',
                          width: 350,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              width: 400,
                              child:     Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25, right: 10, top: 10),
                                      child: Text(
                                        "เข้าสู่ระบบ",
                                        style: GoogleFonts.getFont('Kanit',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            color:  Colors.black54),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 0),
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: TextFormField(

                                          controller: usernameController,
                                          inputFormatters: [
                                            new LengthLimitingTextInputFormatter(
                                                13), // for mobile
                                          ],
                                          keyboardType: TextInputType.text,
                                          style: GoogleFonts.getFont('Kanit',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black54),
                                          decoration: InputDecoration(

                                            border: InputBorder.none,
                                            hintText: 'Username',
                                            hintStyle: GoogleFonts.lato(
                                              textStyle: Theme.of(context).textTheme.headline4,
                                              fontSize: 14, fontWeight: FontWeight.bold, height: 2.0,
                                              fontStyle: FontStyle.normal, color: Utility.color3,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: TextFormField(
                                          obscureText: hidePassword,//show/hide password
                                          controller: passController,
                                          keyboardType: TextInputType.text,
                                          inputFormatters: [
                                            new LengthLimitingTextInputFormatter(
                                                10), // for mobile
                                          ],
                                          style: GoogleFonts.getFont('Kanit',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black54),
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
                                            border: InputBorder.none,
                                            hintText: 'Password',
                                            hintStyle: GoogleFonts.lato(
                                              textStyle: Theme.of(context).textTheme.headline4,
                                              fontSize: 14, fontWeight: FontWeight.bold, height: 2.0,
                                              fontStyle: FontStyle.normal, color: Utility.color3,),
                                          ),
                                        ),
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
                                              child:_forgetPassword(),
                                            )
                                        ),
                                      ]),

                                  //login button
                                  Center(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 20),
                                            child:
                                            GestureDetector(
                                              onTap: () async {
                                                String  username = usernameController.text.toString().trim();
                                                String  password = passController.text.toString().trim();
                                                if(username.isEmpty || password.isEmpty){
                                                  _dialogsCheck(context);
                                                }else{
                                                  DocumentReference doc_username = FirebaseFirestore.instance.collection("users").doc(username);
                                                  await doc_username.get().then((doc) async {
                                                    if (doc.exists) {
                                                      String resUsername = doc['username'].toString();
                                                      String resPassword = doc['password'].toString();
                                                      String resConfirmPassword = doc['confirm_password'].toString();
                                                      String resFirstLast = doc['firstLast'].toString();
                                                      String resProfileUrl = doc['profileUrl'].toString();
                                                      String resPhone = doc['phone'].toString();

                                                      if(resUsername.endsWith(username) && resPassword.endsWith(password)){
                                                        profileModel model = new profileModel(resUsername,
                                                            resPassword, resConfirmPassword,
                                                            resFirstLast, resProfileUrl, resPhone);
                                                        _dialog.show(message: 'กำลังเข้าสู่ระบบ...', type: SimpleFontelicoProgressDialogType.normal);
                                                        await Future.delayed(Duration(seconds: 2));
                                                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder: (BuildContextcontext) {return Profile(username: username,model: model,);},), (_) => false,
                                                        );

                                                      }else{
                                                        _dialogs(context);
                                                      }
                                                      log(resUsername +" : " + resPassword);
                                                    } else {
                                                      _dialogs(context);
                                                      print('Document does not exist.');
                                                    }
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 370,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Utility.color4, Utility.color4,],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(5, 5),
                                                      blurRadius: 10,
                                                    )
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text('เข้าสู่ระบบ',
                                                    style: GoogleFonts.getFont('Kanit', fontSize: 16, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, color: Colors.white),
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
                                            child:   _notRegister()
                                        ),
                                        Text("", maxLines: 1,
                                        ),
                                      ]),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }

  Future _dialogs(context) {
    return
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("แจ้งเตือน"),
            content: new Text("Username หรือ Pssword ไม่ถูกต้อง"),
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
  Widget _forgetPassword() {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child:   GestureDetector(
                    onTap: () async {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()),);
                    },
                    child:
                    Text("ลืมรหัสผ่าน",
                      style: GoogleFonts.getFont('Kanit',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _notRegister() {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child:    GestureDetector(
                    onTap: () async {

                    },
                    child:
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 20),
                          child: Text("คุณยังไม่มีบัญชีผู้ใช้งาน ? ",
                            style: GoogleFonts.getFont('Kanit',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                color: Utility.color8),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 20),
                          child:   GestureDetector(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()),);
                            },
                            child:
                            Text("สมัครสมาชิก",
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
