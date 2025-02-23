import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '/src/core/base/model/base_model.dart';
import '/src/core/exports/constants_exports.dart';
import '/src/core/services/network/response_parser.dart';
import '/src/core/mixins/show_bar.dart';
import '/src/core/services/network/network_exception.dart';

/// A service class that handles all network operations using Dio HTTP client.
///
/// This service provides methods for making HTTP requests (GET, POST, PUT, DELETE)
/// with built-in error handling, response parsing, and type-safe model conversion.
/// It follows a singleton pattern to ensure a single instance throughout the app lifecycle.
class NetworkService with DioMixin, ShowBar {
  /// Private constructor for singleton pattern
  NetworkService._init() {
    httpClientAdapter = IOHttpClientAdapter();
    interceptors.add(
      InterceptorsWrapper(
        // gelen hatalara göre ne yapacağını burada belirliyoruz
        onError: NetworkException.instance.onError(),
      ),
    );
  }

  /// The singleton instance of [NetworkService]
  static NetworkService? _instance;

  /// Returns the singleton instance of [NetworkService]
  static NetworkService? get instance {
    _instance ??= NetworkService._init();
    return _instance;
  }

  /// Base options for all HTTP requests
  @override
  final BaseOptions options = BaseOptions(
    baseUrl: EndPointConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  );

  /// Performs a network request to the specified endpoint.
  ///
  /// [T] is the type of model to parse the response into
  /// [R] is the return type of the response
  /// [path] is the endpoint path
  /// [type] is the HTTP request type (GET, POST, PUT, DELETE)
  /// [parseModel] is an instance of the model class to parse the response
  /// [data] is the request body data
  /// [contentType] is the content type of the request body
  /// [isPagination] indicates whether the response is paginated
  /// [baseUrl] is the base URL for the request (optional)
  /// [token] is the authentication token for the request (optional)
  /// [queryParameters] optional query parameters to append to the URL
  Future<R?> send<T extends BaseModel?, R>(
    String path, {
    required HttpTypes type,
    // eğer geriye bir cevap dönmeyecekse bu kısmı null gönderiyoruz
    required T? parseModel,
    dynamic data,
    String? contentType,
    // pagination ile gelen liste elemanları varsa
    bool? isPagination,
    // baseUrl farklı ise burada değiştiriyoruz
    String? baseUrl,
    // access token yerine farklı token kullanılabilir
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      options.baseUrl = baseUrl ?? EndPointConstants.baseUrl;
      final response = await request<dynamic>(
        path,
        data: data,
        options: Options(
          method: type.name,
          headers: {
            Headers.contentTypeHeader: contentType ?? Headers.jsonContentType,
            'Authorization': token ?? '',
          },
        ),
      );
      if (parseModel == null) {
        return null;
      }
      if (isPagination != true) {
        return responseParser<T, R>(parseModel as BaseModel<T>, response.data);
      }
      return null;
    } catch (error) {
      // Dio tarafında ya da sunucu tarafında bir hata yoksa burada oluşturuyoruz
      log('Network Service Request Error $error');
      showErrorBar(error, title: 'Error about app');
    }
    return null;
  }

  /// Refreshes the authentication token.
  ///
  /// This method is used to refresh the authentication token when it expires.
  Future<String?> refreshToken() async {
    // tokenı bir süre sonra yenileyeceğimiz zaman istek attığımız yer
    // burası oluyor
    // try {
    //   var token = await send<TokenModel, TokenModel>(
    //     EndPointConstants.refresh,
    //     type: HttpTypes.post,
    //     parseModel: TokenModel(),
    //   );
    //   if (token is TokenModel) {
    //     LocalCaching.instance.write(LocalConstants.accessToken, token.access);
    //     LocalCaching.instance.write(LocalConstants.accessToken, token.refresh);
    //     return token.access;
    //   }
    // } catch (error) {
    //   await NavigationService.instance.navigateToPageClear(
    //     path: NavigationConstants.home,
    //   );
    // }
    return null;
  }
}
