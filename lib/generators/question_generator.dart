import 'dart:math';
import '../models/question.dart';

class QuestionGenerator {
  static final Random _random = Random();

  static List<Question> generate(String typeCode, int count) {
    switch (typeCode) {
      case 'vert_addsub':
        return _genVertAddsub(count);
      case 'vert_mul':
        return _genVertMul(count);
      case 'vert_div':
        return _genVertDiv(count);
      case 'mixed_all':
        return _genMixedAll(count);
      case 'mixed_bracket':
        return _genMixedBracket(count);
      case 'solve_tri':
        return _genSolveTri(count);
      case 'rmb_exchange':
        return _genRmbExchange(count);
      case 'time_exchange':
        return _genTimeExchange(count);
      case 'length_exchange':
        return _genLengthExchange(count);
      case 'weight_exchange':
        return _genWeightExchange(count);
      case 'perimeter_area':
        return _genPerimeterArea(count);
      case 'area_unit':
        return _genAreaUnit(count);
      case 'pattern':
        return _genPattern(count);
      case 'times':
        return _genTimes(count);
      case 'decimal':
        return _genDecimal(count);
      case 'direction':
        return _genDirection(count);
      default:
        return [];
    }
  }

  // 竖式加减法
  static List<Question> _genVertAddsub(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      if (_random.nextBool()) {
        int a = _random.nextInt(49001) + 1000;
        int b = _random.nextInt(99999 - a) + 100;
        questions.add(Question(text: '$a + $b =', number: i + 1));
      } else {
        int a = _random.nextInt(50000) + 5000;
        int b = _random.nextInt(a - 100) + 100;
        questions.add(Question(text: '$a - $b =', number: i + 1));
      }
    }
    return questions;
  }

  // 竖式乘法
  static List<Question> _genVertMul(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int b = _random.nextInt(8) + 2;
      int a = _random.nextInt(99999 ~/ b) + 100;
      questions.add(Question(text: '$a × $b =', number: i + 1));
    }
    return questions;
  }

  // 竖式除法
  static List<Question> _genVertDiv(int count) {
    List<Question> questions = [];
    List<int> usedDivisors = [];
    for (int i = 0; i < count; i++) {
      List<int> available = List.generate(8, (i) => i + 2)
          .where((d) => !usedDivisors.contains(d)).toList();
      if (available.isEmpty) usedDivisors = [];
      available = List.generate(8, (i) => i + 2);
      
      int b = available[_random.nextInt(available.length)];
      usedDivisors.add(b);
      if (usedDivisors.length > 8) usedDivisors = [];

      int digits = _random.nextInt(3) + 3;
      int a;
      if (digits == 3) {
        a = _random.nextInt(900) + 100;
      } else if (digits == 4) {
        a = _random.nextInt(9000) + 1000;
      } else {
        a = _random.nextInt(90000) + 10000;
      }
      questions.add(Question(text: '$a ÷ $b =', number: i + 1));
    }
    return questions;
  }

  // 混合运算
  static List<Question> _genMixedAll(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      if (_random.nextBool()) {
        int a = _random.nextInt(29001) + 1000;
        int b = _random.nextInt(9901) + 100;
        int c = _random.nextInt(4901) + 100;
        int result = a + b - c;
        if (result > 0 && result <= 99999) {
          questions.add(Question(text: '$a + $b - $c =', number: i + 1));
        } else {
          questions.add(Question(text: '$a - $b + $c =', number: i + 1));
        }
      } else {
        int a = _random.nextInt(9900) + 100;
        int b = _random.nextInt(8) + 2;
        int c = _random.nextInt(8) + 2;
        questions.add(Question(text: '$a × $b ÷ $c =', number: i + 1));
      }
    }
    return questions;
  }

  // 带括号混合运算
  static List<Question> _genMixedBracket(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(4) + 1;
      String text;
      switch (typ) {
        case 1:
          int a = _random.nextInt(191) + 10;
          int b = _random.nextInt(96) + 5;
          int c = _random.nextInt(8) + 2;
          text = '($a + $b) × $c =';
          break;
        case 2:
          int a = _random.nextInt(251) + 50;
          int b = _random.nextInt(a - 10) + 10;
          int c = _random.nextInt(8) + 2;
          text = '($a - $b) ÷ $c =';
          break;
        case 3:
          int a = _random.nextInt(91) + 10;
          int b = _random.nextInt(46) + 5;
          int c = _random.nextInt(28) + 3;
          text = '$a × ($b + $c) =';
          break;
        default:
          int c = _random.nextInt(8) + 2;
          int b = _random.nextInt(8) + 2;
          int base = _random.nextInt(10) + 2;
          int a = c * (base + b);
          text = '$a ÷ ($b + $c) =';
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 求未知数
  static List<Question> _genSolveTri(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(4) + 1;
      String text;
      switch (typ) {
        case 1:
          int a = _random.nextInt(8) + 2;
          int b = _random.nextInt(9) + 1;
          int tri = _random.nextInt(9) + 1;
          int c = a * (tri + b);
          text = '$a × (△ + $b) = $c';
          break;
        case 2:
          int a = _random.nextInt(8) + 2;
          int b = _random.nextInt(5) + 5;
          int tri = _random.nextInt(b - 1) + 1;
          int c = a * (b - tri);
          text = '$a × ($b - △) = $c';
          break;
        case 3:
          int a = _random.nextInt(9900) + 100;
          int tri = _random.nextInt(990) + 10;
          int b = a + tri;
          text = '$a + △ = $b';
          break;
        default:
          int a = _random.nextInt(8) + 2;
          int tri = _random.nextInt(990) + 10;
          int b = a * tri;
          text = '$a × △ = $b';
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 人民币换算 - 复合换算
  static List<Question> _genRmbExchange(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(4) + 1;
      String text;
      switch (typ) {
        case 1:
          int y = _random.nextInt(100) + 1;
          text = '$y元 = （  ）角';
          break;
        case 2:
          int j = _random.nextInt(89) + 11;
          text = '$j角 = （  ）元（  ）角';
          break;
        case 3:
          int y1 = _random.nextInt(20) + 1;
          int j1 = _random.nextInt(9) + 1;
          int y2 = _random.nextInt(20) + 1;
          int j2 = _random.nextInt(9) + 1;
          text = '$y1元$j1角 + $y2元$j2角 = （  ）元（  ）角';
          break;
        default:
          int y1 = _random.nextInt(26) + 5;
          int j1 = _random.nextInt(5) + 5;
          int y2 = _random.nextInt(y1 - 1) + 1;
          int j2 = _random.nextInt(j1) + 1;
          text = '$y1元$j1角 - $y2元$j2角 = （  ）元（  ）角';
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 时间换算 - 多种题型
  static List<Question> _genTimeExchange(int count) {
    List<Question> questions = [];
    List<String> scenes1 = [
      '开始，{}时{}分后是（  ）时（  ）分',
      '出发，{}时{}分后到达，到达时间是（  ）时（  ）分',
      '开始开会，{}时{}分后结束，结束时间是（  ）时（  ）分',
    ];
    List<String> scenes2 = [
      '从{}时{}分到{}时{}分，经过了（  ）时（  ）分',
      '从{}时{}分开始写作业，到{}时{}分写完，写了（  ）时（  ）分',
      '从{}时{}分开始看电影，{}时{}分结束，放映了（  ）时（  ）分',
    ];

    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(6) + 1;
      String text;
      switch (typ) {
        case 1:
          int h = _random.nextInt(12) + 1;
          text = '$h小时 = （  ）分钟';
          break;
        case 2:
          int m = _random.nextInt(59) + 1;
          text = '$m分钟 = （  ）秒';
          break;
        case 3:
          int h1 = _random.nextInt(15) + 6;
          int m1 = _random.nextInt(46);
          int h2 = _random.nextInt(3) + 1;
          int m2 = _random.nextInt(60);
          String scene = scenes1[_random.nextInt(scenes1.length)];
          text = '$h1时${m1.toString().padLeft(2, '0')}分$scene'
              .replaceAll('{}', '$h2时${m2.toString().padLeft(2, '0')}分');
          break;
        case 4:
          int h1 = _random.nextInt(12) + 7;
          int m1 = _random.nextInt(60);
          int totalMin = _random.nextInt(151) + 30;
          int endH = h1 + (m1 + totalMin) ~/ 60;
          int endM = (m1 + totalMin) % 60;
          String scene = scenes2[_random.nextInt(scenes2.length)];
          text = scene
              .replaceAll('{}', '$h1时${m1.toString().padLeft(2, '0')}分')
              .replaceFirst('{}', '$endH时${endM.toString().padLeft(2, '0')}分')
              .replaceFirst('{}', '$endH时${endM.toString().padLeft(2, '0')}分');
          break;
        case 5:
          List<int> hours = List.generate(13, (i) => i + 7)..shuffle(_random);
          List<int> mins = [_random.nextInt(60), _random.nextInt(60), _random.nextInt(60)];
          text = '（  ）<（  ）<（  ）  A.${hours[0]}时${mins[0].toString().padLeft(2, '0')}分  B.${hours[1]}时${mins[1].toString().padLeft(2, '0')}分  C.${hours[2]}时${mins[2].toString().padLeft(2, '0')}分';
          break;
        default:
          int h = _random.nextInt(5) + 1;
          int m = _random.nextInt(41) +10;
          text = '$h小时${m}分钟 = （  ）分钟';
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 长度换算 - 复合换算
  static List<Question> _genLengthExchange(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(5) + 1;
      String text;
      switch (typ) {
        case 1:
          int m = _random.nextInt(20) + 1;
          text = '$m米 = （  ）分米';
          break;
        case 2:
          int dm = _random.nextInt(99) + 1;
          text = '$dm分米 = （  ）厘米';
          break;
        case 3:
          int cm = _random.nextInt(200) + 1;
          text = '$cm厘米 = （  ）毫米';
          break;
        case 4:
          int m = _random.nextInt(10) + 1;
          int dm = _random.nextInt(9) + 1;
          text = '$m米${dm}分米 = （  ）分米';
          break;
        default:
          if (_random.nextBool()) {
            int m1 = _random.nextInt(15) + 1;
            int dm1 = _random.nextInt(9) + 1;
            int m2 = _random.nextInt(10) + 1;
            int dm2 = _random.nextInt(dm1) + 1;
            text = '$m1米${dm1}分米 + $m2米${dm2}分米 = （  ）米（  ）分米';
          } else {
            int m1 = _random.nextInt(16) + 5;
            int dm1 = _random.nextInt(5) + 5;
            int m2 = _random.nextInt(m1 - 1) + 1;
            int dm2 = _random.nextInt(dm1) + 1;
            text = '$m1米${dm1}分米 - $m2米${dm2}分米 = （  ）米（  ）分米';
          }
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 质量换算 - 复合换算
  static List<Question> _genWeightExchange(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(5) + 1;
      String text;
      switch (typ) {
        case 1:
          int kg = _random.nextInt(20) + 1;
          text = '$kg千克 = （  ）克';
          break;
        case 2:
          int g = _random.nextInt(1901) + 100;
          text = '$g克 = （  ）千克（  ）克';
          break;
        case 3:
          int kg = _random.nextInt(10) + 1;
          int g = _random.nextInt(801) + 100;
          text = '$kg千克${g}克 = （  ）克';
          break;
        default:
          if (_random.nextBool()) {
            int kg1 = _random.nextInt(10) + 1;
            int g1 = _random.nextInt(801) + 100;
            int kg2 = _random.nextInt(5) + 1;
            int g2 = _random.nextInt(801) + 100;
            text = '$kg1千克${g1}克 + $kg2千克${g2}克 = （  ）千克（  ）克';
          } else {
            int kg1 = _random.nextInt(11) + 5;
            int g1 = _random.nextInt(601) + 300;
            int kg2 = _random.nextInt(kg1 - 1) + 1;
            int g2 = _random.nextInt(g1) + 100;
            text = '$kg1千克${g1}克 - $kg2千克${g2}克 = （  ）千克（  ）克';
          }
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 周长和面积计算 - 合并
  static List<Question> _genPerimeterArea(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      if (_random.nextBool()) {
        int l = _random.nextInt(90) + 10;
        int w = _random.nextInt(90) + 10;
        questions.add(Question(
          text: '长方形长${l}cm，宽${w}cm，周长是（  ）cm',
          number: i + 1,
        ));
      } else {
        int l = _random.nextInt(26) + 5;
        int w = _random.nextInt(26) + 5;
        questions.add(Question(
          text: '长方形长${l}m，宽${w}m，面积是（  ）平方米',
          number: i + 1,
        ));
      }
    }
    return questions;
  }

  // 面积单位换算
  static List<Question> _genAreaUnit(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int sqm = _random.nextInt(50) + 1;
      questions.add(Question(
        text: '$sqm平方米 = （  ）平方分米',
        number: i + 1,
      ));
    }
    return questions;
  }

  // 找规律填数
  static List<Question> _genPattern(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(4) + 1;
      String text;
      switch (typ) {
        case 1:
          int start = _random.nextInt(20) + 1;
          int diff = _random.nextInt(4) + 2;
          text = '${start}, ${start + diff}, ${start + diff * 2}, ________';
          break;
        case 2:
          int a = _random.nextInt(4) + 2;
          text = '$a, ${a * 2}, ${a * 3}, ________';
          break;
        case 3:
          int a = _random.nextInt(3) + 1;
          int b = _random.nextInt(3) + 1;
          text = '$a, $b, $a, $b, ________';
          break;
        default:
          int n = _random.nextInt(10) + 1;
          text = '$n, ${n + 2}, ${n + 4}, ________';
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 倍的认识 - 每行一道
  static List<Question> _genTimes(int count) {
    List<Question> questions = [];
    List<List<String>> names = [
      ['小明', '小红'],
      ['爸爸', '儿子'],
      ['哥哥', '弟弟'],
      ['苹果', '梨'],
    ];
    List<String> items = ['本', '个', '只', '支'];

    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(3) + 1;
      String text;
      switch (typ) {
        case 1:
          int a = _random.nextInt(8) + 2;
          int b = _random.nextInt(8) + 2;
          text = '$a的${b}倍是（  ）';
          break;
        case 2:
          int a = (_random.nextInt(8) + 2) * (_random.nextInt(8) + 2);
          int b = _random.nextInt(8) + 2;
          text = '$a是${b}的（  ）倍';
          break;
        default:
          int a = _random.nextInt(9) + 1;
          int b = a * (_random.nextInt(4) + 2);
          var namePair = names[_random.nextInt(names.length)];
          String item = items[_random.nextInt(items.length)];
          text = '${namePair[0]}有$a$item，${namePair[1]}有$b$item，${namePair[1]}是${namePair[0]}的（  ）倍';
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }

  // 小数加减法
  static List<Question> _genDecimal(int count) {
    List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      double a = (_random.nextInt(100) + 1) + (_random.nextInt(10) / 10);
      double b = (_random.nextInt(50) + 1) + (_random.nextInt(10) / 10);
      String aStr = a.toStringAsFixed(1);
      String bStr = b.toStringAsFixed(1);
      if (a + b < 200) {
        questions.add(Question(text: '$aStr + $bStr =', number: i + 1));
      } else {
        questions.add(Question(
          text: '${a.toStringAsFixed(1)} - ${b.toStringAsFixed(1)} =',
          number: i + 1,
        ));
      }
    }
    return questions;
  }

  // 方向与位置 - 每行一道
  static List<Question> _genDirection(int count) {
    Map<String, String> dirs = {'东': '西', '南': '北', '西': '东', '北': '南'};
    List<String> keys = dirs.keys.toList();
    List<Question> questions = [];

    for (int i = 0; i < count; i++) {
      int typ = _random.nextInt(4) + 1;
      String text;
      switch (typ) {
        case 1:
          String d = keys[_random.nextInt(keys.length)];
          text = '$d的相反方向是（  ）';
          break;
        case 2:
          text = '地图上通常上面是（  ），右面是（  ）';
          break;
        case 3:
          String d1 = keys[_random.nextInt(keys.length)];
          String d2 = dirs[d1]!;
          text = '$d1的相反方向是$d2，$d1的左边是（  ）';
          break;
        default:
          String d = keys[_random.nextInt(keys.length)];
          text = '小花向$d走50米，再向${dirs[d]}走30米，现在她在（  ）方向';
      }
      questions.add(Question(text: text, number: i + 1));
    }
    return questions;
  }
}
