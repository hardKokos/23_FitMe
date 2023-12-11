import 'package:equatable/equatable.dart';
import 'package:shopping_cart/shopping_cart.dart';

class shoppingItemModel extends ItemModel with EquatableMixin {
  final String name;
  final String urlPhoto;
  String extraInfo;

  shoppingItemModel({
    required this.name,
    required this.urlPhoto,
    this.extraInfo = '',

    required super.id, 

    required super.price,

    super.quantity = 1,
  });
  
  @override
  List<Object?> get props => [ name, urlPhoto, extraInfo]; 
}