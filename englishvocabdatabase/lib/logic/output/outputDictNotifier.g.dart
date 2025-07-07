// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputDictNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outputDictNotifierHash() =>
    r'c60a75a77bf06b584bb071dd69340be415f0334e';

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

abstract class _$OutputDictNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<String>> {
  late final String wordname;

  FutureOr<List<String>> build(String wordname);
}

/// See also [OutputDictNotifier].
@ProviderFor(OutputDictNotifier)
const outputDictNotifierProvider = OutputDictNotifierFamily();

/// See also [OutputDictNotifier].
class OutputDictNotifierFamily extends Family<AsyncValue<List<String>>> {
  /// See also [OutputDictNotifier].
  const OutputDictNotifierFamily();

  /// See also [OutputDictNotifier].
  OutputDictNotifierProvider call(String wordname) {
    return OutputDictNotifierProvider(wordname);
  }

  @override
  OutputDictNotifierProvider getProviderOverride(
    covariant OutputDictNotifierProvider provider,
  ) {
    return call(provider.wordname);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'outputDictNotifierProvider';
}

/// See also [OutputDictNotifier].
class OutputDictNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<OutputDictNotifier, List<String>> {
  /// See also [OutputDictNotifier].
  OutputDictNotifierProvider(String wordname)
    : this._internal(
        () => OutputDictNotifier()..wordname = wordname,
        from: outputDictNotifierProvider,
        name: r'outputDictNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$outputDictNotifierHash,
        dependencies: OutputDictNotifierFamily._dependencies,
        allTransitiveDependencies:
            OutputDictNotifierFamily._allTransitiveDependencies,
        wordname: wordname,
      );

  OutputDictNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.wordname,
  }) : super.internal();

  final String wordname;

  @override
  FutureOr<List<String>> runNotifierBuild(
    covariant OutputDictNotifier notifier,
  ) {
    return notifier.build(wordname);
  }

  @override
  Override overrideWith(OutputDictNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: OutputDictNotifierProvider._internal(
        () => create()..wordname = wordname,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        wordname: wordname,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<OutputDictNotifier, List<String>>
  createElement() {
    return _OutputDictNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutputDictNotifierProvider && other.wordname == wordname;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wordname.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OutputDictNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<String>> {
  /// The parameter `wordname` of this provider.
  String get wordname;
}

class _OutputDictNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          OutputDictNotifier,
          List<String>
        >
    with OutputDictNotifierRef {
  _OutputDictNotifierProviderElement(super.provider);

  @override
  String get wordname => (origin as OutputDictNotifierProvider).wordname;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
