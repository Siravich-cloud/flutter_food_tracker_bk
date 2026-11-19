// file นี้ประกอบด้วน code คำสั่งที่ทำงานกับ  supabase
// เช่น upload file , add , delete ,search ข้อมูล, และอื่นๆ ที่เกี่ยวข้องกับการเชื่อมต่อกับ database ของ supabase
// ignore_for_file: unused_local_variable, duplicate_import, depend_on_referenced_packages, unused_import

import 'package:flutter_food_tracker/models/food.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  
  final supabase = Supabase.instance.client;

  
  Future<String> uploadImageFile(XFile xfile) async {
    
    final newFileName =
        '${DateTime.now().millisecondsSinceEpoch}.${xfile.name}';


    await supabase.storage.from('food_bk').uploadBinary(
          newFileName,
          await xfile.readAsBytes(),
          fileOptions: FileOptions(contentType: xfile.mimeType),
        );
    return supabase.storage.from('food_bk').getPublicUrl(newFileName);
  }


  Future<void> insertFood(Food food) async {
    await supabase.from('food_tb').insert(food.toJson());
  }


  Future<List<Food>> getAllFoods() async {

    final runs = await supabase.from('food_tb').select('*');
    
    return runs.map((e) => Food.fromJson(e)).toList();
  }

  Future<void> deleteImageFile(String fileName) async {
    await supabase.storage.from('food_bk').remove([fileName]);
  }

  Future<void> updateFood(Food food, String id) async {
    await supabase.from('food_tb').update(food.toJson()).eq('id', id);
  }

  Future<void> deleteRun(String id) async {
    await supabase.from('food_tb').delete().eq('id', id);
  }
}
