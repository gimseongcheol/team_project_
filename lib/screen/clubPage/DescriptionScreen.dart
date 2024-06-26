import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class DescriptionScreen extends StatefulWidget {
  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class Comment {
  final String text;
  final String author;
  final DateTime date;

  Comment({required this.text, required this.author, required this.date});
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  bool _isLiked = false; //나중에 initState로 빼내서 눌렀었는지 확인해야함.
  int _likeCount = 0; //firebase에서 들고와야함
  bool _isReported = false;
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  final List<String> imagePaths = [
    'assets/club_image2.jpeg',
    'assets/club_image3.jpg',
    'assets/club_image.jpeg',
  ];

  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 250.0,
            child: PageView.builder(
              controller: controller,
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                    image: DecorationImage(
                      image: AssetImage(imagePaths[index]),
                      fit: BoxFit.cover, // 이미지가 컨테이너에 꽉 차도록 설정
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16), // 간격 조절
          SmoothPageIndicator(
            // 페이지 인디케이터 추가
            controller: controller,
            count: imagePaths.length,
            effect: const WormEffect(
              dotHeight: 16,
              dotWidth: 16,
              type: WormType.thinUnderground,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 -
                      20, // 화면의 절반 크기로 설정
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isLiked = !_isLiked;
                        if (_isLiked) {
                          _likeCount++;
                        } else {
                          _likeCount--;
                        }
                      });
                    },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: _isLiked
                              ? Colors.pinkAccent
                              : Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '$_likeCount',
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ],
                    ),
                    tooltip: '좋아요',
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 -
                      20, // 화면의 절반 크기로 설정
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isReported = !_isReported;
                      });
                    },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report,
                          color: _isReported
                              ? Colors.red
                              : Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '동아리 신고',
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ],
                    ),
                    tooltip: '동아리 신고',
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 3.0),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '동아리 분류',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('과 동아리',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color)),
          ),
          Divider(),
          SizedBox(height: 3.0),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '회장',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('홍길동',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color)),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '회장 전화번호',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '010-1234-5678',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '담당 교수',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '김철수',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '한줄 소개',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '게임을 즐기는 동아리입니다.',
            ),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '동아리 소개',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '이 동아리는 게임에 관심 있는 학생들이 모여 활동하고 있습니다. '
              '게임 분야에 대한 교육 및 연구를 통해 회원들 간의 교류를 증진시키고, '
              '사회에 기여할 수 있는 능력을 함양하는 것을 목표로 하고 있습니다.',
            ),
          ),
        ],
      ),
    );
  }
}
