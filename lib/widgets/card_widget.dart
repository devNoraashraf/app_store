import 'package:app_store/consts/colors_manger.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: ColorsManager.lightBlue,
          gradient: LinearGradient(
            colors: [ColorsManager.lightGrey, ColorsManager.grey],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Flexible(
                child: Row(
                  children: [
                    Text(
                      "155 \$",
                      style: TextStyle(
                        fontSize: 24,
                        color: const Color.fromARGB(255, 17, 16, 16),
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.favorite, color: Colors.red),
                  ],
                ),
              ),
              SizedBox(height: 1),
              Image.asset(
                "assets/images/p1.png",
                height: 110,
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 1),
              Flexible(
                child: Row(
                  children: [
                    Text(
                      "Smart Watch",
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 10, 9, 9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
