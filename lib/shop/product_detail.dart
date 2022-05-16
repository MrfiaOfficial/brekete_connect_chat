import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/models/user_model.dart';
import 'package:brekete_connect/pages/lib/chat/chatting_screen.dart';
import 'package:brekete_connect/shop/constants/app_color.dart';
import 'package:brekete_connect/shop/edit_product.dart';
import 'package:brekete_connect/shop/model/product.dart';
import 'package:brekete_connect/shop/utils/app_navigator.dart';
import 'package:brekete_connect/shop/utils/custom_button.dart';
import 'package:brekete_connect/utils/routes.dart';

import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'constants/text_styles.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({this.product, Key key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
  final Product product;
}

class _ProductDetailState extends State<ProductDetail> {
  double height;
  double width;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        /* appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                AppRoutes.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black)),
          title: Text(
            'Product Details',
            style: TextStyle(
              color: Color.fromARGB(255, 49, 76, 190),
            ),
          ),
        ), */
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      enlargeCenterPage: true, viewportFraction: 1),
                  items: widget.product.photos.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            ClipRRect(
                              child: SizedBox(
                                width: width,
                                child: CachedNetworkImage(
                                  imageUrl: i,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Card(
                                      color: AppColor.greyColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                            '${widget.product.photos.indexOf(i) + 1} ' +
                                                '/ ' +
                                                '${widget.product.photos.length}',
                                            style: TextStyle(
                                                color: AppColor.whiteColor)),
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        color: AppColor.leftContainer,
                                        child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.arrow_back,
                                            ))),
                                  )),
                            )
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                Center(
                  child: SizedBox(
                    width: width * 0.95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.product.userId ==
                                CurrentAppUser.currentUserData.userId
                            ? Row(
                                children: [
                                  Text(' Status:',
                                      style: AppTextStyles.smallText),
                                  Switch(
                                      value: widget.product.status,
                                      onChanged: (bool value) {
                                        widget.product.status == true
                                            ? unsold()
                                            : sold();
                                      }),
                                  const Expanded(child: SizedBox()),
                                  myCard('images/delete.png', () {
                                    showConfirmDeleteAlertPopup(context, width,
                                        id: widget.product.id);
                                  }),
                                  myCard('images/edit.png', () {
                                    AppNavigator.push(
                                        context, EditProduct(widget.product));
                                  }),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.product.userId)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      AppUser user =
                                          AppUser.fromMap(snapshot.data.data());
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text('Message: '),
                                          SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChattingScreen(
                                                  appUser: user,
                                                  currentUser: CurrentAppUser
                                                      .currentUserData,
                                                  productInfo:
                                                      'Hey! I am intrested in ${widget.product.title}',
                                                ),
                                              ));
                                            },
                                            child: Icon(
                                              Icons.question_answer,
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      );
                                    }),
                              ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Title:', style: AppTextStyles.mediumText),
                              Text(widget.product.title,
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.description,
                                style: AppTextStyles.simpleText,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price:', style: AppTextStyles.mediumText),
                              Text(widget.product.price + '(NGN)',
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Status:', style: AppTextStyles.mediumText),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                child: widget.product.status == true
                                    ? const Icon(Icons.done_all,
                                        color: Colors.green, size: 18)
                                    : Icon(Icons.fiber_manual_record,
                                        color: AppColor.errorColor, size: 18),
                              ),
                              const SizedBox(width: 5),
                              widget.product.status == true
                                  ? Text('Sold',
                                      style: AppTextStyles.simpleText)
                                  : Text('Unsold',
                                      style: AppTextStyles.simpleText)
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Category:',
                                  style: AppTextStyles.mediumText),
                              Text(widget.product.category,
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Posted on:',
                                  style: AppTextStyles.mediumText),
                              Text(
                                  DateFormat('yMMMd').format(
                                      widget.product.createdAt.toDate()),
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  sold() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({'status': true});
      widget.product.status = true;
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Marked as Sold');
      // AppNavigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  unsold() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({'status': false});
      widget.product.status = false;
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Marked as unold');
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Card myCard(String imageIcon, Function onTap) {
    return Card(
      elevation: 0,
      color: AppColor.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            child: Image.asset(
              imageIcon,
              height: 25,
              width: 25,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showConfirmDeleteAlertPopup(BuildContext context1, double width,
      {String id}) async {
    return showDialog<void>(
      context: context1,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.185,
                    ),
                    Text(
                      'Delete Product',
                      style: AppTextStyles.mediumText
                          .copyWith(color: Colors.black),
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      child: Icon(
                        Icons.close,
                        size: 18,
                        // color: AppColor.greyiconColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Are you sure you want to delete this product?',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          actions: [
            // const Divider(
            //   thickness: 2,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton.myButton(
                  'Cancel',
                  () {
                    Navigator.pop(context);
                  },
                  Colors.white,
                  width * 0.2,
                  sideborderColor: AppColor.fadeColor,
                  textColor: AppColor.fadeColor,
                ),
                CustomButton.myButton('Delete', () async {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(id)
                      .delete();
                  Fluttertoast.showToast(
                    msg: 'The Product has been deleted successfully',
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context1);
                }, Colors.red.withOpacity(0.8), width * 0.2,
                    sideborderColor: Color(0xffDF7878)),
              ],
            ),
          ],
        );
      },
    );
  }
}
