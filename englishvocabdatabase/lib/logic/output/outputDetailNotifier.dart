import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:englishvocabdatabase/database/label.dart';
import 'package:englishvocabdatabase/logic/service/wordDetail.dart';
import 'package:englishvocabdatabase/logic/service/nodefDetail.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailItem.dart';

part 'outputDetailNotifier.g.dart';

//information stored in notifier

enum DetailType{WordDetail, NodefDetail}

//notifier
@riverpod
class OutputDetailNotifier extends _$OutputDetailNotifier{
  //information
  @override
  Future<Detail> build(DetailType type, int id) async{
    if(type == DetailType.WordDetail){
      return WordDetailService.initWordDetail(id);
    }
    else{
      return NodefDetailService.initNodefDetail(id);
    }
  }

  Future<bool> modifyDetail(String column, String newInformation) async{
    if(column == 'name' || column == 'id'){
      return false;
    }
    
    _detailHelper(column, newInformation);
    return true;
  }
  
  Future<bool> addWordToLabel(int wordId, int labelId) async{
    if(type == DetailType.NodefDetail){
      return false;
    }

    List<LabelItem>? labels = await WordDetailService.addLabel(wordId, labelId);

    _updateLabel(labels);

    return true;
  }
  
  Future<bool> removeWordFromLabel(int wordId, int labelId) async{
    if(type == DetailType.NodefDetail){
      return false;
    }

    List<LabelItem>? labels = await WordDetailService.removeLabel(wordId, labelId);

    _updateLabel(labels);

    return true;
  }

  Future<void> storeDetail() async{
    Detail detail = state.value  
                  ?? await ref.read(outputDetailNotifierProvider(type, id).future);

    if(type == DetailType.NodefDetail){
      NodefDetailService.storeNodefDetail(detail, id);
    }
    else{
      WordDetailService.storeWordDetail(detail, id);
    }
    return;
  }

  void _updateLabel(List<LabelItem> labels){
    state.whenData((current) {
      Detail newDetail = current.copyWith(labels: labels);
      state = AsyncValue.data(newDetail);
    });
    return;
  }

  //help modify detail
  void _detailHelper(String column, String newInformation){
    state.whenData((current) {
      Detail newDetail;
      switch (column) {
        case 'definition':
          newDetail = current.copyWith(definition: newInformation);
          break;
        case 'parts':
          newDetail = current.copyWith(parts: newInformation);
          break;
        case 'chinese':
          if(type == DetailType.WordDetail && newInformation == ''){
            newDetail = current.copyWith();
            break;
          }
          else{
            newDetail = current.copyWith(chinese: newInformation);
            break;
          }
        case 'sentence':
          newDetail = current.copyWith(sentence: newInformation);
          break;
        default:
          return; //stop
      }

      state = AsyncValue.data(newDetail);
    });
    return;
  }
}