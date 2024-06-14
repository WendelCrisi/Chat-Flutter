import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessge);
  final Function({String text, File imgFile}) sendMessge;
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isComposing = false;
  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffe9d7f7),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            onPressed: () {
              _showOptions(context);
            },
            icon: Icon(Icons.insert_link),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: "Enviar mensagem"),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessge(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
              onPressed: _isComposing
                  ? () {
                      widget.sendMessge(text: _controller.text);
                      _reset();
                    }
                  : null,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(5.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: IconButton(
                    onPressed: () async {
                      PickedFile img =
                          await _picker.getImage(source: ImageSource.camera);
                      final File imgFile = File(img.path);
                      if (imgFile == null) return;
                      widget.sendMessge(imgFile: imgFile);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.photo_camera),
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () async {
                    PickedFile img =
                        await _picker.getImage(source: ImageSource.gallery);
                    final File imgFile = File(img.path);
                    if (imgFile == null) return;
                    widget.sendMessge(imgFile: imgFile);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.insert_photo),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}
