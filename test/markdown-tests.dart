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
      expect(p.backgroundColor.toString(), '0xffffff');
      expect(p.foregroundColor.toString(), '0x000000');
      expect(p.bold, false);
      expect(p.emphasize, false);
      expect(p.href, null);
    });

    test('Hyperlink', () {
      Paragraph p = Paragraph(text:'hello world', href:'http://kf6gpe.org');
      expect(p.text, 'hello world');
      expect(p.backgroundColor.toString(), '0xffffff');
      expect(p.foregroundColor.toString(), '0x000000');
      expect(p.bold, false);
      expect(p.emphasize, false);
      expect(p.href, 'http://kf6gpe.org');
    });

    test('To Markdown', () {
      Paragraph p = Paragraph(text:'hello world');
      expect(p.toMarkdown(), 'hello world\n\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org');
      expect(p.toMarkdown(), '[hello world](http://kf6gpe.org)\n\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org', emphasize: true);
      expect(p.toMarkdown(), '*[hello world](http://kf6gpe.org)*\n\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org', bold: true);
      expect(p.toMarkdown(), '**[hello world](http://kf6gpe.org)**\n\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org', bold: true, emphasize: true);
      expect(p.toMarkdown(), '** *[hello world](http://kf6gpe.org)* **\n\n');
    });

  });

}
