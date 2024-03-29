// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Custom {
  String? get id => throw _privateConstructorUsedError; // Custom名
  String? get name => throw _privateConstructorUsedError; // 総額
  Price? get totalPrice => throw _privateConstructorUsedError; // 各パーツ
  List<PcParts>? get parts => throw _privateConstructorUsedError; // 保存日
  String? get date => throw _privateConstructorUsedError; // 互換性のリスト
  List<PartsCompatibility>? get compatibilities =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CustomCopyWith<Custom> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomCopyWith<$Res> {
  factory $CustomCopyWith(Custom value, $Res Function(Custom) then) =
      _$CustomCopyWithImpl<$Res, Custom>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      Price? totalPrice,
      List<PcParts>? parts,
      String? date,
      List<PartsCompatibility>? compatibilities});
}

/// @nodoc
class _$CustomCopyWithImpl<$Res, $Val extends Custom>
    implements $CustomCopyWith<$Res> {
  _$CustomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? totalPrice = freezed,
    Object? parts = freezed,
    Object? date = freezed,
    Object? compatibilities = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as Price?,
      parts: freezed == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PcParts>?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      compatibilities: freezed == compatibilities
          ? _value.compatibilities
          : compatibilities // ignore: cast_nullable_to_non_nullable
              as List<PartsCompatibility>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomImplCopyWith<$Res> implements $CustomCopyWith<$Res> {
  factory _$$CustomImplCopyWith(
          _$CustomImpl value, $Res Function(_$CustomImpl) then) =
      __$$CustomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      Price? totalPrice,
      List<PcParts>? parts,
      String? date,
      List<PartsCompatibility>? compatibilities});
}

/// @nodoc
class __$$CustomImplCopyWithImpl<$Res>
    extends _$CustomCopyWithImpl<$Res, _$CustomImpl>
    implements _$$CustomImplCopyWith<$Res> {
  __$$CustomImplCopyWithImpl(
      _$CustomImpl _value, $Res Function(_$CustomImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? totalPrice = freezed,
    Object? parts = freezed,
    Object? date = freezed,
    Object? compatibilities = freezed,
  }) {
    return _then(_$CustomImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as Price?,
      parts: freezed == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PcParts>?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      compatibilities: freezed == compatibilities
          ? _value._compatibilities
          : compatibilities // ignore: cast_nullable_to_non_nullable
              as List<PartsCompatibility>?,
    ));
  }
}

/// @nodoc

class _$CustomImpl implements _Custom {
  const _$CustomImpl(
      {this.id,
      this.name,
      this.totalPrice,
      final List<PcParts>? parts,
      this.date,
      final List<PartsCompatibility>? compatibilities})
      : _parts = parts,
        _compatibilities = compatibilities;

  @override
  final String? id;
// Custom名
  @override
  final String? name;
// 総額
  @override
  final Price? totalPrice;
// 各パーツ
  final List<PcParts>? _parts;
// 各パーツ
  @override
  List<PcParts>? get parts {
    final value = _parts;
    if (value == null) return null;
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 保存日
  @override
  final String? date;
// 互換性のリスト
  final List<PartsCompatibility>? _compatibilities;
// 互換性のリスト
  @override
  List<PartsCompatibility>? get compatibilities {
    final value = _compatibilities;
    if (value == null) return null;
    if (_compatibilities is EqualUnmodifiableListView) return _compatibilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Custom(id: $id, name: $name, totalPrice: $totalPrice, parts: $parts, date: $date, compatibilities: $compatibilities)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            const DeepCollectionEquality().equals(other._parts, _parts) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._compatibilities, _compatibilities));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      totalPrice,
      const DeepCollectionEquality().hash(_parts),
      date,
      const DeepCollectionEquality().hash(_compatibilities));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomImplCopyWith<_$CustomImpl> get copyWith =>
      __$$CustomImplCopyWithImpl<_$CustomImpl>(this, _$identity);
}

abstract class _Custom implements Custom {
  const factory _Custom(
      {final String? id,
      final String? name,
      final Price? totalPrice,
      final List<PcParts>? parts,
      final String? date,
      final List<PartsCompatibility>? compatibilities}) = _$CustomImpl;

  @override
  String? get id;
  @override // Custom名
  String? get name;
  @override // 総額
  Price? get totalPrice;
  @override // 各パーツ
  List<PcParts>? get parts;
  @override // 保存日
  String? get date;
  @override // 互換性のリスト
  List<PartsCompatibility>? get compatibilities;
  @override
  @JsonKey(ignore: true)
  _$$CustomImplCopyWith<_$CustomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
