// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outputItem.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OutputListItem {
  String get name => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;

  /// Create a copy of OutputListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OutputListItemCopyWith<OutputListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutputListItemCopyWith<$Res> {
  factory $OutputListItemCopyWith(
    OutputListItem value,
    $Res Function(OutputListItem) then,
  ) = _$OutputListItemCopyWithImpl<$Res, OutputListItem>;
  @useResult
  $Res call({String name, int id});
}

/// @nodoc
class _$OutputListItemCopyWithImpl<$Res, $Val extends OutputListItem>
    implements $OutputListItemCopyWith<$Res> {
  _$OutputListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OutputListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? id = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OutputListItemImplCopyWith<$Res>
    implements $OutputListItemCopyWith<$Res> {
  factory _$$OutputListItemImplCopyWith(
    _$OutputListItemImpl value,
    $Res Function(_$OutputListItemImpl) then,
  ) = __$$OutputListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int id});
}

/// @nodoc
class __$$OutputListItemImplCopyWithImpl<$Res>
    extends _$OutputListItemCopyWithImpl<$Res, _$OutputListItemImpl>
    implements _$$OutputListItemImplCopyWith<$Res> {
  __$$OutputListItemImplCopyWithImpl(
    _$OutputListItemImpl _value,
    $Res Function(_$OutputListItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OutputListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? id = null}) {
    return _then(
      _$OutputListItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$OutputListItemImpl implements _OutputListItem {
  _$OutputListItemImpl({required this.name, required this.id});

  @override
  final String name;
  @override
  final int id;

  @override
  String toString() {
    return 'OutputListItem(name: $name, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputListItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, id);

  /// Create a copy of OutputListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputListItemImplCopyWith<_$OutputListItemImpl> get copyWith =>
      __$$OutputListItemImplCopyWithImpl<_$OutputListItemImpl>(
        this,
        _$identity,
      );
}

abstract class _OutputListItem implements OutputListItem {
  factory _OutputListItem({required final String name, required final int id}) =
      _$OutputListItemImpl;

  @override
  String get name;
  @override
  int get id;

  /// Create a copy of OutputListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OutputListItemImplCopyWith<_$OutputListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
