import 'package:bazzar/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CitiesFilter extends StatelessWidget {
  static const List<String> cities = [
    'All',
    'Riyadh',
    'Jeddah',
    'Makkah',
    'Qatif',
    'Yanbu',
    'Hafr Al-Batin',
    'Taif',
    'Tabuk',
    'Buraydah',
    'Unaizah',
    'Jubail',
    'Jizan',
    'Al Jawf',
    'Hofuf',
    'Gurayat',
    'Dhahran',
    'Bisha',
    'Arar',
    'Abha'
  ];

  @override
  Widget build(BuildContext context) {
    final providerPost = Provider.of<PostProvider>(context, listen: true);
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          itemCount: cities.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  providerPost.setCurrentCity(cities[index]);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: cities[index] == providerPost.getCurrentCity
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2,
                                color: Colors.brown[400],
                              ),
                            ),
                          )
                        : null,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      cities[index],
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: 7,
          ),
        ),
      ),
    );
  }
}
