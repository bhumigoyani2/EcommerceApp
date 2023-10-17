import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool get = false;
  Map itemList = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Shopping Mall"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: get == true
          ? const Center(child: CircularProgressIndicator())
          : OrientationBuilder(
        builder: (context, orientation) {
          if(orientation == Orientation.portrait){
            return modeContainer(2);
          }else{
            return  modeContainer(4);
          }
        },

          ),
    );
  }

  Container modeContainer(int crossAxisCount) {
    return Container(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: itemList['data'].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,mainAxisExtent: 180),
              itemBuilder: (context, index) {
                return buildContainer(index);
              },
            ),
          );
  }

  Container buildContainer(int index) {
    return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Image.network(
                        "${itemList['data'][index]['featured_image']}",height: 100,
                      ),
                      buildSizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(child: Text("${itemList['data'][index]['title']}",overflow: TextOverflow.visible)),
                          IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart))
                        ],
                      )
                    ],
                  ),
                );
  }

  void getApi() async {
    get = true;
    setState((){});
    try {
      http.Response response = await http.get(Uri.parse(
          "http://209.182.213.242/~mobile/MtProject/public/api/product_list.php"));
      if (response.statusCode == 200) {
        itemList = jsonDecode(response.body);
        print(itemList['data']);
        Fluttertoast.showToast(
            msg: "${itemList['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (s, e) {
      debugPrint("$s");
      debugPrint("$e");
    }
    get = false;
    setState(() {});
  }

  SizedBox buildSizedBox({double? height,double? width}) => SizedBox(height: height ?? 0.0,width: width ?? 0.0,);
}
