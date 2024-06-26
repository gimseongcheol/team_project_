import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:team_project/firebase_options.dart';
import 'package:team_project/providers/auth/auth_provider.dart'
as myAuthProvider;
import 'package:team_project/providers/auth/auth_state.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/providers/profile/profile_provider.dart';
import 'package:team_project/providers/profile/profile_state.dart';
import 'package:team_project/repositories/auth_repository.dart';
import 'package:team_project/repositories/feed_repository.dart';
import 'package:team_project/repositories/profile_repository.dart';
import 'package:team_project/screens/splash_screen.dart';
import 'package:team_project/screen/mainPage/editProfile.dart';
import 'package:team_project/screen/mainPage/editClub.dart';
import 'package:team_project/screen/mainPage/eidtSubscribeClub.dart';
import 'package:team_project/screen/mainPage/editComment.dart';
import 'package:team_project/screen/mainPage/mainScreen.dart';
import 'package:team_project/screen/mainPage/clubSearch.dart';
import 'package:team_project/screen/mainPage/aboutExplain.dart';
import 'package:team_project/theme/theme_constants.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting().then(
        (_) => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<FeedRepository>(
          create: (context) => FeedRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        StateNotifierProvider<myAuthProvider.AuthProvider, AuthState>(
          create: (context) => myAuthProvider.AuthProvider(),
        ),
        StateNotifierProvider<FeedProvider, FeedState>(
          create: (context) => FeedProvider(),
        ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(),
        ),
      ], child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Convex Bottom Bar Example',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      home: MainForm(),
    );
  }
}

class MainForm extends StatefulWidget {
  @override
  _MainFormState createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {
  int _selectedPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _pageOptions = [
    MainScreen(),
    EditProfile(),
    SubClub(),
    EditClub(),
    EditComment(),
  ];
  final List<String> _appbarNameList = [
    '메인 화면',
    '개인정보 수정',
    '관심 동아리',
    '만든 동아리 수정',
    '댓글 수정',
  ];

  List<Map<String, dynamic>> _bottomItems1 = [
    {"icon": Icons.home, "text": "메인"},
    {"icon": Icons.person, "text": "프로필"},
    {"icon": Icons.class_outlined, "text": "구독"},
    {"icon": Icons.edit, "text": "동아리"},
    {"icon": Icons.comment, "text": "댓글"},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 25,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          _appbarNameList[_selectedPage],
          style: const TextStyle(
            fontFamily: 'Dongle',
            fontSize: 35,
            fontWeight: FontWeight.w200,
          ),
        ),
        actions: [
          Icon(
            _themeManager.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
          Switch(
            value: _themeManager.themeMode == ThemeMode.dark,
            onChanged: (newValue) {
              setState(() {
                _themeManager.toggleTheme(newValue);
              });
            },
            activeColor: Colors.grey[600],
            inactiveTrackColor: Colors.white,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: _themeManager.themeMode == ThemeMode.dark
            ? Color(0xff454545)
            : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                //나중에 backgroundImage이용해서 사진 지정.
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  //나중에 backgroundImage이용해서 사진 지정.
                ),
              ],
              accountName: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  '베타 테스트',
                  style: TextStyle(
                      fontFamily: 'YeongdeokSea',
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              accountEmail: Text(
                '이메일을 인증하세요.',
                style: TextStyle(
                    fontFamily: 'YeongdeokSea',fontSize: 18, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Color(0xFF1E1E1E)
                    : Color(0xff1e2b67),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
            _buildDrawerCard(Icons.login, '회원가입하기', Colors.black12, () {}),
            _buildDrawerCard(
                Icons.question_mark_outlined, 'About', Colors.black12, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutExplain()));
            }),
            _buildDrawerCard(Icons.output, '로그아웃', Colors.black12, () {}),
          ],
        ),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          height: 66,
          padding: EdgeInsets.symmetric(horizontal: 1),
          margin: EdgeInsets.fromLTRB(24, 0, 24, 10),
          decoration: BoxDecoration(
            //네비게이션 바의 박스 색
            color: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF303030)
                : Color(0xFF004285),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 1), // 첫 번째 아이콘 왼쪽 여백
              ..._bottomItems1.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item["icon"],
                        color: _selectedPage == index
                            ? _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black
                            : Colors.white,
                      ),
                      SizedBox(height: 2), // 아이콘과 텍스트 사이의 간격 조정
                      Text(
                        item["text"],
                        style: TextStyle(
                          color: _selectedPage ==
                              index //여기서 라이트모드일때 선택안한 아이콘이 하얀색이었으면 하는데...
                              ? _themeManager.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(width: 1), // 마지막 아이콘 오른쪽 여백
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ClubSearch()));
        },
        child: Icon(Icons.search, color: Colors.black),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.navigate_next),
    );
  }

  Widget _buildDrawerCard(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
          ? color
          : Colors.white,
      leading: Icon(
        icon,
        color: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.black,
      ),
      title: Text(title,
          style: TextStyle(
              color:
              Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black)),
      onTap: onTap,
      trailing: Icon(Icons.navigate_next,
          color: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
              ? Colors.white
              : Colors.black),
    );
  }
}
