import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:login_and_register/screens/change_password.dart';
import 'package:login_and_register/main.dart';
import 'package:login_and_register/model/profileModel.dart';
import 'package:login_and_register/utils/Utility.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class Profile extends StatefulWidget {
  final String? username;
  final profileModel? model;
  const Profile({Key? key,this.username,this.model}) : super(key: key);

  @override
  State<Profile> createState() => ProfileState(this.username,this.model);
}

class ProfileState extends State<Profile> {
  String? username;
  profileModel? model;
  ProfileState(this.username,this.model);
  Future<bool> isLoad = Future<bool>.value(true);
  late SimpleFontelicoProgressDialog _dialog;
  bool hidePassword = true;
  bool hideFnameLname= true;
  bool hidePhone = true;
  bool hideUsername = true;
  TextEditingController fnameLnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passWordController = new TextEditingController();
  String? name_lastname;
  String? phone;
  String? usernames;
  String? password;
  String? profileUrl = "no image";

  @override
  void initState() {
    super.initState();
    _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);
    _asyncMethod();
  }

  Future<void> _asyncMethod() async {
    fnameLnameController.text = "ชื่อ : "+model!.firstLast.toString();
    phoneController.text = "เบอร์โทร : "+model!.phone.toString();
    usernameController.text = "username : "+model!.username.toString();
    passWordController.text = model!.password.toString();
    profileUrl = model!.profileUrl.toString();

    // DocumentReference doc_ref=FirebaseFirestore.instance.collection("users").doc(username);
    // await doc_ref.get().then((doc){
    //   if (doc.exists) {
    //      name_lastname = doc['firstLast'].toString();
    //      phone = doc['phone'].toString();
    //      usernames = doc['username'].toString();
    //      password = doc['password'].toString();
    //      profileUrl = doc['profileUrl'].toString();
    //
    //      fnameLnameController.text = "ชื่อ : "+name_lastname.toString();
    //      phoneController.text = "เบอร์โทร : "+phone.toString();
    //      usernameController.text = "username : "+usernames.toString();
    //      passWordController.text = password.toString();
    //
    //   } else {
    //
    //     print('Document does not exist.');
    //   }
    // });

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
                        padding: const EdgeInsets.only(left: 0, right: 0, top: 100),
                        child: Text(
                          "เข้าสู่ระบบสำเร็จ",
                          style: GoogleFonts.getFont('Kanit',
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color:  Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child:  Column(
                          children: [
                            if (profileUrl.toString().endsWith("no image")) ...[
                              Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),),)
                              )
                            ] else ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(60), // Image radius
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    profileUrl.toString(), width: 150, height: 150,),
                                ),
                              )

                           ],
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0, left: 10, right: 10, bottom: 0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 400,
                              child:     Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25, right: 10, top: 10,bottom: 5),
                                      child: Text(
                                        "ส่วนตัว",
                                        style: GoogleFonts.getFont('Kanit',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            color:  Colors.black54),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2, left: 20, right: 20, bottom: 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: TextFormField(
                                          controller: fnameLnameController,
                                          inputFormatters: [
                                            new LengthLimitingTextInputFormatter(
                                                13), // for mobile
                                          ],
                                          keyboardType: TextInputType.number,
                                          style: GoogleFonts.getFont('Kanit',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black54),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: hideFnameLname
                                                  ? Icon(Icons.visibility_off,color: Utility.color7,)
                                                  : Icon(Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  hideFnameLname = !hideFnameLname;
                                                });
                                              },),
                                            border: InputBorder.none,
                                            hintText:
                                            'ชื่อ :',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1, left: 20, right: 20, bottom: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: TextFormField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.number,
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
                                              icon: hidePhone
                                                  ? Icon(Icons.visibility_off,color: Utility.color7,)
                                                  : Icon(Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  hidePhone = !hidePhone;
                                                });
                                              },),
                                            border: InputBorder.none,
                                            hintText: 'เบอร์โทร :',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25, right: 10, top: 10),
                                      child: Text(
                                        "บัญชี",
                                        style: GoogleFonts.getFont('Kanit',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            color:  Colors.black54),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2, left: 20, right: 20, bottom: 0),
                                    child: Container(
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
                                          keyboardType: TextInputType.number,
                                          style: GoogleFonts.getFont('Kanit',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black54),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: hideUsername
                                                  ? Icon(Icons.visibility_off,color: Utility.color7,)
                                                  : Icon(Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  hideUsername = !hideUsername;
                                                });
                                              },),
                                            border: InputBorder.none,
                                            hintText:
                                            'username :',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1, left: 20, right: 20, bottom: 15),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Utility.color6,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child:
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:<Widget> [

                                              Padding(
                                                  padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    child:   Row(
                                                      children: [
                                                        Text("password : ", maxLines: 1,
                                                          style: GoogleFonts.getFont('Kanit',
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w400,
                                                              fontStyle: FontStyle.normal,
                                                              color:  Colors.black54),),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
                                                          child: Text("******", maxLines: 1,
                                                              style: GoogleFonts.getFont('Kanit',
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontStyle: FontStyle.normal,
                                                                  color:Colors.black54)),
                                                        ),
                                                      ],
                                                    )
                                                  )
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(left: 0, right: 20, top: 20, bottom: 0),
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(username: username,)),);
                                                      },
                                                      child:
                                                      Text("เปลี่ยนรหัสผ่าน", maxLines: 1,
                                                        style: GoogleFonts.getFont('Kanit',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                            fontStyle: FontStyle.normal,
                                                            color: Utility.color2),),
                                                  ),
                                                  ),
                                            ]),
                                      ),
                                    ),
                                  ),

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

                                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                    context) {return MyApp();},
                                                  ), (_) => false,
                                                );
                                              },
                                              child: Container(
                                                width: 370,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Utility.color4, Utility.color4,
                                                    ],
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
                                                  child: Text('ล็อกเอ้า',
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
}
