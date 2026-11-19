// ignore_for_file: must_be_immutable, use_build_context_synchronously, sort_child_properties_last

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_food_tracker/models/food.dart';
import 'package:flutter_food_tracker/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDeleteUI extends StatefulWidget {
  
  Food? foodDetail;

  UpdateDeleteUI({super.key, this.foodDetail});

  @override
  State<UpdateDeleteUI> createState() => _UpdateDeleteUIState();
}

class _UpdateDeleteUIState extends State<UpdateDeleteUI> {

  String foodMeal = 'เช้า'; // ค่าเริ่มต้น
  final List<String> mealList = ['เช้า', 'กลางวัน', 'เย็น', 'ว่าง'];
  
  String imageURL = "";

  TextEditingController FoodNameCtrl = TextEditingController();
  TextEditingController FoodDateCtrl = TextEditingController();
  TextEditingController FoodPersonCtrl = TextEditingController();
  TextEditingController FoodPriceCtrl = TextEditingController();

  Future<void> uploadAndSaveData() async {
   
    imageURL = widget.foodDetail!.foodImageUrl!;

    if (imageFile != null) {
      imageURL = await SupabaseService().uploadImageFile(imageFile!);
    }
    
    if (FoodNameCtrl.text.isEmpty ||
        FoodPersonCtrl.text.isEmpty ||
        FoodPriceCtrl.text.isEmpty ||
        FoodDateCtrl.text.isEmpty ||
        foodMeal.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '⚠ กรุณากรอกข้อมูลให้ครบถ้วน',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 244, 67, 54),
        ),
      );
      return;
    }
    Food foodData = Food(
      foodName: FoodNameCtrl.text,
      foodDate: FoodDateCtrl.text,
      foodMeal: foodMeal,
      foodPrice: FoodPriceCtrl.text,
      foodPerson: FoodPersonCtrl.text,
      foodImageUrl: imageURL,
    );
    //ส่ง data to table
    await SupabaseService().updateFood(foodData, widget.foodDetail!.id!);
    //แจ้งเตือน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ' ✅ อับโหลดและบันทึกแก้ไขข้อมูลเรียบร้อย',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
      ),
    );
   
    Navigator.pop(context);
  }

  @override
  void initState() {
    FoodNameCtrl.text = widget.foodDetail!.foodName!;
    FoodPersonCtrl.text = widget.foodDetail!.foodPerson!;
    FoodDateCtrl.text = widget.foodDetail!.foodDate!;
    FoodPriceCtrl.text = widget.foodDetail!.foodPrice!;
    foodMeal = widget.foodDetail!.foodMeal!;
    super.initState();
  }

  Uint8List? imageBytes;
  XFile? imageFile; 
  Future<void> selectImageFromCamera() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);

    if (imageFile != null) {
      final byte = await imageFile!.readAsBytes();
      setState(() {
        imageBytes = byte;
      });
    }
  }

  Future<void> selectImageFromGallery() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    //ตรวจสอบว่าได้เลือกมั้ย
    if (imageFile != null) {
      final byte = await imageFile!.readAsBytes();
      setState(() {
        imageBytes = byte;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
        title: Text(
          'FOOD TRACKER (แก้ไข/ลบ)',
          style: TextStyle(
            color: Colors.white,
        
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            top: 50,
            bottom: 50,
            left: 45,
            right: 45,
          ),
          child: Center(
            child: Column(
              children: [
             
                imageFile != null
                    ? InkWell(
                        onTap: () {
                          selectImageFromGallery();
                        },
                        child: Image.memory(
                          imageBytes!,
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.width * 0.45,
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.foodDetail!.foodImageUrl == ''
                        ? InkWell(
                            onTap: () {
                              selectImageFromGallery();
                            },
                            child: Icon(
                              Icons.camera_enhance_outlined,
                              size: MediaQuery.of(context).size.width * 0.45,
                              color: Colors.grey,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              selectImageFromGallery();
                            },
                            child: Image.network(
                              widget.foodDetail!.foodImageUrl!,
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.width * 0.45,
                              fit: BoxFit.cover,
                            ),
                          ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินอะไร',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น KFC, Pizza ...',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินมื้อไหน',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: mealList.map((m) {
                    final selected = foodMeal == m;
                    return ChoiceChip(
                      label: Text(m),
                      selected: selected,
                      showCheckmark: false,
                      
                      selectedColor: const Color.fromARGB(255, 76, 175, 80),
                      backgroundColor: const Color.fromARGB(255, 158, 158, 158),
               
                      shape: const StadiumBorder(),
                      side: BorderSide.none,
              
                      elevation: 3,
                      shadowColor: Colors.black45,
                 
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 5),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onSelected: (_) {
                        setState(() {
                          foodMeal = m;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปเท่าไหร่',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodPriceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 100, 200, 300...',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินกี่คน',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 1 , 2 , 3 ...',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินวันไหน',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodDateCtrl,
                  readOnly: true, // กันไม่ให้คีย์บอร์ดเด้งขึ้นมา
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 2020-01-31',
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        FoodDateCtrl.text =
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () {
                    uploadAndSaveData();
                  },
                  child: Text(
                    'บันทึกแก้ไขข้อมูล',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () async {
                    
                    if (widget.foodDetail!.foodImageUrl != " ") {
                 
                      String imageName = widget.foodDetail!.foodImageUrl!
                          .split('/')
                          .last; 
                      await SupabaseService().deleteImageFile(imageName);
                    }
               
                    await SupabaseService().deleteRun(widget.foodDetail!.id!);
                 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(' ✅ ลบข้อมูลเรียบร้อยแล้ว'),
                        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ลบข้อมูล',
                    style: TextStyle(
                      color: Colors.white,
                
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
