import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:store_user/data/repositories/register_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final registerRepository = RegisterRepository();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterWithEmailAndPassword>((event, emit) async {
      emit(RegisterLoading());
      try {
        await registerRepository.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(RegisterSuccess());
      } catch (e, s) {
        debugPrintStack(label: e.toString(), stackTrace: s);
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }
}
