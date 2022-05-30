import 'package:client_tcp/base/base_notifier.dart';
import 'package:dio/dio.dart';

mixin RestService on BaseNotifier{
  static const supervisorPath = 'http://127.0.0.1:10000';

  Future<String?> getBroker() async{
    try{
      final dio = Dio();
      final response = await dio.get('$supervisorPath/broker');
      if(response.statusCode == 200) return response.data;
      showMessage(response.data, messageType: MessageTypeEnum.error);
    }on DioError catch (e){
      showMessage(e.response?.data, messageType: MessageTypeEnum.error);
    }catch(e){
      showMessage(e.toString(), messageType: MessageTypeEnum.error);
    }
    return null;
  }
}