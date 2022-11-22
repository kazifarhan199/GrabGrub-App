import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Customer {
  String text;
  String pic;
  int likes;
  int comments;
  String name;

  Customer(this.text, this.pic, this.likes, this.comments, this.name);

  @override
  String toString() {
    return '{ ${this.name}, ${this.likes} ${this.comments}}';
  }
}
//List items = [Customer('Jack', 23),Customer('Adam', 27),Customer('Katherin', 25)];
//print(customers.length);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Customer> items = [
    Customer('post text', 'assets/logo.png', 2, 23, 'Jack'),
    Customer('post text', 'assets/logo.png', 2, 23, 'Adam'),
    Customer('post text', 'assets/logo.png', 2, 23, 'Katherin')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GrabGrub"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Row(
                  children: [
                    Icon(IconData(0xe043, fontFamily: 'MaterialIcons')),
                    Text(items[index].name),
                  ],
                ),
                Image.asset(items[index].pic),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 24.0,
                    ),
                    Text(items[index].likes.toString()),
                    ElevatedButton(
                      //style: raisedButtonStyle,
                      onPressed: () {},
                      child: Text('Claim'),
                    ),
                    Icon(
                      IconData(0xee41, fontFamily: 'MaterialIcons'),
                      color: Colors.pink,
                      size: 24.0,
                    ),
                    Text(items[index].comments.toString()),
                  ],
                ),
                Row(
                  children: [
                    Text('Description'),
                    Text(items[index].text),
                  ],
                ),
              ],
            );
            /*ListTile(
                leading: const Icon(Icons.list),
                trailing: const Text(
                  "GFG",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("List item $index"));*/
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => 1),
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
