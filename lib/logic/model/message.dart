// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'contact.dart';

// final formatter = DateFormat.Hm();

// class Message extends Equatable {
//   Message({
//     @required this.contact,
//     this.text,
//     @required this.dateTime,
//     @required this.id,
//     @required this.status,
//     this.isTyping = false,
//   }) : assert(isTyping || text != null);

//   final Contact contact;
//   final String text;
//   final DateTime dateTime;
//   final MessageStatus status;
//   final String id;
//   final bool isTyping;
//   String get time => formatter.format(dateTime);

//   @override
//   List<Object> get props => [contact, text, dateTime, status];
// }

// enum MessageStatus { send, recived, read }
