import 'package:test/test.dart';
import 'package:columnar_output/columnar.dart';

void main() {
  group('Document', () {
    final simpleTable = '''
<table><tr><td>Column 1, Row 1</td><td>Column 2, Row 1</td></tr><tr><td>Column 1, Row 2</td><td>Column 2, Row 2</td></tr></table>
''';
    final raggedTable = '''
<table><tr><td>Column 1, Row 1</td><td>Column 2, Row 1</td></tr><tr><td>Column 1, Row 2</td><td>Column 2, Row 2</td></tr><tr><td></td><td>Column 2, Row 3</td></tr></table>
''';
    final twoTables = '''
| 1 | 2 |
|--|--|
| Column 1, Row 1 | Column 2, Row 1 |
| Column 1, Row 2 | Column 2, Row 2 |
| Column 1, Row 3 | |


| 3 |
|--|
| Column 3, Row 1 |
| Column 3, Row 2 |


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
      expect(d.toHtml(), simpleTable);
    });

    test('Ragged table to markdown', () {
      Document d = Document();
      d.appendColumn();
      d.appendColumn();
      d.columns[0].append(Paragraph(text:'Column 1, Row 1'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 2'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 1'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 2'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 3'));
      expect(d.toHtml(), raggedTable);
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
      print(d.toHtml(2));
      expect(d.toMarkdown(2), twoTables);
    });

  });

  group('Paragraph', () {
    test('Text', () {
      Paragraph p = Paragraph(text:'hello world');
      expect(p.text, 'hello world');
      expect(p.styleClass, null);
      expect(p.bold, false);
      expect(p.emphasize, false);
      expect(p.href, null);
    });

    test('Hyperlink', () {
      Paragraph p = Paragraph(text:'hello world', href:'http://kf6gpe.org', styleClass:'P1');
      expect(p.text, 'hello world');
      expect(p.styleClass, 'P1');
      expect(p.bold, false);
      expect(p.emphasize, false);
      expect(p.href, 'http://kf6gpe.org');
    });

    test('To HTML', () {
      Paragraph p = Paragraph(text:'hello world');
      expect(p.toHtml(), '<p>hello world</p>\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org');
      expect(p.toHtml(), '<p><a href="http://kf6gpe.org">hello world</a></p>\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org', styleClass: 'P1');
      expect(p.toHtml(), '<p class="P1"><a href="http://kf6gpe.org">hello world</a></p>\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org', emphasize: true);
      expect(p.toHtml(), '<p><em><a href="http://kf6gpe.org">hello world</a></em></p>\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org', bold: true);
      expect(p.toHtml(), '<p><b><a href="http://kf6gpe.org">hello world</a></b></p>\n');

      p = Paragraph(text:'hello world', href:'http://kf6gpe.org', bold: true, emphasize: true);
      expect(p.toHtml(), '<p><b><em><a href="http://kf6gpe.org">hello world</a></em></b></p>\n');
    });

  });

}
