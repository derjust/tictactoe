library Enum;

class Enum {
  final _value;
  const Enum._internal(this._value);
  toString() => 'Enum.$_value';

  static const X = const Enum._internal('X');
  static const O = const Enum._internal('O');
  static const EMPTY= const Enum._internal('');
}
