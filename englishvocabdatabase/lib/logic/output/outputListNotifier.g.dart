// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputListNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outputListNotifierHash() =>
    r'b43cc998c0ec412ffc637bbbe086e66a2dc690a5';

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
  late final bool? inlabel;
  late final int? labelId;

  FutureOr<List<OutputListItem>> build(
    NotifierType type, {
    bool? inlabel,
    int? labelId,
  });
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
  OutputListNotifierProvider call(
    NotifierType type, {
    bool? inlabel,
    int? labelId,
  }) {
    return OutputListNotifierProvider(type, inlabel: inlabel, labelId: labelId);
  }

  @override
  OutputListNotifierProvider getProviderOverride(
    covariant OutputListNotifierProvider provider,
  ) {
    return call(
      provider.type,
      inlabel: provider.inlabel,
      labelId: provider.labelId,
    );
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
  OutputListNotifierProvider(NotifierType type, {bool? inlabel, int? labelId})
    : this._internal(
        () => OutputListNotifier()
          ..type = type
          ..inlabel = inlabel
          ..labelId = labelId,
        from: outputListNotifierProvider,
        name: r'outputListNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$outputListNotifierHash,
        dependencies: OutputListNotifierFamily._dependencies,
        allTransitiveDependencies:
            OutputListNotifierFamily._allTransitiveDependencies,
        type: type,
        inlabel: inlabel,
        labelId: labelId,
      );

  OutputListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.inlabel,
    required this.labelId,
  }) : super.internal();

  final NotifierType type;
  final bool? inlabel;
  final int? labelId;

  @override
  FutureOr<List<OutputListItem>> runNotifierBuild(
    covariant OutputListNotifier notifier,
  ) {
    return notifier.build(type, inlabel: inlabel, labelId: labelId);
  }

  @override
  Override overrideWith(OutputListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: OutputListNotifierProvider._internal(
        () => create()
          ..type = type
          ..inlabel = inlabel
          ..labelId = labelId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        inlabel: inlabel,
        labelId: labelId,
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
    return other is OutputListNotifierProvider &&
        other.type == type &&
        other.inlabel == inlabel &&
        other.labelId == labelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, inlabel.hashCode);
    hash = _SystemHash.combine(hash, labelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OutputListNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<OutputListItem>> {
  /// The parameter `type` of this provider.
  NotifierType get type;

  /// The parameter `inlabel` of this provider.
  bool? get inlabel;

  /// The parameter `labelId` of this provider.
  int? get labelId;
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
  @override
  bool? get inlabel => (origin as OutputListNotifierProvider).inlabel;
  @override
  int? get labelId => (origin as OutputListNotifierProvider).labelId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
