import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/screens/home/home_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String id = 'OnBoarding_screen';
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    initPrefs();
    controller = PageController();
    super.initState();
  }

  PageController controller;
  int currentPageValue;
  List<Widget> introWidgetsList;
  SharedPreferences prefs;
  bool showOnBoarding = false;
  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    showOnBoarding = prefs.getBool('first') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    introWidgetsList = <Widget>[
      ImageCard(
        image: 'assets/images/logo.png',
        title: 'Savior',
        caption: 'Welcome to Savior',
      ),
      ImageCard(
        image: 'assets/images/emergency-call.png',
        title: 'Savior',
        caption: 'Save your Lover Life',
      ),
      ImageCard(
        image: 'assets/images/map.png',
        title: 'Savior',
        caption: 'Recognise the Location',
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: introWidgetsList.length,
            onPageChanged: (int page) {
              getChangedPageAndMoveBar(page);
            },
            controller: controller,
            itemBuilder: (context, index) {
              return introWidgetsList[index];
            },
          ),
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 35),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                    for (int i = 0; i < introWidgetsList.length; i++)
//                      if (i == currentPageValue) ...[circleBar(true)] else
//                        circleBar(false),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible:
                currentPageValue == introWidgetsList.length - 1 ? true : false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: RaisedButton(
                  color: Colors.green,
                  elevation: 3,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  onPressed: () async {
                    await prefs.setBool('first', false);
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(26))),
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () async {
                  await prefs.setBool('first', false);
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                },
                child: Text('Skip'),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 15 : 8,
      width: isActive ? 15 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }
}

class ImageCard extends StatelessWidget {
  final image, title, caption;
  const ImageCard({
    Key key,
    this.image,
    this.title,
    this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(image),
            )),
            height: MediaQuery.of(context).size.height / 1.6,
            width: MediaQuery.of(context).size.width / 1.2,
            child: SizedBox(),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              caption,
              style: TextStyle(fontSize: 19),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
