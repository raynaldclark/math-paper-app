import 'package:flutter/material.dart';
import '../models/question.dart';
import '../generators/question_generator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _selectedTypes = {};
  final Map<String, int> _typeCounts = {};
  List<Question> _previewQuestions = [];
  int _globalNumber = 0;

  @override
  void initState() {
    super.initState();
    for (var category in QUESTION_CATEGORIES) {
      for (var type in category.types) {
        _selectedTypes[type.code] = false;
        _typeCounts[type.code] = 5;
      }
    }
  }

  void _generatePreview() {
    _globalNumber = 0;
    _previewQuestions = [];
    
    for (var category in QUESTION_CATEGORIES) {
      for (var type in category.types) {
        if (_selectedTypes[type.code] == true) {
          int count = _typeCounts[type.code] ?? 5;
          var questions = QuestionGenerator.generate(type.code, count);
          for (var q in questions) {
            _globalNumber++;
            _previewQuestions.add(Question(
              text: q.text,
              number: _globalNumber,
            ));
          }
        }
      }
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('小学数学试卷生成器'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              for (var key in _selectedTypes.keys) {
                _selectedTypes[key] = false;
              }
              setState(() {});
            },
            tooltip: '清空',
          ),
        ],
      ),
      body: Column(
        children: [
          // 按钮栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      for (var key in _selectedTypes.keys) {
                        _selectedTypes[key] = true;
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.select_all, size: 18),
                    label: const Text('全选'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _previewQuestions.isEmpty ? null : () {
                      Navigator.pushNamed(context, '/preview', arguments: _previewQuestions);
                    },
                    icon: const Icon(Icons.preview, size: 18),
                    label: Text('预览(${_previewQuestions.length}题)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 题型列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: QUESTION_CATEGORIES.length,
              itemBuilder: (context, index) {
                var category = QUESTION_CATEGORIES[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 分类标题
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2196F3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // 题型项
                      ...category.types.map((type) {
                        return ListTile(
                          leading: Checkbox(
                            value: _selectedTypes[type.code],
                            onChanged: (value) {
                              setState(() {
                                _selectedTypes[type.code] = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF2196F3),
                          ),
                          title: Text(type.name),
                          subtitle: Text(
                            type.rule,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          trailing: SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('数量:'),
                                const SizedBox(width: 4),
                                SizedBox(
                                  width: 45,
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: _typeCounts[type.code].toString(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    onChanged: (value) {
                                      int? count = int.tryParse(value);
                                      _typeCounts[type.code] = count ?? 5;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedTypes[type.code] = !(_selectedTypes[type.code] ?? false);
                            });
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generatePreview,
        icon: const Icon(Icons.refresh),
        label: const Text('生成预览'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
    );
  }
}
