/// Poor mans generator
///
/// I often need to write the same boiler plate over and over again for adding serialization to my classes.
/// Since i mainly use it for my BRIDGE and SMALLREAD projects, the normal json generators dont exactly fit my needs.
/// And since im too lazy to figure out how to write propper generators, i just use the hacky workaround in here
///
/// 2022-02-17

/// Defines a property in a data class that should be generated
class PropertyDefinition {
  /// Type of the property.
  final Type type;

  /// Use this to replace [type] with typedefs
  final String? typeDef;

  /// Cant put nullable into type sadly
  final bool nullable;

  /// Name of the property
  final String name;

  /// If not optional, its required
  final bool optional;

  /// Required if [optional] and not [nullable].
  final String? defaultValue;

  /// If null, uses [name]
  final String? key;

  final List<String>? docString;

  /// enum support is not very strong right now, the best results can be achieved my instead:
  /// - keeping this false even for enums
  /// - creating an extension for your enums `extension MyEnumX on MyEnum`
  /// - that implement `Map encode()` and `static MyEnum decode(Map m)`
  /// - changing the generated `MyEnum.decode` calls to `MyEnumX.decode` calls manually
  final bool isEnum;

  const PropertyDefinition({
    required this.type,
    this.typeDef,
    this.nullable = false,
    required this.name,
    this.optional = false,
    this.defaultValue,
    this.key,
    this.docString,
    this.isEnum = false,
  }) : assert(defaultValue != null || !(optional && !nullable));

  PropertyDefinition copyWith({
    Type? type,
    String? typeDef,
    bool? nullable,
    String? name,
    bool? optional,
    String? defaultValue,
    String? key,
    List<String>? docString,
    bool? isEnum,
  }) {
    return PropertyDefinition(
      type: type ?? this.type,
      typeDef: typeDef ?? this.typeDef,
      nullable: nullable ?? this.nullable,
      name: name ?? this.name,
      optional: optional ?? this.optional,
      defaultValue: defaultValue ?? this.defaultValue,
      key: key ?? this.key,
      docString: docString ?? this.docString,
      isEnum: isEnum ?? this.isEnum,
    );
  }
}

/// Defines the actual class that should be generated
class ClassDefinition {
  final String className;
  final List<PropertyDefinition> properties;
  final List<String>? docString;
  final List<String>? imports;

  /// Each string in here will be wrapped with "assert(<s>)" inside the constructor body
  final List<String>? asserts;

  /// Only supports extension of objects that dont take any parameters in their constructor; TODO for now at least
  final String? extended;

  final bool isConst;

  /// Strings in here are inserted as is below the fields:
  /// § "bool get isError => error != null;"
  final List<String> getters;

  /// Whether to generate "copyWith" for this class
  final bool hasCopyWith;

  const ClassDefinition({
    this.imports,
    this.docString,
    this.asserts,
    required this.className,
    this.extended,
    required this.properties,
    this.getters = const [],
    this.isConst = true,
    this.hasCopyWith = false,
  });

  ClassDefinition copyWith({
    String? className,
    List<PropertyDefinition>? properties,
    List<String>? docString,
    List<String>? asserts,
    List<String>? imports,
    String? extended,
    bool removeExtended = false,
    List<String>? getters,
    bool? isConst,
    bool? hasCopyWith,
  }) {
    return ClassDefinition(
      className: className ?? this.className,
      properties: properties ?? this.properties,
      docString: docString ?? this.docString,
      imports: imports ?? this.imports,
      extended: (removeExtended) ? null : extended ?? this.extended,
      asserts: asserts ?? this.asserts,
      getters: getters ?? this.getters,
      isConst: isConst ?? this.isConst,
        hasCopyWith: hasCopyWith ?? this.hasCopyWith);
  }
}

