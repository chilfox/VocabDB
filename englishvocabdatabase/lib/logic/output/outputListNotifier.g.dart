// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputListNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outputListNotifierHash() =>
    r'd86c2f0eca7cd2d6ae1a26dc3113299bfffe7e33';

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

abstract class _$OutputListNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<OutputListItem>> {
  late final NotifierType type;

  FutureOr<List<OutputListItem>> build(NotifierType type);
}

/// See also [OutputListNotifier].
@ProviderFor(OutputListNotifier)
const outputListNotifierProvider = OutputListNotifierFamily();

/// See also [OutputListNotifier].
class OutputListNotifierFamily
    extends Family<AsyncValue<List<OutputListItem>>> {
  /// See also [OutputListNotifier].
  const OutputListNotifierFamily();

  /// See also [OutputListNotifier].
  OutputListNotifierProvider call(NotifierType type) {
    return OutputListNotifierProvider(type);
  }

  @override
  OutputListNotifierProvider getProviderOverride(
    covariant OutputListNotifierProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'outputListNotifierProvider';
}

/// See also [OutputListNotifier].
class OutputListNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          OutputListNotifier,
          List<OutputListItem>
        > {
  /// See also [OutputListNotifier].
  OutputListNotifierProvider(NotifierType type)
    : this._internal(
        () => OutputListNotifier()..type = type,
        from: outputListNotifierProvider,
        name: r'outputListNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$outputListNotifierHash,
        dependencies: OutputListNotifierFamily._dependencies,
        allTransitiveDependencies:
            OutputListNotifierFamily._allTransitiveDependencies,
        type: type,
      );

  OutputListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final NotifierType type;

  @override
  FutureOr<List<OutputListItem>> runNotifierBuild(
    covariant OutputListNotifier notifier,
  ) {
    return notifier.build(type);
  }

  @override
  Override overrideWith(OutputListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: OutputListNotifierProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    OutputListNotifier,
    List<OutputListItem>
  >
  createElement() {
    return _OutputListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutputListNotifierProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OutputListNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<OutputListItem>> {
  /// The parameter `type` of this provider.
  NotifierType get type;
}

class _OutputListNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          OutputListNotifier,
          List<OutputListItem>
        >
    with OutputListNotifierRef {
  _OutputListNotifierProviderElement(super.provider);

  @override
  NotifierType get type => (origin as OutputListNotifierProvider).type;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
