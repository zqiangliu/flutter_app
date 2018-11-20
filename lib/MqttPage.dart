import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:utf/utf.dart';
import 'package:typed_data/typed_data.dart' as typed;

class MqttPage extends StatefulWidget{

  @override
  State createState() {
    return MqttPageState();
  }

}

class MqttPageState extends State<MqttPage>{

  var message = '';
  var statusMessage = '';
  var _topic = '/topic/sample';
  var _mqttUsername = 'qianguan';
  var _mqttPassword = 'qianguan@147258369';
  MqttClient client = MqttClient('120.79.158.115', 'app_client_1');
  TextEditingController _controller = TextEditingController();

  @override
  void didUpdateWidget(MqttPage oldWidget) {
    print('didUpdateWidget');
  }

  @override
  void initState() {
    print('init state.');
    print('--connecting to server.');
    statusMessage = '--connect to server...';
    _connect().then((_){
      print('--connected.');
      //订阅
      _subscribe(_topic);

      setState(() {
        statusMessage += '\n--connected.';
      });
    }).catchError((e){
      setState(() {
        statusMessage += '\n--connection failed.';
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    client.disconnect();
    super.dispose();
  }

  Future _connect() async{
    //client.setProtocolV31();
    client.port = 1883;
    client.logging(false);
    client.keepAlivePeriod=20;
    client.onDisconnected = _onDisconnect;
    client.onSubscribed = _onSubscribed;
    await client.connect(_mqttUsername, _mqttPassword);
  }

  _subscribe(String topic){
    var status = client.connectionState.toString();
    print('connectionState=$status');
    if(status != 'ConnectionState.connected'){
      _connect();
      return;
    }
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates.listen((List<MqttReceivedMessage> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
//      String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      String pt = decodeUtf8(recMess.payload.message);
      print("message received, topic:${c[0].topic}, payload:${pt}");
      setState(() {
        message += '\n$pt';
      });
    });
  }
//
//  Future<int> _connect() async{
//    print('connecting to server.');
//    statusMessage = '--connect to server...';
//    client.setProtocolV31();
//    client.port = 1883;
//    client.logging(false);
//    client.keepAlivePeriod = 20;
//    client.onDisconnected = _onDisconnect;
//    client.onSubscribed = _onSubscribed;
//
//    try {
//      await client.connect();
//      statusMessage += '\n--connected.';
//    } catch (e) {
//      print("EXAMPLE::client exception - $e");
//      statusMessage += '--connect failed.';
//      client.disconnect();
//    }
//
//    client.subscribe(_topic, MqttQos.atMostOnce);
//    client.updates.listen((List<MqttReceivedMessage> c) {
//      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
//      String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//
//      /// The above may seem a little convoluted for users only interested in the
//      /// payload, some users however may be interested in the received publish message,
//      /// lets not constrain ourselves yet until the package has been in the wild
//      /// for a while.
//      /// The payload is a byte buffer, this will be specific to the topic
//      ///
//      print("message received, topic:${c[0].topic}, payload:${pt}");
//      print("");
//      setState(() {
//        message = pt;
//      });
//    });
//  }

  _onDisconnect(){
    print('--disconnected');
    setState(() {
      statusMessage += '\ndisconnected.';
    });
  }

  _onSubscribed(topic){
    print('--subscribed, topic=$topic');
    setState(() {
      statusMessage += '\n--subscribed, topic=$topic';
    });
  }

  _onSendButtonPress(){
    var message = _controller.text;
    print('text=$message');
    MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    var _buf = typed.Uint8Buffer();
    _buf.addAll(encodeUtf8(message));
    builder.addBuffer(_buf);
    client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload);
    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('MQTT 示例'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('收到消息:$message'),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: '发送内容'
            ),
          ),
          Center(
            child: RaisedButton(
                child: Text('发送'),
                onPressed: _onSendButtonPress
            ),
          ),
          Text('$statusMessage')
        ],
      ),
    );
  }

}