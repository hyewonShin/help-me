import 'package:flutter/material.dart';
import 'package:help_me/screens/mypage/dataReader.dart';

class MypageGiveList extends StatelessWidget {
  const MypageGiveList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '내가 담은 재능',
            style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 0.06),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 650,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView.builder(
                itemCount: 20, //data 길이만큼으로 수정할 것
                itemBuilder: (BuildContext context, int index) {
                  return buildContainerList(index);
                }),
          ),
        ));
  }

  Container buildContainerList(int index) {
    return Container(
      height: 153,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          // 밑변에 선 추가
          color: Colors.grey[300]!,
          width: 1, // 선의 두께
        ),
      )),
      child: Row(
        children: [
          Container(
            width: 111,
            height: 113,
            decoration: BoxDecoration(color: Colors.amber),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: SizedBox(
              width: 251,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '수영가르쳐드립니다.',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.close),
                      ],
                    ),
                    Text(
                      '김대성',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1회 20,000원',
                      style: TextStyle(
                        color: Color(0xFF17B36F),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 79,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.indeterminate_check_box,
                                color: Color(0xFFD9D9D9),
                              ),
                              Text('2',
                                  style: TextStyle(
                                      color: Color(0xFF44D596),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)), //수량넣기
                              Icon(
                                Icons.add_box,
                                color: Color(0xFFD9D9D9),
                              ),
                            ],
                          ),
                        ),
                        Text('40,000원',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
