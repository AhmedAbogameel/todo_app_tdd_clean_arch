import 'package:dartz/dartz.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/features/home/domain/repositories/repository.dart';

class UploadUnSendTodos {
  final HomeRepository repository;

  UploadUnSendTodos({required this.repository});

  Future<Either<Failure, void>> call() => repository.uploadUnSendTodos();
}