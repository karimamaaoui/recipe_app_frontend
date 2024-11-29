import 'package:flutter/material.dart';
import 'package:receipe_project/constants.dart';
import 'package:receipe_project/screens/AddRecipePage.dart';
import 'package:receipe_project/screens/auth/login_screen.dart';
import 'package:receipe_project/screens/auth/service/UserService.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Profile Image
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('assets/images/user-06.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // Menu
                MenuWidget(
                  title: 'Account Settings',
                  iconitem: Icons.account_circle,
                  onPress: () {
                  },
                  textColor: Colors.black,
                  endIcon: true,
                ),
                MenuWidget(
                  title: 'Add Recipe ',
                  iconitem: Icons.lock,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddRecipePage(),
                      ),
                    );
                  },
                  textColor: Colors.black,
                  endIcon: true,
                ),

                MenuWidget(
                  title: 'Logout',
                  iconitem: Icons.logout,
                  onPress: () {
                    UserService.logout(context);
                  },
                  textColor: Colors.black,
                  endIcon: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.title,
    required this.iconitem,
    required this.onPress,
    this.endIcon = true,
    this.textColor = Colors.black,
  });

  final String title;
  final IconData iconitem;
  final VoidCallback onPress;
  final bool endIcon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.teal.withOpacity(0.1),
        ),
        child: Icon(iconitem, color:primaryColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
      ),
      trailing: endIcon
          ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(
          Icons.arrow_forward,
          size: 18.0,
          color: Colors.grey,
        ),
      )
          : null,
    );
  }
}
