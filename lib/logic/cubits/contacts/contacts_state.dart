part of 'contacts_cubit.dart';

abstract class ContactsState extends AuthDependentState {
  const ContactsState();
}

class Loaded extends ContactsState {
  const Loaded(this.users);

  final List<User> users;

  factory Loaded.empty() => Loaded([]);

  @override
  List<Object> get props => users;
}

class Loading extends ContactsState {
  @override
  List<Object> get props => [];
}
