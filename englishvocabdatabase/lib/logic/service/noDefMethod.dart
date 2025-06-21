//handle the manipulation on no definition word

import '../../database/nodef.dart';

mixin NodefMethod{
  //Add Word button in homepage
  Future<bool> addNodef(String name) async{
    final db = NoDefDB();
    bool success = await db.addNoDef(name).catchError((e){
      print('insertLabel error: $e');
    });

    return success;
  }


}