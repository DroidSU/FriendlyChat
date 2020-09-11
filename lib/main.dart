import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FriendlyChat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget{
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = true;

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _isComposing ? _handleSubmitted : null,
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              focusNode: _focusNode,
              onChanged: (String text) {            // NEW
                setState(() {                       // NEW
                  _isComposing = text.length > 0;   // NEW
                });                                 // NEW
              },
            ),
          ),
          IconTheme(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
            data: IconThemeData(color: Theme.of(context).accentColor), // NEW,
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(      // NEW
        duration: const Duration(milliseconds: 700), // NEW
        vsync: this,                                 // NEW
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('FriendlyChat'),
      ),
      body: Column(
        children: [
          Flexible(                                        // NEW
            child: ListView.builder(                       // NEW
              padding: EdgeInsets.all(8.0),                // NEW
              reverse: true,                               // NEW
              itemBuilder: (_, int index) => _messages[index], // NEW
              itemCount: _messages.length,                 // NEW
            ),                                             // NEW
          ),
          Divider(height: 1.0,),
          Container(                                       // NEW
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor),         // NEW
            child: _buildTextComposer(),                   //MODIFIED
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  String _name = 'Sujoy';
  final String text;
  final AnimationController animationController;

  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:                      // NEW
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),  // NEW
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Text(text),
            ),
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Text(_name, style: Theme.of(context).textTheme.headline4),
//              Container(
//                margin: EdgeInsets.only(top: 5.0),
//                child: Text(text),
//              ),
//            ],
//          ),
          ],
        ),
      ),
    );
  }
}
