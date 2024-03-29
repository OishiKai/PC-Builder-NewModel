import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class DocumentRepository {
  DocumentRepository(this.targetUrl);
  final String targetUrl;

  Future<Document> fetchDocument() async {
    // HTTP GETリクエスト送信
    final targetUri = Uri.parse(targetUrl);
    final response = await http.get(targetUri);

    try {
      // response を Shift_JIS にデコード
      final documentBody =
          await CharsetConverter.decode('Shift_JIS', response.bodyBytes);

      // パース
      final document = parse(documentBody);
      return document;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      final document = parse(response.body);
      return document;
    }
  }
}