class PoorMansGen {
  /// WIP + dirty generator for BRIDGE-able and SMALLREAD-able classes
  /// Has a lot of code duplication + failure cases, and if anyone but me reads this: DO NOT USE THIS!!!
  static String generateDataClass(ClassDefinition cd, [String? additionalCode]) {
    StringBuffer buf = StringBuffer();

    // 1) generate imports
    for (final import in cd.imports ?? []) {
      buf.writeln("import '$import';");
    }
    buf.writeln();

    // 2) generate class header
    // docstring
    for (final doc in cd.docString ?? []) {
      buf.writeln("/// $doc");
    }
    // name
    buf.writeln(
      "class ${cd.className}${ //
      (cd.extended == null ? '' : ' extends ${cd.extended!}') //
      } {",
    );

    // 3) generate fields
    for (final field in cd.properties) {
      buf.writeln();
      // docstring
      for (final doc in field.docString ?? []) {
        buf.writeln("/// $doc");
      }
      // final - type - name
      buf.writeln(
        "final ${field.typeDef ?? field.type}${ //
        (field.nullable ? '?' : '') //
        } ${field.name};",
      );
      // key
      buf.writeln('static const String k_${field.name} = "${field.key ?? field.name}";');
    }
    buf.writeln();

    // 3.2) insert getters if any
    for (final getter in cd.getters) {
      buf.writeln(getter);
    }
    buf.writeln();

    // 4) generate constructor
    // name
    if (cd.isConst) buf.write("const ");
    buf.writeln("${cd.className}(");
    if (cd.properties.isNotEmpty) {
      buf.writeln("{");
    }

    // 4.1) genearte fields
    // required - name - default
    for (final field in cd.properties) {
      if (!field.optional) {
        buf.write("required ");
      }
      buf.write("this.${field.name}");
      if (field.defaultValue != null) {
        buf.write(" = ${field.defaultValue}");
      }
      buf.writeln(",");
    }

    // 4-RE) close constructor
    if (cd.properties.isNotEmpty) {
      buf.writeln("}");
    }
    buf.write(")");
    if (cd.asserts?.isNotEmpty ?? false) {
      buf.write(":");
      buf.write(cd.asserts!.map((e) => "assert($e)").join(','));
    }
    buf.writeln(";");
    buf.writeln();

