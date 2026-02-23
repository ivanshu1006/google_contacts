import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.isMultiline = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value, maxLines: isMultiline ? null : 1),
        trailing: trailing,
      ),
    );
  }
}
