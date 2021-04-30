import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context).settings.arguments;
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30.0),
              child: Hero(
                tag: 'image',
                child: CircleAvatar(
                  radius: 200,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  backgroundImage: image,
                  //backgroundImage: Image.file(file),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}