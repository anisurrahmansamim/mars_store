import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        pages: [
          PageViewModel(
            title: "BUY",
            body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
            image: Image.asset("images/onbording1.jpg",fit: BoxFit.cover,)
          ),
          PageViewModel(
              title: "Check Out",
              body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
              image: Image.asset("images/onbording2.jpg",fit: BoxFit.cover,)
          ),
          PageViewModel(
              title: "Fast Delivery",
              body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
              image: Image.asset("images/onbording3.jpg",fit: BoxFit.cover,)
          ),
        ],
        onDone: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => AuthenticScreen()));
        },
        showNextButton: true,
        next:  Icon(Icons.arrow_forward),
        done: Text('Done'),
        skip: Text('Skip'),
    );
  }
}
