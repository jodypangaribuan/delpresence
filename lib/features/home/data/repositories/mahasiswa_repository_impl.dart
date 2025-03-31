import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/mahasiswa_remote_datasource.dart';
import '../models/mahasiswa_model.dart';
import '../../domain/repositories/mahasiswa_repository.dart';

class MahasiswaRepositoryImpl implements MahasiswaRepository {
  final MahasiswaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MahasiswaRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MahasiswaComplete>> getMahasiswaData(
      int userId) async {
    if (await networkInfo.isConnected) {
      try {
        final mahasiswaData = await remoteDataSource.getMahasiswaData(userId);
        return Right(mahasiswaData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