    // 5) generate decode from map
    buf.writeln("static ${cd.className} decode(Map m) => ${cd.className}(");
    // nullable - name - key - !!! DECODE obj / CAST lists + maps
    for (final field in cd.properties) {
      final _type = field.isEnum ? _TypeType._enum : parseType("${field.type}");

      switch (_type) {
        case _TypeType._string:
          buf.write("${field.name}: m[k_${field.name}] as String");
          if (field.nullable) buf.write("?");
          buf.writeln(",");
          break;
        case _TypeType._int:
          if (field.nullable) {
            buf.writeln("${field.name}: int.tryParse(m[k_${field.name}] ?? ''),");
          } else {
            buf.writeln("${field.name}: int.parse(m[k_${field.name}]),");
          }
          break;
        case _TypeType._double:
          if (field.nullable) {
            buf.writeln("${field.name}: double.tryParse(m[k_${field.name}] ?? ''),");
          } else {
            buf.writeln("${field.name}: double.parse(m[k_${field.name}]),");
          }
          break;
        case _TypeType._bool:
          if (field.nullable) {
            buf.writeln("${field.name}: (m[k_${field.name}] == null) //");
            buf.write("? null : m[k_${field.name}]");
          } else {
            buf.write("${field.name}: m[k_${field.name}]");
          }
          buf.writeln(" == '1',");
          break;
        case _TypeType._map:
          buf.write("${field.name}: ");
          if (field.nullable) {
            buf.write("m[k_${field.name}] == null ? null : ");
          }

          // assumes declarer never uses `Map`
          final components = "${field.type}".split(RegExp(r"[<,>]"));
          assert(components.length == 4, "Dont use `Map` without generic param");

          final subTypeA = parseType(components[1]);
          if (false == (subTypeA.isString || subTypeA.isObject)) {
            throw "Only String or Object keys supported for now";
          }
          final _keyDecode = (subTypeA.isString) //
              ? "k as String"
              : "${components[1]}.decode(k as String)";

          final subTypeB = parseType(components[2]);
          switch (subTypeB) {
            case _TypeType._string:
              buf.writeln("(m[k_${field.name}] as Map).map((k,v) => MapEntry($_keyDecode, v)),");
              break;
            case _TypeType._int:
              buf.writeln("(m[k_${field.name}] as Map).map((k,v) => MapEntry($_keyDecode, int.parse(v))),");
              break;
            case _TypeType._double:
              buf.writeln("(m[k_${field.name}] as Map).map((k,v) => MapEntry($_keyDecode, double.parse(v))),");
              break;
            case _TypeType._bool:
              buf.writeln("(m[k_${field.name}] as Map).map((k,v) => MapEntry($_keyDecode, v == '1')),");
              break;
            case _TypeType._map:
            case _TypeType._set:
            case _TypeType._list:
              throw "Was to lazy to implement this for now";
            case _TypeType._object:
              final _type = components[2];
              buf.writeln("(m[k_${field.name}] as Map).map((k,v) => MapEntry($_keyDecode, $_type.decode(v))),");
              break;
            // TODO cant have enum maps right now
            case _TypeType._enum:
              final _type = components[1];
              final _enum = _type.split('.').first;
              buf.writeln(
                  "(m[k_${field.name}] as Map).map((k,v) => MapEntry($_keyDecode, $_enum.values[int.parse(e)])),");
              break;
          }
          break;
        case _TypeType._list:
          buf.write("${field.name}: ");
          if (field.nullable) {
            buf.write("m[k_${field.name}] == null ? null : ");
          }

          // assumes declarer never uses `List<dynamic>` or `List`
          final components = "${field.type}".split(RegExp(r"[<>]"));
          assert(components.length > 1, "Dont use `List` without generic param");
          final subType = parseType(components[1]);
          switch (subType) {
            case _TypeType._string:
              buf.writeln("(m[k_${field.name}] as List).cast(),");
              break;
            case _TypeType._int:
              buf.writeln("(m[k_${field.name}] as List).cast<String>().map((e) => int.parse(e)).toList(),");
              break;
            case _TypeType._double:
              buf.writeln("(m[k_${field.name}] as List).cast<String>().map((e) => double.parse(e)).toList(),");
              break;
            case _TypeType._bool:
              buf.writeln("(m[k_${field.name}] as List).cast<String>().map((e) => e == '1').toList(),");
              break;
            case _TypeType._map:
            case _TypeType._set:
            case _TypeType._list:
              throw "Was to lazy to implement this for now";
            case _TypeType._object:
              final _type = components[1];
              buf.writeln("(m[k_${field.name}] as List).map((e) => $_type.decode(e)).toList(),");
              break;
            // TODO cant have enum lists right now
            case _TypeType._enum:
              final _type = components[1];
              final _enum = _type.split('.').first;
              buf.writeln("(m[k_${field.name}] as List).map((e) => $_enum.values[int.parse(e)]).toList(),");
              break;
          }
          break;
        case _TypeType._set:
          buf.write("${field.name}: ");
          if (field.nullable) {
            buf.write("m[k_${field.name}] == null ? null : ");
          }

          // assumes declarer never uses `Set<dynamic>` or `Set`
          final components = "${field.type}".split(RegExp(r"[<>]"));
          assert(components.length > 1, "Dont use `Set` without generic param");
          final subType = parseType(components[1]);
          switch (subType) {
            case _TypeType._string:
              buf.writeln("(m[k_${field.name}] as Set).cast(),");
              break;
            case _TypeType._int:
              buf.writeln("(m[k_${field.name}] as Set).cast<String>().map((e) => int.parse(e)).toSet(),");
              break;
            case _TypeType._double:
              buf.writeln("(m[k_${field.name}] as Set).cast<String>().map((e) => double.parse(e)).toSet(),");
              break;
            case _TypeType._bool:
              buf.writeln("(m[k_${field.name}] as Set).cast<String>().map((e) => e == '1').toSet(),");
              break;
            case _TypeType._map:
            case _TypeType._set:
            case _TypeType._list:
              throw "Was to lazy to implement this for now";
            case _TypeType._object:
              final _type = components[1];
              buf.writeln("(m[k_${field.name}] as Set).map((e) => $_type.decode(e)).toSet(),");
              break;
            // TODO cant have enum lists right now
            case _TypeType._enum:
              final _type = components[1];
              final _enum = _type.split('.').first;
              buf.writeln("(m[k_${field.name}] as Set).map((e) => $_enum.values[int.parse(e)]).toSet(),");
              break;
          }
          break;
        case _TypeType._object:
          // Assumes that `.decode` is available
          final _type = "${field.type}";
          buf.write("${field.name}: ");
          if (field.nullable) {
            buf.writeln("(m[k_${field.name}] == null) //");
            buf.write(" ? null : ");
          }
          buf.writeln("$_type.decode(m[k_${field.name}]),");
          break;
        case _TypeType._enum:
          final _enum = "${field.type}".split('.').first;
          buf.write("${field.name}: ");
          if (field.nullable) {
            buf.writeln("(m[k_${field.name}] == null) //");
            buf.write(" ? null : ");
          }
          buf.writeln("$_enum.values[int.parse(m[k_${field.name}]!)],");
          break;
      }
    }

