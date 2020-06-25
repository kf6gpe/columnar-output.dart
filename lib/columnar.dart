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
  Color _foreground;
  get foregroundColor => _foreground;
  Color _background;
  get backgroundColor => _background;
  bool _emphasize;
  get emphasize => _emphasize;
  bool _bold;
  get bold => _bold;

  static final _defaultForeground = Color(0x000000);
  static final _defaultBackground = Color(0xFFFFFF);

  Paragraph({String text = '', String href = null, 
    Color foreground, Color background,
    bool emphasize = false, bool bold = false}) {
      _text = text;
      _href = href;
      _foreground = foreground ?? _defaultForeground;
      _background = background ?? _defaultBackground;
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
      throw("Unimplemented!");
    }

    String toString() {
      return _text;
    }
}

class Column {
  String _header = '';
  get header => _header;
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

  String toMarkdown() {
    var result = '';
    var maxRows = -1;
    var rule = '';
    _columns.forEach((column) => 
      maxRows = column.rowCount > maxRows ? column.rowCount : maxRows);
    for(var columnIndex = 0; columnIndex < columnCount; columnIndex++) {
        result += '| ${_columns[columnIndex].header} ';
        rule += '|--';
    }
    result += '|\n${rule}|\n';
    for(var rowIndex = 0; rowIndex < maxRows; rowIndex++) {
      for(var columnIndex = 0; columnIndex < columnCount; columnIndex++) {
        result += '| ';
        if (rowIndex < _columns[columnIndex].rowCount) result += _columns[columnIndex][rowIndex].toMarkdown().substring(0, _columns[columnIndex][rowIndex].toMarkdown().length-2) + ' ';
      }
      result += '|\n';
    }
    result += '\n';

    return result;
  }

}