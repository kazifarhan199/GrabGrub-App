import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'home.dart';

class PostCard extends StatefulWidget {
  int index;
  List<Customer> items;
  PostCard({required this.items, required this.index, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

// mamathaputta
// sagarputtamp
class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      child: Column(
        children: [
          ListTile(
            title: Row(children: [
              CircleAvatar(
                radius: 25,
                child: Image.asset(widget.items[widget.index].pic),
              ),
              SizedBox(
                width: 10,
              ),
              Column(children: [
                SizedBox(
                  height: 5,
                ),
                Text(widget.items[widget.index].name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("date", style: TextStyle(fontStyle: FontStyle.italic)),
              ]),
            ]),
            trailing: Icon(Icons.keyboard_control),
          ),
          InkWell(
            onTap: () {},
            child: Image.asset(
              widget.items[widget.index].pic,
              height: 300,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 30.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(widget.items[widget.index].likes.toString()),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  //style: raisedButtonStyle,
                  onPressed: () {},
                  child: Text('Claim'),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                IconData(0xee41, fontFamily: 'MaterialIcons'),
                color: Colors.pink,
                size: 30.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(widget.items[widget.index].comments.toString()),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Description: ' + widget.items[widget.index].text,
                    //style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
