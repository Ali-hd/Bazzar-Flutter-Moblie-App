import 'package:bazzar/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeFilter extends StatefulWidget {
  @override
  _TimeFilterState createState() => _TimeFilterState();
}

class _TimeFilterState extends State<TimeFilter> {
  final List<String> textList = [
    'All Time',
    'Past 3 months',
    'Past month',
    'Past week',
    'Past 24 hours'
  ];
  String _currentItemSelected;

  @override
  void initState() {
    super.initState();
    _currentItemSelected = textList[0];
  }

  @override
  Widget build(BuildContext context) {
    final providerPost = Provider.of<PostProvider>(context, listen: false);
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return textList.map((str) {
                return PopupMenuItem(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  value: str,
                  child: Text(str),
                );
              }).toList();
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentItemSelected,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.filter_list,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            onSelected: (v) {
              setState(() {
                providerPost.setTime(v);
                _currentItemSelected = v;
              });
            },
          )
        ],
      ),
    );
  }
}
