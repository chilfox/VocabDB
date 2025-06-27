import 'package:freezed_annotation/freezed_annotation.dart';

part 'outputItem.freezed.dart';

@freezed
class OutputListItem with _$OutputListItem{
  factory OutputListItem({
    required String name,
    required int id,
    String? chinese
  }) = _OutputListItem;
}
