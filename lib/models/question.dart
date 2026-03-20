class QuestionCategory {
  final String name;
  final String code;
  final List<QuestionType> types;

  const QuestionCategory({
    required this.name,
    required this.code,
    required this.types,
  });
}

class QuestionType {
  final String name;
  final String code;
  final String rule;

  const QuestionType({
    required this.name,
    required this.code,
    required this.rule,
  });
}

class Question {
  final String text;
  final int number;

  const Question({
    required this.text,
    required this.number,
  });
}

// 题型分类
const List<QuestionCategory> QUESTION_CATEGORIES = [
  QuestionCategory(
    name: '竖式计算',
    code: 'vert',
    types: [
      QuestionType(name: '竖式加减法', code: 'vert_addsub', rule: '竖式计算，最多五位数的加减法'),
      QuestionType(name: '竖式乘法', code: 'vert_mul', rule: '竖式计算，最多五位数乘一位数'),
      QuestionType(name: '竖式除法', code: 'vert_div', rule: '竖式计算，最多五位数除以一位数'),
    ],
  ),
  QuestionCategory(
    name: '混合运算',
    code: 'mixed',
    types: [
      QuestionType(name: '加减乘除混合', code: 'mixed_all', rule: '加减乘除混合运算'),
      QuestionType(name: '带括号混合运算', code: 'mixed_bracket', rule: '含括号优先级的四则混合运算'),
      QuestionType(name: '求未知数△', code: 'solve_tri', rule: '混合运算，求未知数△'),
    ],
  ),
  QuestionCategory(
    name: '单位换算',
    code: 'exchange',
    types: [
      QuestionType(name: '人民币换算', code: 'rmb_exchange', rule: '元、角、分的换算及加减计算'),
      QuestionType(name: '时间换算', code: 'time_exchange', rule: '小时、分钟、秒的换算及计算'),
      QuestionType(name: '长度换算', code: 'length_exchange', rule: '米、分米、厘米、毫米的换算及计算'),
      QuestionType(name: '质量换算', code: 'weight_exchange', rule: '千克、克的换算及计算'),
    ],
  ),
  QuestionCategory(
    name: '图形与测量',
    code: 'shape',
    types: [
      QuestionType(name: '周长和面积计算', code: 'perimeter_area', rule: '长方形周长和面积计算'),
      QuestionType(name: '面积单位换算', code: 'area_unit', rule: '平方米与平方分米的换算'),
    ],
  ),
  QuestionCategory(
    name: '概念题',
    code: 'concept',
    types: [
      QuestionType(name: '找规律填数', code: 'pattern', rule: '找规律填数'),
      QuestionType(name: '倍的认识', code: 'times', rule: '倍的认识'),
      QuestionType(name: '小数加减法', code: 'decimal', rule: '一位小数加减法'),
      QuestionType(name: '方向与位置', code: 'direction', rule: '东南西北方向的认知'),
    ],
  ),
];