    // 5-RE) close decode
    buf.writeln(");");
    buf.writeln();

    // 6) generate encode to map
    buf.writeln("Map<String,Object> encode() => {");
    // nullable - key - name !!! ENCODE obj
    for (final field in cd.properties) {
      final _type = field.isEnum ? _TypeType._enum : parseType("${field.type}");

      final excl = field.nullable ? "!" : "";

      switch (_type) {
        case _TypeType._string:
        case _TypeType._int:
        case _TypeType._double:
          if (field.nullable) {
            buf.write("if(${field.name} != null) ");
          }
          buf.writeln("k_${field.name}: ${field.name}$excl.toString(),");
          break;
        case _TypeType._bool:
          if (field.nullable) {
            buf.write("if(${field.name} != null) ");
          }
          buf.writeln("k_${field.name}: ${field.name}$excl ? '1' : '0',");
          break;
        case _TypeType._map:
          if (field.nullable) {
            buf.write("if(${field.name} != null) ");
          }
          buf.write("k_${field.name}: ");

          // assumes declarer never uses `Map`
          final components = "${field.type}".split(RegExp(r"[<,>]"));
          assert(components.length == 4, "Dont use `Map` without generic param");

          final subTypeA = parseType(components[1]);
          if (false == (subTypeA.isString || subTypeA.isObject)) {
            throw "Only String or Object keys supported for now";
          }
          final _keyEncode = (subTypeA.isString) //
              ? "k"
              : "k.encode()";

          final subTypeB = parseType(components[2]);
          switch (subTypeB) {
            case _TypeType._string:
              buf.writeln("${field.name}$excl.map((k,v) => MapEntry($_keyEncode, v')),");
              break;
            case _TypeType._int:
            case _TypeType._double:
              buf.writeln("${field.name}$excl.map((k,v) => MapEntry($_keyEncode, '\$v')),");
              break;
            case _TypeType._bool:
              buf.writeln("${field.name}$excl.map((k,v) => MapEntry($_keyEncode, v ? '1' : '0')),");
              break;
            case _TypeType._map:
            case _TypeType._set:
            case _TypeType._list:
              throw "Was to lazy to implement this for now";
            case _TypeType._object:
              buf.write("${field.name}$excl.map((k,v) => MapEntry($_keyEncode, v.encode())),");
              break;
            // TODO cant have enums in maps right now
            case _TypeType._enum:
              buf.write("${field.name}$excl.map((k,v) => MapEntry($_keyEncode, v.index.toString())),");
              break;
          }
          break;
        case _TypeType._list:
          if (field.nullable) {
            buf.write("if(${field.name} != null) ");
          }
          buf.write("k_${field.name}: ");

          // assumes declarer never uses `List<dynamic>` or `List`
          final components = "${field.type}".split(RegExp(r"[<>]"));
          assert(components.length > 1, "Dont use `List` without generic param");
          final subType = parseType(components[1]);
          switch (subType) {
            case _TypeType._string:
              buf.writeln("${field.name}$excl,");
              break;
            case _TypeType._int:
            case _TypeType._double:
              buf.writeln("${field.name}$excl.map((e) => '\$e').toList(),");
              break;
            case _TypeType._bool:
              buf.writeln("${field.name}$excl.map((e) => e ? '1' : '0').toList(),");
              break;
            case _TypeType._map:
            case _TypeType._set:
            case _TypeType._list:
              throw "Was to lazy to implement this for now";
            case _TypeType._object:
              buf.write("${field.name}$excl.map((e) => e.encode()).toList(),");
              break;
            // TODO cant have enums in lists right now
            case _TypeType._enum:
              buf.write("${field.name}$excl.map((e) => '\${v.index}').toList(),");
              break;
          }
          break;
        case _TypeType._set:
          if (field.nullable) {
            buf.write("if(${field.name} != null) ");
          }
          buf.write("k_${field.name}: ");

          // assumes declarer never uses `Set<dynamic>` or `Set`
          final components = "${field.type}".split(RegExp(r"[<>]"));
          assert(components.length > 1, "Dont use `Set` without generic param");
          final subType = parseType(components[1]);
          switch (subType) {
            case _TypeType._string:
              buf.writeln("${field.name}$excl,");
              break;
            case _TypeType._int:
            case _TypeType._double:
              buf.writeln("${field.name}$excl.map((e) => '\$e').toSet(),");
              break;
            case _TypeType._bool:
              buf.writeln("${field.name}$excl.map((e) => e ? '1' : '0').toSet(),");
              break;
            case _TypeType._map:
            case _TypeType._set:
            case _TypeType._list:
              throw "Was to lazy to implement this for now";
            case _TypeType._object:
              buf.write("${field.name}$excl.map((e) => e.encode()).toSet(),");
              break;
            // TODO cant have enums in sets right now
            case _TypeType._enum:
              buf.write("${field.name}$excl.map((e) => '\${v.index}').toSet(),");
              break;
          }
          break;
        case _TypeType._object:
          if (field.nullable) {
            buf.write("if(${field.name} != null) ");
          }
          buf.writeln("k_${field.name}: ${field.name}$excl.encode(),");
          break;
        case _TypeType._enum:
          if (field.nullable) {
            buf.write("if(${field.name} != null) ");
          }
          buf.writeln("k_${field.name}: ${field.name}$excl.index.toString(),");
          break;
      }
    }

