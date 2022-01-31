import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Contact extends Equatable {
  Contact({
    @required this.image,
    @required this.name,
    @required this.id,
    @required this.hasWallet,
  });

  final String? image;
  final String? name;
  final String? id;
  final bool? hasWallet;

  Contact copyWith({required String name}) => Contact(
        name: name,
        id: id,
        hasWallet: hasWallet,
        image: image,
      );
  @override
  List<Object?> get props => [image, id, name];
}
