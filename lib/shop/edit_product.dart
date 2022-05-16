import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/shop/constants/app_color.dart';
import 'package:brekete_connect/shop/constants/text_styles.dart';
import 'package:brekete_connect/shop/model/product.dart';
import 'package:brekete_connect/shop/my_products.dart';
import 'package:brekete_connect/shop/utils/app_navigator.dart';
import 'package:brekete_connect/shop/utils/custom_button.dart';
import 'package:brekete_connect/shop/utils/feild_validator.dart';
import 'package:brekete_connect/shop/utils/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProduct extends StatefulWidget {
  const EditProduct(this.product, {Key key}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
  final Product product;
}

class _EditProductState extends State<EditProduct> {
  double height;
  double width;
  String chosenValueDrop;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> _images = [];
  List<String> mylist = [
    'Electronic Devices',
    'Electronic Accessories',
    'Home Appliances',
    'Health & Beauty',
    'Babies & Toys',
    'Groceries & Pets',
    'Watches & Bags',
    'Jewellery',
    'Men\'s Fashion',
    'Women\'s Fashion',
    'Sports & Outdoors',
    'Digital Products'
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.product.title;
    _desController.text = widget.product.description;
    _priceController.text = widget.product.price;
    chosenValueDrop = widget.product.category;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit your products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: width * 0.9,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Name', style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    myTextField(
                        controller: _titleController,
                        label: 'Enter your product name',
                        validator: FieldValidator.validateField),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Description',
                            style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField.myTextField(
                        controller: _desController,
                        maxLines: 3,
                        label: 'Enter your product description',
                        validator: FieldValidator.validateField),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Price', style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    myTextField(
                        controller: _priceController,
                        label: 'Enter your product price',
                        keyboardType: TextInputType.phone,
                        validator: FieldValidator.validateField),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Category',
                            style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    myDropDown(),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final List<XFile> images = await _picker.pickMultiImage(
                            maxHeight: 720, maxWidth: 720, imageQuality: 60);
                        if (images.isNotEmpty) {
                          if (images.length > 5) {
                            _images = images
                                .sublist(0, 5)
                                .map((e) => File(e.path))
                                .toList();
                            setState(() {});
                          } else {
                            _images = images.map((e) => File(e.path)).toList();
                            setState(() {});
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: AppColor.primaryColor),
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 24.0,
                      ),
                      label: Text(
                        'Pick Some Images',
                        style: AppTextStyles.headingText
                            .copyWith(color: AppColor.whiteColor),
                      ),
                    ),
                    Wrap(
                        children: _images.isEmpty
                            ? widget.product.photos
                                .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                            child: CachedNetworkImage(
                                          imageUrl: e,
                                          fit: BoxFit.cover,
                                        )))))
                                .toList()
                            : _images
                                .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          child: Image.file(
                                            e,
                                            fit: BoxFit.cover,
                                          ),
                                        ))))
                                .toList()),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    CustomButton.myButton('Update Product', () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          if (_images.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            List<dynamic> imgUrls =
                                (await uploadImage(_images));
                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(widget.product.id)
                                .update({
                              'photo_url': imgUrls,
                            });
                            Fluttertoast.showToast(
                                msg: 'Product images updated Successfully!');
                            AppNavigator.pop(context);
                            //AppNavigator.makeFirst(context, const MyProducts());

                            setState(() {
                              isLoading = false;
                            });
                          }
                          if (_titleController.text != widget.product.title) {
                            setState(() {
                              isLoading = true;
                            });

                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(widget.product.id)
                                .update({
                              'title': _titleController.text,
                            });
                            Fluttertoast.showToast(
                                msg: 'Product title updated Successfully!');
                            AppNavigator.pop(context);
                            //AppNavigator.makeFirst(context, const MyProducts());

                            setState(() {
                              isLoading = false;
                            });
                          }
                          if (_desController.text !=
                              widget.product.description) {
                            setState(() {
                              isLoading = true;
                            });

                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(widget.product.id)
                                .update({
                              'description': _desController.text,
                            });
                            Fluttertoast.showToast(
                                msg:
                                    'Product description updated Successfully!');
                            AppNavigator.pop(context);
//AppNavigator.makeFirst(context, const MyProducts());

                            setState(() {
                              isLoading = false;
                            });
                          }
                          if (_priceController.text != widget.product.price) {
                            setState(() {
                              isLoading = true;
                            });

                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(widget.product.id)
                                .update({
                              'price': _priceController.text,
                            });
                            Fluttertoast.showToast(
                                msg: 'Product price updated Successfully!');
                            AppNavigator.pop(context);
                            //AppNavigator.makeFirst(context, const MyProducts());

                            setState(() {
                              isLoading = false;
                            });
                          }
                          if (chosenValueDrop != widget.product.category) {
                            setState(() {
                              isLoading = true;
                            });

                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(widget.product.id)
                                .update({
                              'category': chosenValueDrop,
                            });
                            Fluttertoast.showToast(
                                msg: 'Product category updated Successfully!');
                            AppNavigator.pop(context);
                            // AppNavigator.makeFirst(context, const MyProducts());

                            setState(() {
                              isLoading = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(msg: 'Something went Wrong!');
                        }
                      }
                    }, AppColor.primaryColor, width * 0.7, height: 35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myDropDown({Color iconColor}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        child: DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FieldValidator.validateDropDown,
          iconSize: 30,
          value: chosenValueDrop,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: 'Please select category',
            errorText: null,
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            hintStyle: TextStyle(
              color: AppColor.fadeColor,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.fadeColor,
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
          ),
          style: const TextStyle(color: Colors.white),
          items: mylist.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppTextStyles.simpleText.copyWith(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            chosenValueDrop = value;
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<List> uploadImage(List<File> img) async {
    List<String> urls = [];
    try {
      for (var item in img) {
        TaskSnapshot task = await FirebaseStorage.instance
            .ref('images/${Timestamp.now().toString()}.png')
            .putFile(item);
        String url = await task.ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      return urls;
    }
  }

  Future<void> _uploadToFireStore(List urls) async {
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('ads').doc();
    String docRefId = docRef.id;
    await docRef.set({
      'created_at': Timestamp.now(),
      'user_id': CurrentAppUser.currentUserData.userId,
      'ad_id': docRefId,
      'title': _titleController.text,
      'description': _desController.text,
      'price': _priceController.text,
      'category': chosenValueDrop,
      'photo_url': urls,
      'status': 'unsold'
    });
  }
}