    // 6-RE) close decode
    buf.writeln("};");
    buf.writeln();

    // 7) equals
    buf.writeln("@override");
    buf.writeln("bool operator ==(Object other) {");
    buf.writeln("if (identical(this, other)) return true;");
    if (cd.properties.any((p) => {_TypeType._list, _TypeType._map, _TypeType._set}.contains(parseType("${p.type}")))) {
      buf.writeln("final deepEquals = const DeepCollectionEquality().equals;");
    }
    buf.writeln("return other is ${cd.className}");
    for (final prop in cd.properties) {
      buf.write("&& ");
      if ({_TypeType._list, _TypeType._map, _TypeType._set}.contains(parseType("${prop.type}"))) {
        buf.writeln("deepEquals(other.${prop.name}, ${prop.name})");
      } else {
        buf.writeln("other.${prop.name} == ${prop.name}");
      }
    }
    buf.writeln(";");
    buf.writeln("}");

    // 8) hash code
    buf.writeln("@override");
    buf.writeln("int get hashCode {");
    if (cd.properties.isEmpty) {
      buf.writeln("return 0;");
    } else {
      buf.writeln("return ${cd.properties.map((p) => p.name + ".hashCode").join(' ^ ')};");
    }

    buf.writeln("}");

    // 8) generate copyWith if desired
    if (cd.hasCopyWith && cd.properties.isNotEmpty) {
      // open params
      buf.writeln("${cd.className} copyWith({");
      // write params
      for (final prop in cd.properties) {
        buf.writeln("${prop.typeDef ?? prop.type}? ${prop.name},");
        // add "bool removeMyVar = false" to reset nullables
        if (prop.nullable) {
          final firstChar = String.fromCharCode(prop.name.codeUnitAt(0));
          final rest = String.fromCharCodes(prop.name.codeUnits.skip(1));
          buf.writeln("bool remove${firstChar.toUpperCase()}${rest} = false,");
        }
      }
      // close params + open creation
      buf.writeln("}) => ${cd.className}(");
      // write params
      for (final prop in cd.properties) {
        buf.writeln("${prop.name}: ");
        // add "(removeMyVar) ? null : " to reset nullables
        String removeVar = "";
        if (prop.nullable) {
          final firstChar = String.fromCharCode(prop.name.codeUnitAt(0));
          final rest = String.fromCharCodes(prop.name.codeUnits.skip(1));
          removeVar = "(remove${firstChar.toUpperCase()}${rest}) ? null : ";
        }
        buf.writeln("$removeVar${prop.name} ?? this.${prop.name},");
      }
      // close creation
      buf.writeln(");");
    }

