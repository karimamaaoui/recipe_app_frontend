import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            "What are you\ncooking today?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () {
          },
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            fixedSize: const Size(55, 55),
          ),
          icon: const Icon(BoxIcons.bxs_bell_ring),
        ),
      ],
    );
  }
}
