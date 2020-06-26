import 'dart:collection';

import 'dart:ffi';

class Color {
  int r, g, b;
  int get code => 
    (r << 16) | (g << 8) | b;
  Color(int code) {
    r = ((code >> 16) & 0xFF);
    g = ((code >>  8) & 0xFF);
    b = ((code      ) & 0xFF);
  }
  String toString() {
    return '0x' + code.toRadixString(16).padLeft(6, '0');
  }
}


class Paragraph {
  String _text;
  get text => _text;
  String _href;
  get href => _href;
  String _styleClass;
  get styleClass => _styleClass;
  bool _emphasize;
  get emphasize => _emphasize;
  bool _bold;
  get bold => _bold;

  Paragraph({String text = '', String href = null, 
    String styleClass,
    bool emphasize = false, bool bold = false}) {
      _text = text;
      _href = href;
      _styleClass = styleClass;
      _emphasize = emphasize;
      _bold = bold;
    }

    String toMarkdown() {
      String result = '';
      if (_bold) result += '**';
      if (_bold && _emphasize) result += ' *'; else if (!_bold && _emphasize) result += '*';
      if (_href != null) result += '[';
      result += text;
      if (_href != null) result += '](${_href})';
      if (_bold && _emphasize) result += '* '; else if (!_bold && _emphasize) result += '*';
      if (_bold) result += '**';
      result += '\n\n';
      return result;
    }

    String toHtml() {
      String result = '<p>';
      if (_bold) result += '<b>';
      if (_emphasize) result += '<em>';
      if (_href != null) result += '<a href="${_href}">';
      result += text;
      if (_href != null) result += '</a>';
      if (_emphasize) result += '</em>';
      if (_bold) result += '</b>';
      result += '</p>\n';
      return result;
    }

    String toString() {
      return _text;
    }
}

class Column {
  String _header = '';
  get header => _header;
  void set header(h) => _header = h;
  List<Paragraph> _rows = List<Paragraph>();
  get rows => _rows;
  get rowCount => _rows.length;
  operator [](int i) => _rows[i];

  void append(Paragraph p) => _rows.add(p);
  void insert(int i, Paragraph p) => rows.insert(i, p);

  Column();
}

class Document {
  List<Column> _columns = List<Column>();
  get columns => _columns;
  get columnCount => _columns.length;
  operator [](int i) => _columns[i];

  void appendColumn() => _columns.add(Column());
  void insertColumn(int i, [ Column c = null ] ) => 
    _columns.insert(i, c ?? Column());

  Document();

  String toMarkdown([int columnsAcross = -1]) {
    var result = '';
    int columnIndex = 0;

    columnsAcross = columnsAcross == -1 ? columnCount : columnsAcross;
    // Create n tables, each columnsAcross columns.
    do {
      var maxRows = -1;
      var rule = '';

      int untilColumn = columnIndex + columnsAcross < columnCount ? columnIndex + columnsAcross : columnCount;

      // Find out how many rows down the longest column is in this set
      for(int i = columnIndex; i < untilColumn; i++) {
        maxRows = _columns[i].rowCount > maxRows ? _columns[i].rowCount : maxRows;
      }

      // Make our headers and the rule below them.
      for(var i = columnIndex; i < untilColumn; i++) {
          result += '| ${_columns[i].header} ';
          rule += '|--';
      }
      result += '|\n${rule}|\n';

      // Write each row of each column
      for(var rowIndex = 0; rowIndex < maxRows; rowIndex++) {
        for(var i = columnIndex; i < untilColumn; i++) {
          result += '| ';
          if (rowIndex < _columns[i].rowCount) result += _columns[i][rowIndex].toMarkdown().substring(0, _columns[i][rowIndex].toMarkdown().length-2) + ' ';
        }
        result += '|\n';
      }
      result += '\n\n';

      columnIndex += columnsAcross;
    } while (columnIndex < columnCount);

    return result;
  }

}