class Color {
  int r, g, b;
  int get code => (r << 16) | (g << 8) | b;
  Color(int code) {
    r = ((code >> 16) & 0xFF);
    g = ((code >> 8) & 0xFF);
    b = ((code) & 0xFF);
  }
  @override
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

  Paragraph(
      {String text = '',
      String href,
      String styleClass,
      bool emphasize = false,
      bool bold = false}) {
    _text = text;
    _href = href;
    _styleClass = styleClass;
    _emphasize = emphasize;
    _bold = bold;
  }

  String toMarkdown() {
    String result = '';
    if (_bold) result += '**';
    if (_bold && _emphasize) {
      result += ' *';
    } else if (!_bold && _emphasize) {
      result += '*';
    }
    if (_href != null) result += '[';
    result += text;
    if (_href != null) result += ']($_href)';
    if (_bold && _emphasize) {
      result += '* ';
    } else if (!_bold && _emphasize) {
      result += '*';
    }
    if (_bold) result += '**';
    result += '\n\n';
    return result;
  }

  String toHtml() {
    String result = '';
    if (_bold) result += '<b>';
    if (_emphasize) result += '<em>';
    if (_href != null) result += '<a href="$_href">';
    result += text;
    if (_href != null) result += '</a>';
    if (_emphasize) result += '</em>';
    if (_bold) result += '</b>';
    return result;
  }

  @override
  String toString() => _text;
}

class Column {
  String _header = '';
  get header => _header;
  set header(h) => _header = h;
  final _rows = <Paragraph>[];
  get rows => _rows;
  get rowCount => _rows.length;
  operator [](int i) => _rows[i];

  void append(Paragraph p) => _rows.add(p);
  void insert(int i, Paragraph p) => rows.insert(i, p);

  Column();
}

class Document {
  final List<Column> _columns = <Column>[];
  get columns => _columns;
  get columnCount => _columns.length;
  operator [](int i) => _columns[i];

  void appendColumn() => _columns.add(Column());
  void insertColumn(int i, [Column c]) => _columns.insert(i, c ?? Column());

  Document();

  String toMarkdown([int columnsAcross = -1]) {
    var result = '';
    int columnIndex = 0;

    columnsAcross = columnsAcross == -1 ? columnCount : columnsAcross;
    // Create n tables, each columnsAcross columns.
    do {
      var maxRows = -1;
      var rule = '';

      int untilColumn = columnIndex + columnsAcross < columnCount
          ? columnIndex + columnsAcross
          : columnCount;

      // Find out how many rows down the longest column is in this set
      for (int i = columnIndex; i < untilColumn; i++) {
        maxRows =
            _columns[i].rowCount > maxRows ? _columns[i].rowCount : maxRows;
      }

      // Make our headers and the rule below them.
      for (var i = columnIndex; i < untilColumn; i++) {
        result += '| ${_columns[i].header} ';
        rule += '|--';
      }
      result += '|\n$rule|\n';

      // Write each row of each column
      for (var rowIndex = 0; rowIndex < maxRows; rowIndex++) {
        for (var i = columnIndex; i < untilColumn; i++) {
          result += '| ';
          if (rowIndex < _columns[i].rowCount) {
            result += _columns[i][rowIndex].toMarkdown().substring(
                    0, _columns[i][rowIndex].toMarkdown().length - 2) +
                ' ';
          }
        }
        result += '|\n';
      }
      result += '\n\n';

      columnIndex += columnsAcross;
    } while (columnIndex < columnCount);

    return result;
  }

  String toHtml([int columnsAcross = -1]) {
    var result = '';
    int columnIndex = 0;
    bool columnsNeedHeaders = false;

    for (var column in _columns) {
      if (column._header != '') {
        columnsNeedHeaders = true;
        break;
      }
    }

    columnsAcross = columnsAcross == -1 ? columnCount : columnsAcross;
    // Create n tables, each columnsAcross columns.
    do {
      var maxRows = -1;

      int untilColumn = columnIndex + columnsAcross < columnCount
          ? columnIndex + columnsAcross
          : columnCount;

      // Find out how many rows down the longest column is in this set
      for (int i = columnIndex; i < untilColumn; i++) {
        maxRows =
            _columns[i].rowCount > maxRows ? _columns[i].rowCount : maxRows;
      }

      result += '<table class="equal-width">';

      if (columnsNeedHeaders) {
        result += '<tr>';
        // Make our headers and the rule below them.
        for (var i = columnIndex; i < untilColumn; i++) {
          result += '<th>${_columns[i].header}</th>';
        }
        result += '</tr>';
      }

      // Write each row of each column
      for (var rowIndex = 0; rowIndex < maxRows; rowIndex++) {
        result += '<tr>';
        for (var i = columnIndex; i < untilColumn; i++) {
          result += rowIndex > columns[i].rows.length - 1 ||
                  _columns[i][rowIndex].styleClass == null
              ? '<td>'
              : '<td class="${_columns[i][rowIndex].styleClass}">';
          if (rowIndex < _columns[i].rowCount) {
            result += _columns[i][rowIndex].toHtml();
          }
          result += '</td>';
        }
        result += '</tr>';
      }
      columnIndex += columnsAcross;
      result += '</table>\n';
    } while (columnIndex < columnCount);

    return result;
  }
}
