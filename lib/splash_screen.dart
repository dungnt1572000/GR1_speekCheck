import 'package:doan1/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    super.initState();
    Future.delayed(const Duration(milliseconds: 1500),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const MyHomePage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepPurple,
                    Colors.pink
                  ]
                )
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Safe Driver',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                  SizedBox(height: 30,),
                  CircularProgressIndicator(strokeWidth: 12,backgroundColor: Colors.white),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
