import 'package:flutter/material.dart';
import 'package:test_task/data/model/items_model.dart';
import 'package:test_task/data/service/api_service.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search_page';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Поиск по названию',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                showSearch(context: context, delegate: NameSearchDelegate());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 70,
                  color: Colors.grey[300],
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 10, 20, 10),
                      child: Text(
                        'Поиск',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NameSearchDelegate extends SearchDelegate<List<Result>> {
  Iterable<Result> itemNameSearchResults = [];

  Future searchItemName(String query) async {
    final item = await ApiService().getItems(itemName: query);
    itemNameSearchResults = item.toList();
    // return itemNameSearchResults;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, []);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchItemName(query);
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Начните поиск'),
      );
    } else {
      return FutureBuilder<Iterable<Result>>(
        future: ApiService().getItems(itemName: query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            final results = snapshot.data ?? [];
            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                          child: Text(
                        results[index].name.toString(),
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                          child: Text(
                        results[index].measurementUnits.toString(),
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                          child: Text(
                        results[index].code.toString(),
                        textAlign: TextAlign.center,
                      )),
                      // const Expanded(
                      //     child: Align(
                      //         alignment: Alignment.center,
                      //         child: Icon(Icons.edit)))
                    ],
                  );
                },
              ),
            );
          }
        },
      );
    }
  }
}
