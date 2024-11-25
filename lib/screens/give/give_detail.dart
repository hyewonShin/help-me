import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_me/constant/colors.dart';

class GiveDetail extends StatelessWidget {
  final String? image;
  final int? sellerId;
  final int? sellerGive;
  final int? sellerAsk;
  final String? title;
  final String? desc;
  final int? price;
  final int? giveId;
  final Function cartGiveData;

  const GiveDetail(
      {super.key,
      this.image,
      this.title,
      this.desc,
      this.price,
      this.sellerId,
      this.sellerGive,
      this.sellerAsk,
      this.giveId,
      required this.cartGiveData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: Column(
        children: [
          Image.network(image!,
              width: double.infinity, height: 409, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerId.toString(),
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
                      '$sellerGive회',
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
                      '$sellerAsk회',
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
                  '$title',
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
                  child: Text(
                    '$desc',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                ),
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
          Row(children: [
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SvgPicture.asset(
                'assets/images/cart.svg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 1,
                height: 60,
                color: AppColors.lightGray,
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/minus_btn.svg',
                    ),
                    Text(' 수량 '),
                    SvgPicture.asset(
                      'assets/images/plus_btn.svg',
                    ),
                  ],
                ),
                Text('$price'),
              ],
            ),
            Text('구매하기 버튼')
          ]),
          //   ],
          // )
        ],
      ),
    );
  }
}

   // Image.network(image!, width: 111, height: 113, fit: BoxFit.cover),
          // Text('${sellerId.toString()}'),
          // Text('판매자의 재능기부 담기 횟수(user.json파일의 give의 횟수 ) > $sellerGive)'),
          // Text('판매자의 재능 요청 횟수(user.json파일의 ask의 횟수 ) > $sellerAsk'),
          // Text('$title'),
          // Text('$desc'),
          // Text('이용권 갯수'),
          // Text('${price.toString()}'),
          // GestureDetector(
          //     onTap: () {
          //       cartGiveData(giveId);
          //     },
          //     child: Icon(Icons.home)
