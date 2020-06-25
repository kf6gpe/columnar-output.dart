import 'package:test/test.dart';
import 'package:columnar_output/columnar.dart';

void main() {
  group('Document', () {
    final simpleTable = '''
|  |  |
|--|--|
| Column 1, Row 1 | Column 2, Row 1 |
| Column 1, Row 2 | Column 2, Row 2 |


''';
    final raggedTable = '''
|  |  |
|--|--|
| Column 1, Row 1 | Column 2, Row 1 |
| Column 1, Row 2 | Column 2, Row 2 |
| Column 1, Row 3 | |


''';


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
      c.header = 'hello';
      expect(c.header, 'hello');
    });

    test('Simple table to markdown', () {
      Document d = Document();
      d.appendColumn();
      d.appendColumn();
      d.columns[0].append(Paragraph(text:'Column 1, Row 1'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 2'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 1'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 2'));
      expect(d.toMarkdown(), simpleTable);
    });

    test('Ragged table to markdown', () {
      Document d = Document();
      d.appendColumn();
      d.appendColumn();
      d.columns[0].append(Paragraph(text:'Column 1, Row 1'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 2'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 3'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 1'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 2'));
      expect(d.toMarkdown(), raggedTable);
    });

    test('Multiple columns broken down the page', () {
      Document d = Document();
      d.appendColumn();
      d.appendColumn();
      d.appendColumn();
      d.columns[0].header = '1';
      d.columns[1].header = '2';
      d.columns[2].header = '3';
      d.columns[0].append(Paragraph(text:'Column 1, Row 1'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 2'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 3'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 1'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 2'));
      d.columns[2].append(Paragraph(text:'Column 3, Row 1'));
      d.columns[2].append(Paragraph(text:'Column 3, Row 2'));

      print(d.toMarkdown(2));

      expect(d.toMarkdown(), raggedTable);


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
