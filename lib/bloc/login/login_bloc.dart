import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:store_user/data/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final loginRepository = LoginRepository();
  LoginBloc() : super(LoginInitial()) {
    on<LoginWithEmailAndPassword>((event, emit) async {
      emit(LoginLoading());
      try {
        await loginRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccess());
      } catch (e, s) {
        debugPrintStack(label: e.toString(), stackTrace: s);
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
