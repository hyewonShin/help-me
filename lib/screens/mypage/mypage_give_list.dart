import 'package:flutter/material.dart';

class MypageGiveList extends StatelessWidget {
  const MypageGiveList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 담은 재능'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 29,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 550,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                  itemCount: 20, //data 길이만큼으로 수정할 것
                  itemBuilder: (BuildContext context, int index) {
                    return buildContainerList(index);
                  }),
            ),
          )
        ],
      ),
    );
  }

  Container buildContainerList(int index) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          // 밑변에 선 추가
          color: Colors.grey[300]!,
          width: 1, // 선의 두께
        ),
      )),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                width: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$index수영가르쳐드립니다.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.remove),
                        Text('2',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)), //수량넣기
                        Icon(Icons.add),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Icon(Icons.close), Text('40,000원')],
              ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
