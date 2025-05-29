import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final IconData icon;

  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 20,
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}