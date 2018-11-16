import 'package:flutter/material.dart';
class PicturePage extends StatefulWidget{

  @override
  State createState() {
    return PicturePageState();
  }
}

class PicturePageState extends State<PicturePage>{
  var fontStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold
  );
  var imgAsset = 'images/scene1.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图片切换'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Image.asset(
              imgAsset, width: 300, height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: <Widget>[
                RaisedButton(
                  child: Text(
                    '图片1',
                    style: fontStyle,
                  ),
                  color: Colors.blueGrey,
                  onPressed: (){
                    setState(() {
                      imgAsset = 'images/scene1.png';
                    });
                  },
                ),
                RaisedButton(
                  child: Text(
                    '图片2',
                    style: fontStyle,
                  ),
                  color: Colors.blueGrey,
                  onPressed: (){
                    setState(() {
                      imgAsset = 'images/scene2.png';
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}