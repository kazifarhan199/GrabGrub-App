import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'post.dart';

//List items = [Customer('Jack', 23),Customer('Adam', 27),Customer('Katherin', 25)];
//print(customers.length);
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Customer> items = [
      Customer(
          "Chicken Pot Pie – Roast chicken, baby carrots, spring peas topped with grandma’s flakey pie crust.",
          'assets/logo.png',
          2,
          23,
          'Jack'),
      Customer(
          "Strawberry Sorbet – Hidden Valley Fruit Farm strawberries, shortbread crumb, and cream.",
          'assets/logo.png',
          2,
          23,
          'Adam'),
      Customer('post text', 'assets/logo.png', 2, 23, 'Katherin')
    ];

    return Container(
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(
              items: items,
              index: index,
            );
          }),
      // FloatingActionButton(
      //   onPressed: () => setState(() => 1),
      //   tooltip: 'Create Post',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
