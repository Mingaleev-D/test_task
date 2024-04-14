import 'package:flutter/material.dart';
import 'package:test_task/core/app_constants.dart';
import 'package:test_task/ui/pages/main_page/search_page.dart';

import '../../../data/model/items_model.dart';
import '../../../data/service/api_service.dart';
import '../../widgets/pagination_bar.dart';
import '../../widgets/title_header_table.dart';

class TaskMainPage extends StatefulWidget {
  static const routeName = '/task_main_page';

  const TaskMainPage({super.key});

  @override
  State<TaskMainPage> createState() => _TaskMainPageState();
}

class _TaskMainPageState extends State<TaskMainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _editPositionFormKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _unitofmeasurementController =
      TextEditingController();
  final TextEditingController _descController = TextEditingController();

  int _currentPage = 1;

  void _updatePage(int newPage) {
    setState(() {
      _currentPage = newPage;
      _apiService.getItems(page: newPage);
    });
  }

  int _pageSize = 10;

  void _updatePageSize(int newSize) {
    setState(() {
      _pageSize = newSize;
      _apiService.getItems(pageSize: newSize);
    });
  }

  bool _isAscending = true;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _unitofmeasurementController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      endDrawer: _buildEndDrawer(context),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _apiService.getItems(
                  page: _currentPage,
                  pageSize: _pageSize,
                  sortOrder: _isAscending ? 'ASC' : 'DESC'),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Result>> snapshot) {
                final List<Result>? dataResult = snapshot.data;
                if (snapshot.hasData) {
                  if (dataResult != null && dataResult.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const TitleHeaderTable(
                                      titleHeader: AppConstants.titleName,
                                    ),
                                    IconButton(
                                      icon: Icon(_isAscending
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down),
                                      onPressed: () {
                                        setState(() {
                                          _isAscending = !_isAscending;
                                          _apiService.getItems(
                                              sortOrder: _isAscending
                                                  ? 'ASC'
                                                  : 'DESC');
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const TitleHeaderTable(
                                titleHeader: AppConstants.unitofmeasurementName,
                              ),
                              const TitleHeaderTable(
                                titleHeader: AppConstants.codeName,
                              ),
                              TitleHeaderTable(
                                titleHeader: ('') * 10,
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dataResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      dataResult[index].name.toString(),
                                      textAlign: TextAlign.center,
                                    )),
                                    Expanded(
                                        child: Text(
                                      dataResult[index]
                                          .measurementUnits
                                          .toString(),
                                      textAlign: TextAlign.center,
                                    )),
                                    Expanded(
                                        child: Text(
                                      dataResult[index].code.toString(),
                                      textAlign: TextAlign.center,
                                    )),
                                    const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(Icons.edit)))
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('Нет данных'));
                  }
                } else if (snapshot.hasError) {
                  return const Center(child: Icon(Icons.error_outline));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                PaginationBar(
                  currentPage: _currentPage,
                  totalPages: 6,
                  onPageChange: _updatePage,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Показать по: '),
                      Container(
                        width: 60,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: DropdownButton<int>(
                          value: _pageSize,
                          padding: EdgeInsets.only(left: 10),
                          underline:
                              Container(height: 0, color: Colors.transparent),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white70,
                          ),
                          //style: const TextStyle(fontSize: 14, color: Colors.white70),
                          selectedItemBuilder: (context) {
                            return <int>[5, 10, 20].map((value) {
                              return Center(
                                child: Text(
                                  _pageSize.toString(),
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                              );
                            }).toList();
                          },
                          items: [5, 10, 20].map((pageSize) {
                            return DropdownMenuItem<int>(
                              value: pageSize,
                              child: Text(
                                pageSize.toString(),
                              ),
                            );
                          }).toList(),
                          onChanged: (newSize) {
                            _updatePageSize(newSize!);
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildEndDrawer(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _editPositionFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.home),
                  const SizedBox(width: 8),
                  const Text('Новая позиция',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  //const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Новая позиция',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Заполните все поля для создания новой номенклатуры',
                  style: TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              const Text(AppConstants.titleName),
              const SizedBox(height: 5),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Заполните поле';
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(AppConstants.unitofmeasurementName),
              const SizedBox(height: 5),
              TextFormField(
                controller: _unitofmeasurementController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Заполните поле';
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(AppConstants.codeName),
              const SizedBox(height: 5),
              TextFormField(
                controller: _codeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Заполните поле';
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(AppConstants.descriptionName),
              const SizedBox(height: 5),
              TextFormField(
                controller: _descController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Заполните поле';
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          )),
                      onPressed: () {
                        // Действие при нажатии на кнопку "Отмена"
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Отмена',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppConstants.backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                    onPressed: () async {
                      // Действие при нажатии на кнопку "Подтвердить"
                      if (_editPositionFormKey.currentState!.validate()) {
                        await _apiService.postCreateNewItem(
                            name: _nameController.text,
                            measurementUnits:
                                _unitofmeasurementController.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Подтвердить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Text(
            'Номенклатура',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 3),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppConstants.backgroundColor,
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text(
              '54 единиц',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          )
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(SearchPage.routeName);
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Цвет серого бордера
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2), bottomLeft: Radius.circular(2)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                Text(
                  'Поиск по названию',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(2), bottomRight: Radius.circular(2)),
          ),
          child: const Text('Поиск', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 10),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: AppConstants.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              )),
          onPressed: () {
            _scaffoldKey.currentState?.openEndDrawer();
          },
          child: const Row(
            children: [
              Icon(Icons.add, color: Colors.white),
              Text('Новая позиция', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
