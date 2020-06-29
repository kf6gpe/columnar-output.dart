import 'package:test/test.dart';
import 'package:columnar_output/columnar.dart';

void main() {
  group('Document', () {
    final simpleTable = '''
<table><tr><td><p>Column 1, Row 1</p</td><td><p>Column 2, Row 1</p</td></tr><tr><td><p>Column 1, Row 2</p</td><td><p>Column 2, Row 2</p</td></tr></table>
''';
    final raggedTable = '''
<table><tr><td><p>Column 1, Row 1</p</td><td><p>Column 2, Row 1</p</td></tr><tr><td><p>Column 1, Row 2</p</td><td><p>Column 2, Row 2</p</td></tr><tr><td></td><td><p>Column 2, Row 3</p</td></tr></table>
''';
    final twoTables = '''
<table><tr><th>1</th><th>2</th></tr><tr><td><p>Column 1, Row 1</p</td><td><p>Column 2, Row 1</p</td></tr><tr><td><p>Column 1, Row 2</p</td><td><p>Column 2, Row 2</p</td></tr><tr><td><p>Column 1, Row 3</p</td><td></td></tr></table>
<table><tr><th>3</th></tr><tr><td><p>Column 3, Row 1</p</td></tr><tr><td><p>Column 3, Row 2</p</td></tr></table>
''';
    final simpleTableWithLink = '''
<table><tr><td><p>Column 1, Row 1</p</td><td><p>Column 2, Row 1</p</td></tr><tr><td><p>Column 1, Row 2</p</td><td><p><a href="http://kf6gpe.org">Column 2, Row 2</a></p</td></tr></table>
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

    test('Simple table to html', () {
      Document d = Document();
      d.appendColumn();
      d.appendColumn();
      d.columns[0].append(Paragraph(text:'Column 1, Row 1'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 2'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 1'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 2', href:'http://kf6gpe.org'));
      expect(d.toHtml(), simpleTableWithLink);
    });

    test('Simple table to html', () {
      Document d = Document();
      d.appendColumn();
      d.appendColumn();
      d.columns[0].append(Paragraph(text:'Column 1, Row 1'));
      d.columns[0].append(Paragraph(text:'Column 1, Row 2'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 1'));
      d.columns[1].append(Paragraph(text:'Column 2, Row 2'));
      expect(d.toHtml(), simpleTable);
    });

    test('Ragged table to html', () {
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
      expect(d.toHtml(2), twoTables);
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
