import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;
  const Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errMessage});

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
          errMessage: "انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى.",
        );

      case DioExceptionType.sendTimeout:
        return const ServerFailure(
          errMessage: "انتهت مهلة إرسال الطلب، يرجى المحاولة مرة أخرى.",
        );

      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          errMessage: "انتهت مهلة استلام البيانات، يرجى المحاولة مرة أخرى.",
        );

      case DioExceptionType.badCertificate:
        return const ServerFailure(errMessage: "شهادة الاتصال غير صالحة.");

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(dioError.response);

      case DioExceptionType.cancel:
        return const ServerFailure(errMessage: "تم إلغاء الطلب.");

      case DioExceptionType.connectionError:
        return const ServerFailure(errMessage: "لا يوجد اتصال بالإنترنت.");

      case DioExceptionType.unknown:
        return const ServerFailure(
          errMessage: "حدث خطأ غير متوقع، يرجى المحاولة لاحقًا.",
        );
    }
  }

  factory ServerFailure.fromResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;

    if (statusCode == 400) {
      return const ServerFailure(
        errMessage:
            "البيانات المرسلة غير صحيحة، يرجى التحقق والمحاولة مرة أخرى.",
      );
    } else if (statusCode == 401) {
      return const ServerFailure(
        errMessage: "غير مصرح، يرجى انشاء حساب او تسجيل الدخول مرة أخرى.",
      );
    } else if (statusCode == 403) {
      return const ServerFailure(
        errMessage: "لا تملك صلاحية لتنفيذ هذه العملية.",
      );
    } else if (statusCode == 404) {
      return const ServerFailure(
        errMessage: "الطلب غير موجود، يرجى المحاولة لاحقًا.",
      );
    } else if (statusCode == 422) {
      return ServerFailure(
        errMessage:
            response?.data['message'] ??
            "حدث خطأ في التحقق من البيانات، يرجى المحاولة مرة أخرى.",
      );
    } else if (statusCode == 500) {
      return ServerFailure(
        errMessage:
            response?.data['message'] ??
            "حدث خطأ في الخادم، يرجى المحاولة لاحقًا.",
      );
    } else {
      return const ServerFailure(
        errMessage: "عذرًا، حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.",
      );
    }
  }
}
