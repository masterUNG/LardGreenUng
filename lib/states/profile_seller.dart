// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lardgreenung/models/user_model.dart';
import 'package:lardgreenung/utility/my_constant.dart';
import 'package:lardgreenung/utility/my_dialog.dart';
import 'package:lardgreenung/widgets/show_button.dart';
import 'package:lardgreenung/widgets/show_icon_button.dart';
import 'package:lardgreenung/widgets/show_image.dart';
import 'package:lardgreenung/widgets/show_progess.dart';
import 'package:lardgreenung/widgets/show_text.dart';

class ProfileSeller extends StatefulWidget {
  final String docIdUser;
  const ProfileSeller({
    Key? key,
    required this.docIdUser,
  }) : super(key: key);

  @override
  State<ProfileSeller> createState() => _ProfileSellerState();
}

class _ProfileSellerState extends State<ProfileSeller> {
  UserModle? userModle;
  File? file;
  String? docIdUser;
  bool load = true;

  @override
  void initState() {
    super.initState();
    docIdUser = widget.docIdUser;
    readProfileData();
  }

  Future<void> readProfileData() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docIdUser)
        .get()
        .then((value) {
      userModle = UserModle.fromMap(value.data()!);
      print('userModel ==>> ${userModle!.toMap()}');
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load ? const ShowProgress() : newContent(context);
  }

  Padding newContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
            width: 250,
            height: 250,
            child: Stack(
              children: [
                file == null ? newImage() : Image.file(file!),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: ShowIconButton(
                    iconData: Icons.add_a_photo,
                    pressFunc: () {
                      MyDialog(context: context).actionDialog(
                          title: 'รูปหน้าร้าน ?',
                          message: 'กรุณา ถ่ายรูป หรือ เลือกรูปจาก คลังภาพ',
                          label1: 'ถ่ายรูปจากกลัอง',
                          label2: 'คลังภาพ',
                          presFunc1: () {
                            Navigator.pop(context);
                            processTakePhoto(source: ImageSource.camera);
                          },
                          presFunc2: () {
                            Navigator.pop(context);
                            processTakePhoto(source: ImageSource.gallery);
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
          newDetail(head: 'ร้าน :', value: userModle!.name),
          newDetail(head: 'ที่อยู่ :', value: userModle!.address),
          newDetail(head: 'โทรศัพย์ :', value: userModle!.phone),
          file == null
              ? const SizedBox()
              : ShowButton(
                  label: 'Update Profile',
                  pressFunc: () {
                    processUpdateProfile();
                  }),
        ],
      ),
    );
  }

  Future<void> processTakePhoto({required ImageSource source}) async {
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    setState(() {
      file = File(result!.path);
    });
  }

  Padding newImage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: userModle!.urlAvatar!.isEmpty
          ? const ShowImage(
              path: 'images/shop.png',
            )
          : Image.network(userModle!.urlAvatar!),
    );
  }

  Row newDetail({required String head, required String value}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ShowText(
            lable: head,
            textStyle: MyConstant().h2Style(),
          ),
        ),
        Expanded(
          flex: 2,
          child: ShowText(lable: value),
        ),
      ],
    );
  }

  Future<void> processUpdateProfile() async {
    if (file != null) {
      String nameFile = '$docIdUser${Random().nextInt(100000)}.jpg';
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference reference = firebaseStorage.ref().child('avatar/$nameFile');
      UploadTask uploadTask = reference.putFile(file!);
      await uploadTask.whenComplete(() async {
        await reference.getDownloadURL().then((value) {
          String urlAvatar = value;
          Map<String, dynamic> map = {};
          map['urlAvatar'] = urlAvatar;
          editDatabase(map: map);
        });
      });
    }
  }

  Future<void> editDatabase({required Map<String, dynamic> map}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docIdUser)
        .update(map)
        .then((value) {
      MyDialog(context: context).normalDialog(
          title: 'Update Profile', message: 'Update Profile Success');
      file = null;
      readProfileData();
    });
  }
}
