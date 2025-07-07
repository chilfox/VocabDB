// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputDetailNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outputDetailNotifierHash() =>
    r'1d2553eac2150f74214266b71b04e8e7a4698633';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$OutputDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Detail> {
  late final DetailType type;
  late final int id;

  FutureOr<Detail> build(DetailType type, int id);
}

/// See also [OutputDetailNotifier].
@ProviderFor(OutputDetailNotifier)
const outputDetailNotifierProvider = OutputDetailNotifierFamily();

/// See also [OutputDetailNotifier].
class OutputDetailNotifierFamily extends Family<AsyncValue<Detail>> {
  /// See also [OutputDetailNotifier].
  const OutputDetailNotifierFamily();

  /// See also [OutputDetailNotifier].
  OutputDetailNotifierProvider call(DetailType type, int id) {
    return OutputDetailNotifierProvider(type, id);
  }

  @override
  OutputDetailNotifierProvider getProviderOverride(
    covariant OutputDetailNotifierProvider provider,
  ) {
    return call(provider.type, provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'outputDetailNotifierProvider';
}

/// See also [OutputDetailNotifier].
class OutputDetailNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OutputDetailNotifier, Detail> {
  /// See also [OutputDetailNotifier].
  OutputDetailNotifierProvider(DetailType type, int id)
    : this._internal(
        () => OutputDetailNotifier()
          ..type = type
          ..id = id,
        from: outputDetailNotifierProvider,
        name: r'outputDetailNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$outputDetailNotifierHash,
        dependencies: OutputDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            OutputDetailNotifierFamily._allTransitiveDependencies,
        type: type,
        id: id,
      );

  OutputDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.id,
  }) : super.internal();

  final DetailType type;
  final int id;

  @override
  FutureOr<Detail> runNotifierBuild(covariant OutputDetailNotifier notifier) {
    return notifier.build(type, id);
  }

  @override
  Override overrideWith(OutputDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: OutputDetailNotifierProvider._internal(
        () => create()
          ..type = type
          ..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<OutputDetailNotifier, Detail>
  createElement() {
    return _OutputDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutputDetailNotifierProvider &&
        other.type == type &&
        other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OutputDetailNotifierRef on AutoDisposeAsyncNotifierProviderRef<Detail> {
  /// The parameter `type` of this provider.
  DetailType get type;

  /// The parameter `id` of this provider.
  int get id;
}

class _OutputDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<OutputDetailNotifier, Detail>
    with OutputDetailNotifierRef {
  _OutputDetailNotifierProviderElement(super.provider);

  @override
  DetailType get type => (origin as OutputDetailNotifierProvider).type;
  @override
  int get id => (origin as OutputDetailNotifierProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
