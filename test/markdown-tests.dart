import 'package:test/test.dart';
import 'package:columnar_output/columnar.dart';

void main() {
  group('Document', () {
    test('Colum access and mutation', () {
      Document d = Document();
      expect(d.columnCount, 0);
      d.appendColumn();
      expect(d.columnCount, 1);
      expect(d[0].rowCount, 0);
      d[0].append(Paragraph(text: 'hello world'));
      expect(d[0].rowCount, 1);
      Column c = d[0];
      expect(c[0].text, 'hello world');
    });

  });

  group('Paragraph', () {
    test('Text', () {
      Paragraph p = Paragraph(text:'hello world');
      expect(p.text, 'hello world');
      expect(p.backgroundColor.toString(), '0xFFFFFF');
      expect(p.foregroundColor.toString(), '0x000000');
      expect(p.bold, false);
      expect(p.emphasize, false);
      expect(p.href, null);


    });
  });

}
