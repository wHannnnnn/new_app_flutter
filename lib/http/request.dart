import 'package:dio/dio.dart';
import 'api.dart';
/*
 * 封装 restful 请求
 *
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */
class DioHttp {
  /// global dio object
  static Dio dio;

  /// default options
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;
  static const String TOKEN = "1373a739fd8599909738511f41831623";

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
          connectTimeout: 150000,
          receiveTimeout: 150000,
          responseType: ResponseType.json,
          validateStatus: (status) {
            // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
            return true;
          },
          baseUrl: api.baseUrl,
          headers: httpHeaders);

      dio = new Dio(options);
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }

  ///Get请求
  static void getHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    ///定义请求参数
    parameters = parameters ?? {};
    //参数处理
    parameters.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    try {
      Response response;
      Dio dio = createInstance();
      response = await dio.get(url, queryParameters: parameters);
      var responseData = response.data;
      if (responseData['code'] == 0 || responseData['code'] == 700) {
        if (onSuccess != null) {
          onSuccess(responseData);
        }
      } else {
        throw Exception('erroMsg:${responseData['msg']}');
      }
    } catch (e) {
      print('请求出错：' + e.toString());
      onError(e.toString());
    }
  }

  ///Post请求
  static void postHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    ///定义请求参数
    parameters = parameters ?? {};
    //参数处理
    parameters.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    try {
      Response response;
      Dio dio = createInstance();
      response = await dio.post(url, queryParameters: parameters);
      var responseData = response.data;
      if (responseData['code'] == 0 || responseData['code'] == 700) {
        if (onSuccess != null) {
          onSuccess(responseData);
        }
      } else {
        throw Exception('erroMsg:${responseData['msg']}');
      }
    } catch (e) {
      print('请求出错：' + e.toString());
      onError(e.toString());
    }
  }

  /// request Get、Post 请求
  //url 请求链接
  //parameters 请求参数
  //method 请求方式
  //onSuccess 成功回调
  //onError 失败回调
  static void httpRequest<T>(String url,
      {parameters,
      method,
      Function(T t) onSuccess,
      Function(String error) onError}) async {
    parameters = parameters ?? {};
    method = method ?? 'GET';
    parameters = new Map<String, dynamic>.from(parameters);
    parameters.addAll({'token': DioHttp.TOKEN});
    if (method == DioHttp.GET) {
      getHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    } else if (method == DioHttp.POST) {
      postHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    }
  }
}

/// 自定义Header
Map<String, dynamic> httpHeaders = {
  // 'Accept': 'application/json,*/*',
  'Content-Type': 'application/x-www-form-urlencoded',
};
