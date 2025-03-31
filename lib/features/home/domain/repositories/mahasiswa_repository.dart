import 'package:delpresence/core/error/failures.dart';
import 'package:delpresence/features/home/data/models/mahasiswa_model.dart';
import 'package:dartz/dartz.dart';

abstract class MahasiswaRepository {
  Future<Either<Failure, MahasiswaComplete>> getMahasiswaData(int userId);
}
