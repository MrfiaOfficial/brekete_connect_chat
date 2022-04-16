import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/shop/add_new_product.dart';
import 'package:group_chat_app/shop/constants/app_color.dart';
import 'package:group_chat_app/shop/constants/text_styles.dart';
import 'package:group_chat_app/shop/model/product.dart';
import 'package:group_chat_app/shop/product_detail.dart';
import 'package:group_chat_app/shop/utils/app_navigator.dart';
import 'package:intl/intl.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key key}) : super(key: key);

  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  double height;
  double width;

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          AppNavigator.push(context, const NewProduct());
        },
        child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 22,
            child: Icon(Icons.add, color: Colors.white)),
      ),
      appBar: AppBar(
        title: Text(
          'My Products',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('user_id',
                  isEqualTo: CurrentAppUser.currentUserData.userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong!');
            }
            if (!snapshot.hasData) {
              return const Text("No Data Found");
            }
            List<QueryDocumentSnapshot> docList = snapshot.data.docs;
            List<Product> products = [];
            docList.forEach((element) {
              Product pro = Product.fromMap(element.data());
              products.add(pro);
            });
            return SizedBox(
              width: width,
              child: products.isEmpty
                  ? Center(child: Text('No Products yet'))
                  : Wrap(
                      alignment: WrapAlignment.center,
                      children: products
                          .map(
                            (e) => SizedBox(
                              width: width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.transparent),
                                  child: Card(
                                    child: InkWell(
                                      onTap: () {
                                        AppNavigator.push(
                                            context, ProductDetail(product: e));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 120,
                                            width: width * 0.5 - 20,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              child: CachedNetworkImage(
                                                  imageUrl: e.photos[0],
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 2, right: 4),
                                            child: Row(
                                              children: [
                                                Text(e.title,
                                                    style: AppTextStyles
                                                        .simpleText),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 2, right: 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  child: e.status == true
                                                      ? const Icon(
                                                          Icons.done_all,
                                                          color: Colors.green,
                                                          size: 14)
                                                      : Icon(
                                                          Icons
                                                              .fiber_manual_record,
                                                          color: AppColor
                                                              .errorColor,
                                                          size: 14),
                                                ),
                                                e.status == true
                                                    ? Text('Sold',
                                                        style: AppTextStyles
                                                            .simpleText
                                                            .copyWith(
                                                                fontSize: 12))
                                                    : Text('Unsold',
                                                        style: AppTextStyles
                                                            .simpleText
                                                            .copyWith(
                                                                fontSize: 12)),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Text(e.price,
                                                    style: AppTextStyles
                                                        .simpleText
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                Text('(NGN)',
                                                    style: AppTextStyles
                                                        .simpleText
                                                        .copyWith(fontSize: 12))
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1,
                                            endIndent: 10,
                                            indent: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 2, right: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    DateFormat('yMMMd').format(
                                                        e.createdAt.toDate()),
                                                    style: AppTextStyles
                                                        .simpleText
                                                        .copyWith(
                                                            fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()),
            );
          }),
    );
  }
}
