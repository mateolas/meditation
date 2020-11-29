import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String id;
  String nameShop;
  String nameItem;
  String priceItem;
  String currencyItem;
  String warrantyLength;
  String category;
  String image;
  String warrantyValid;
  
  Timestamp createdAt;
  Timestamp updatedAt;
  Timestamp warrantyStart;
  Timestamp warrantyEnd;
  

  Bill();

  Bill.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    nameShop = data['nameShop'];
    nameItem = data['nameItem'];
    priceItem = data['priceItem'];
    currencyItem = data['currencyItem'];
    warrantyLength = data['warrantyLength'];
    warrantyValid = data['warrantyValid'];
    category = data['category'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    warrantyStart = data['warrantyStart'];
    warrantyEnd = data['warrantyEnd'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameShop': nameShop,
      'nameItem': nameItem,
      'priceItem': priceItem,
      'currencyItem': currencyItem,
      'warrantyLength': warrantyLength,
      'warrantyValid': warrantyValid,
      'category': category,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'warrantyStart': warrantyStart,
      'warrantyEnd': warrantyEnd,
    };
  }
}