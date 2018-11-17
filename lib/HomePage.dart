import 'package:flutter/material.dart';

class ListDemo extends StatelessWidget{
  var items = ['Layout示例', '图片切换', '登录表单', 'MQTT示例', '文件操作', 'Tab示例'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Demo')),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder:(context, index){
            return ListTile(
              title: Text(items[index]),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.blueGrey,
              ),
              onTap: (){_onListTap(context, index);},
            );
          }
      ),
    );
  }
  _onListTap(ctx, row){
    print('list tap, row=$row');
    switch(row){
      case 0:
        Navigator.pushNamed(ctx, '/layout');
        break;
      case 1:
        Navigator.pushNamed(ctx, '/picture');
        break;
      case 2:
        Navigator.pushNamed(ctx, '/login');
        break;
      case 3:
        Navigator.pushNamed(ctx, '/mqtt');
        break;
      case 4:
        Navigator.pushNamed(ctx, '/file');
        break;
      case 5:
        Navigator.pushNamed(ctx, '/tab');
        break;
      default:
        break;
    }
  }
}
