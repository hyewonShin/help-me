import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/util/save_json_to_file.dart';
import 'package:intl/intl.dart';

class GiveDetail extends StatefulWidget {
  final String? image;
  final String? sellerName;
  final int? sellerGive;
  final int? sellerAsk;
  final String? title;
  final String? desc;
  final int? price;
  final int? giveId;

  const GiveDetail({
    super.key,
    this.image,
    this.title,
    this.desc,
    this.price,
    this.sellerName,
    this.sellerGive,
    this.sellerAsk,
    this.giveId,
  });

  @override
  State<GiveDetail> createState() => _GiveDetailState();
}

class _GiveDetailState extends State<GiveDetail> {
  int quantity = 1;
  int totalPrice = 0;

  void updateQuantity(bool delta) {
    setState(() {
      delta ? quantity++ : quantity--;
      totalPrice = widget.price! * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final comma = NumberFormat("#,###,###원");

    String productName = widget.title!.split(' ')[0];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: Stack(children: [
        Column(
          children: [
            Image.network(widget.image!,
                width: double.infinity, height: 409, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sellerName ?? "unKnown",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Text('재능 담기  ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGray)),
                      Text(
                        '${widget.sellerGive}회',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightGreen),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 1,
                          height: 17,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text('재능 요청  ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGray)),
                      Text(
                        '${widget.sellerAsk}회',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightGreen),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 1,
                      color: AppColors.lightGray,
                    ),
                  ),
                  Text(
                    '${widget.title}',
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 110,
                    child: SingleChildScrollView(
                      child: Text(
                        '${widget.desc}',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                height: 1,
                color: AppColors.lightGray,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 30,
          child: Row(children: [
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/images/cart.svg',
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: AppColors.lightGray,
            ),
            SizedBox(
              width: 20,
            ),
            widget.price == 0
                ? Text(
                    "무료",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              quantity > 0 ? updateQuantity(false) : null;
                            },
                            child: SvgPicture.asset(
                              'assets/images/minus_btn.svg',
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17.0),
                            child: Text(
                              quantity.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightGreen),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              quantity < 100 ? updateQuantity(true) : null;
                            },
                            child: SvgPicture.asset(
                              'assets/images/plus_btn.svg',
                            ),
                          ),
                        ],
                      ),
                      Text(
                        comma.format(quantity == 1 ? widget.price : totalPrice),
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
          ]),
        ),
        Positioned(
          bottom: 35,
          left: 300,
          right: 20,
          child: ElevatedButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                            title:
                                Text('$productName 이용권 $quantity개를 구매하시겠습니까?'),
                            actions: [
                              CupertinoDialogAction(
                                child: Text('취소'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text('확인'),
                                onPressed: () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoAlertDialog(
                                            title: Text('구매 완료'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text('확인'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ));
                                },
                              ),
                            ]));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGreen,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: Size(82, 45)),
              child: Text(
                '구매하기',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              )),
        ),
      ]),
    );
  }
}
