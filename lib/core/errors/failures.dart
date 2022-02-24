import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class NoTodosFailure extends Failure {
  @override
  List<Object> get props => [];
}

class UploadFailure extends Failure {
  @override
  List<Object?> get props => [];
}