    // - additional code if any
    if (additionalCode != null) buf.writeln(additionalCode);

    // 2-RE) close class
    buf.writeln("}");

    return buf.toString();
  }

  // No way to check for enum, need an additional flag for that
  static _TypeType parseType(String type) {
    String _type = type.trim();
    if (_type.startsWith("List")) {
      return _TypeType._list;
    } else if (_type.startsWith("Set")) {
      return _TypeType._set;
    } else if (_type.startsWith("Map")) {
      return _TypeType._map;
    } else if (_type.startsWith("String")) {
      return _TypeType._string;
    } else if (_type.startsWith("int")) {
      return _TypeType._int;
    } else if (_type.startsWith("double")) {
      return _TypeType._double;
    } else if (_type.startsWith("bool")) {
      return _TypeType._bool;
    } else {
      return _TypeType._object;
    }
  }

  static String _applyUpdateCode(ClassDefinition base, Set<String> constantIdentifiers, Set<String> unchangable) {
    StringBuffer buf = StringBuffer();

    /**
     HandleBrnr apply({
    required HandleBrnr handle,
  }) {
    assert(handle.id == id);
    return HandleBrnr(
      schema: schema ?? handle.schema,
      id: id,
      file: file ?? handle.file,
      chunks: chunks ?? handle.chunks,
      relations: relations ?? handle.relations,
      unchanged: handle.unchanged,
    );
  }
     */
    buf.writeln("${base.className} apply(${base.className} base) {");
    for (final req in constantIdentifiers) {
      buf.writeln("assert(base.$req == $req);");
    }
    buf.writeln("return ${base.className}(");
    for (final prop in base.properties) {
      if (!unchangable.contains(prop.name)) {
        if (constantIdentifiers.contains(prop.name)) {
          buf.writeln("${prop.name}: ${prop.name},");
        } else {
          buf.writeln("${prop.name}: ${prop.name} ?? base.${prop.name},");
        }
      }
    }
    for (final name in unchangable) {
      buf.writeln("${name}: base.${name},");
    }
    buf.writeln(");}");

    return buf.toString();
  }

  static String generateUpdater({
    required ClassDefinition cd,
    required Set<String> constantIdentifiers,
    required Set<String> unchangeable,
    String namePostfix = "Update",
    List<String>? docString,
    String? extended,
  }) {
    return generateDataClass(
      cd.copyWith(
        imports: [],
        className: cd.className + namePostfix,
        removeExtended: extended == null,
        extended: extended,
        docString: docString ??
            [
              "Generated $namePostfix object for [${cd.className}]",
              "Contains the same fields, only made nullable",
              "This is useful since we might only want to change a single value",
            ],
        properties: [
          for (final prop in cd.properties)
            if (!unchangeable.contains(prop.name))
              prop.copyWith(
                nullable: !constantIdentifiers.contains(prop.name),
                optional: !constantIdentifiers.contains(prop.name),
              ),
        ],
      ),
      _applyUpdateCode(cd, constantIdentifiers, unchangeable),
    );
  }
}

enum _TypeType {
  _string,
  _int,
  _double,
  _bool,
  _map,
  _list,
  _set,
  _object,
  _enum,
}

extension _TypeTypeX on _TypeType {
  bool get isString => this == _TypeType._string;
  bool get isInt => this == _TypeType._int;
  bool get isDouble => this == _TypeType._double;
  bool get isBool => this == _TypeType._bool;
  bool get isMap => this == _TypeType._map;
  bool get isList => this == _TypeType._list;
  bool get isSet => this == _TypeType._set;
  bool get isObject => this == _TypeType._object;
  bool get isEnum => this == _TypeType._enum;
}

void main(List<String> args) {
  Map<String, int> m = {};
  m.map((k, v) => MapEntry(k, "$v"));
}
