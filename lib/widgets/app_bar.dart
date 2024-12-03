import 'package:flutter/material.dart';

import '../constants/colors.dart';

AppBar buildAppBar(titleText, showMenu) {
  return AppBar(
    title: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showMenu) const Icon(Icons.menu),
            Text(
              titleText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/images/profile.png'),
                ))
          ],
        )
      ],
    ),
    backgroundColor: primaryColor,
  );
}
