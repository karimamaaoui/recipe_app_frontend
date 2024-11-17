import 'package:flutter/material.dart';

class ScaffoldCustom extends StatelessWidget {
  const ScaffoldCustom({super.key,  this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset('assets/images/bg_green.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,

          ),
          SafeArea(child: child!)
        ],
      ),
    );
  }
}
