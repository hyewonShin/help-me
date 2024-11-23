import 'package:flutter/material.dart';

class GiveDetail extends StatelessWidget {
  final String? image;
  final int? sellerId;
  final int? sellerGive;
  final int? sellerAsk;
  final String? title;
  final String? desc;
  final int? price;

  const GiveDetail(
      {super.key,
      this.image,
      this.title,
      this.desc,
      this.price,
      this.sellerId,
      this.sellerGive,
      this.sellerAsk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.network(image!, width: 111, height: 113, fit: BoxFit.cover),
          Text('${sellerId.toString()}'),
          Text('판매자의 재능기부 담기 횟수(user.json파일의 give의 횟수 ) > $sellerGive)'),
          Text('판매자의 재능 요청 횟수(user.json파일의 ask의 횟수 ) > $sellerAsk'),
          Text('$title'),
          Text('$desc'),
          Text('이용권 갯수'),
          Text('${price.toString()}'),
        ],
      ),
    );
  }
}
