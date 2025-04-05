enum LinkMethodEnum {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE');

  final String _value;

  const LinkMethodEnum(this._value);

  String get name => _value;

  @override
  String toString() => _value;
}
