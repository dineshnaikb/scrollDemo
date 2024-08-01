import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TableScreen(),
    );
  }
}

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late ScrollController _horizontalScrollControllerHeader;
  late ScrollController _horizontalScrollControllerBody;
  late ScrollController _leftHorizontalScrollControllerHeader;
  late ScrollController _leftHorizontalScrollControllerBody;
  late ScrollController _verticalScrollController;
  late ScrollController _leftVerticalScrollController;
  late ScrollController _middelVerticalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollControllerHeader = ScrollController();
    _horizontalScrollControllerBody = ScrollController();
    _leftHorizontalScrollControllerHeader = ScrollController();
    _leftHorizontalScrollControllerBody = ScrollController();
    _leftHorizontalScrollControllerHeader.addListener(_syncHorizontalScroll);
    _leftHorizontalScrollControllerBody.addListener(_syncHorizontalScroll);
    _horizontalScrollControllerHeader.addListener(_syncHorizontalScroll);
    _horizontalScrollControllerBody.addListener(_syncHorizontalScroll);
    _verticalScrollController = ScrollController();
    _leftVerticalScrollController = ScrollController();
    _middelVerticalScrollController = ScrollController();
    _verticalScrollController.addListener(_syncVerticalScroll);
    _leftVerticalScrollController.addListener(_syncVerticalScroll);
    _middelVerticalScrollController.addListener(_syncVerticalScroll);
  }

  @override
  void dispose() {
    _leftHorizontalScrollControllerHeader.removeListener(_syncHorizontalScroll);
    _leftHorizontalScrollControllerBody.removeListener(_syncHorizontalScroll);
    _horizontalScrollControllerHeader.removeListener(_syncHorizontalScroll);
    _horizontalScrollControllerBody.removeListener(_syncHorizontalScroll);
    _verticalScrollController.removeListener(_syncHorizontalScroll);
    _leftVerticalScrollController.removeListener(_syncHorizontalScroll);
    _middelVerticalScrollController.removeListener(_syncHorizontalScroll);
    _horizontalScrollControllerBody.dispose();
    _horizontalScrollControllerHeader.dispose();
    _verticalScrollController.dispose();
    _leftVerticalScrollController.dispose();
    _middelVerticalScrollController.dispose();
    super.dispose();
  }

  void _syncHorizontalScroll() {
    var controllers = [
      _horizontalScrollControllerHeader,
      _horizontalScrollControllerBody,
      _leftHorizontalScrollControllerHeader,
      _leftHorizontalScrollControllerBody
    ];

    if (controllers.every((c) => c.hasClients)) {
      double offset = controllers.firstWhere((c) => c.position.isScrollingNotifier.value, orElse: () => controllers.first).offset;
      for (var c in controllers) {
        c.jumpTo(offset);
      }
    }
  }

  void _syncVerticalScroll() {
    var controllers = [
      _verticalScrollController,
      _leftVerticalScrollController,
      _middelVerticalScrollController,
    ];

    if (controllers.every((c) => c.hasClients)) {
      double offset = controllers.firstWhere((c) => c.position.isScrollingNotifier.value, orElse: () => controllers.first).offset;
      for (var c in controllers) {
        c.jumpTo(offset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableScreen'),
      ),
      body: Column(
        children: [
          Row(
            children: List.generate(
              2,
              (index) {
                return Expanded(
                  child: Container(
                    width: 100,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.red,
                    ),
                    child: Text(
                      'T $index',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Fixed header row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalScrollControllerHeader,
                        child: Row(
                          children: List.generate(10, (index) {
                            return Container(
                              width: 100,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.blue,
                              ),
                              child: Text(
                                'Header $index',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        ),
                      ),
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _horizontalScrollControllerBody,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            child: Column(
                              children: List.generate(20, (rowIndex) {
                                return Row(
                                  children: List.generate(10, (colIndex) {
                                    return Container(
                                      width: 100,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text('Row $rowIndex, Col $colIndex'),
                                    );
                                  }),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: List.generate(
                        2,
                        (index) {
                          return Container(
                            width: 100,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.red,
                            ),
                            child: Text(
                              'M $index',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _middelVerticalScrollController,
                        child: Column(
                          children: List.generate(
                            20,
                            (rowIndex) {
                              return Row(
                                children: List.generate(
                                  2,
                                  (colIndex) {
                                    return Container(
                                      width: 100,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text('MR $rowIndex, MC $colIndex'),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      // Fixed header row
                      SingleChildScrollView(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        controller: _leftHorizontalScrollControllerHeader,
                        child: Row(
                          children: List.generate(
                            10,
                            (index) {
                              return Container(
                                width: 100,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.blue,
                                ),
                                child: Text(
                                  'Header $index',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ).reversed.toList(),
                        ),
                      ),
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          controller: _leftHorizontalScrollControllerBody,
                          child: SingleChildScrollView(
                            controller: _leftVerticalScrollController,
                            child: Column(
                              children: List.generate(
                                20,
                                (rowIndex) {
                                  return Row(
                                    children: List.generate(
                                      10,
                                      (colIndex) {
                                        return Container(
                                          width: 100,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Text('Row $rowIndex, Col $colIndex'),
                                        );
                                      },
                                    ).reversed.toList(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
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
}
