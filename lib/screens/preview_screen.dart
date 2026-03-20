import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../models/question.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<Question> _questions = [];
  bool _isGenerating = false;
  String? _pdfPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<Question>) {
      _questions = args;
    }
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Text(
              '小学数学练习题',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          footer: (context) => pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              '第 ${context.pageNumber} 页 / 共 ${context.pagesCount} 页',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          build: (context) => [
            // 题目列表
            pw.ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 30,
                        child: pw.Text(
                          '${q.number}.',
                          style: pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          q.text,
                          style: pw.TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );

      // 保存PDF
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _pdfPath = '${directory.path}/数学练习题_$timestamp.pdf';
      
      final file = File(_pdfPath!);
      await file.writeAsBytes(await pdf.save());

      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF已生成: ${file.path}'),
            action: SnackBarAction(
              label: '分享',
              onPressed: () => _sharePdf(),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('生成失败: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfPath != null) {
      await Share.shareXFiles([XFile(_pdfPath!)], text: '小学数学练习题');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('题目预览'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _isGenerating ? null : _generatePdf,
            tooltip: '生成PDF',
          ),
          if (_pdfPath != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _sharePdf,
              tooltip: '分享',
            ),
        ],
      ),
      body: _questions.isEmpty
          ? const Center(child: Text('暂无题目'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _questions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final q = _questions[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF2196F3),
                    child: Text(
                      '${q.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    q.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
      bottomNavigationBar: _questions.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generatePdf,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(_isGenerating ? '生成中...' : '生成PDF（共${_questions.length}题）'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            )
          : null,
    );
  }
}
