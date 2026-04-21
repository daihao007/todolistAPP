import http from '@ohos.net.http';

export class HttpUtil {
  /**
   * 发起一个简单的 GET 请求
   * @param url 请求地址
   */
  static async request(url: string): Promise<string | Object> {
    let httpRequest = http.createHttp();

    try {
      let response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
        expectDataType: http.HttpDataType.STRING, // 期待返回字符串
        readTimeout: 5000, // 5秒超时
        connectTimeout: 5000
      });

      if (response.responseCode === 200) {
        // 请求成功
        return response.result;
      } else {
        return 'Error: ' + response.responseCode;
      }
    } catch (err) {
      return 'Network Error';
    } finally {
      // 必须释放资源
      httpRequest.destroy();
    }
  }
}