import http from '@ohos.net.http'

interface HttpHeaderMap {
  'Content-Type': string
  Authorization?: string
}

export class HttpUtil {
  static async request(url: string): Promise<string> {
    const httpRequest = http.createHttp()

    try {
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
        expectDataType: http.HttpDataType.STRING,
        readTimeout: 5000,
        connectTimeout: 5000
      })

      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error(`HTTP ${response.responseCode}`)
      }

      return String(response.result)
    } finally {
      httpRequest.destroy()
    }
  }

  static async postJson(url: string, data: Object, authorization?: string): Promise<string> {
    const httpRequest = http.createHttp()
    const requestHeaders: HttpHeaderMap = {
      'Content-Type': 'application/json'
    }
    if (authorization !== undefined && authorization.length > 0) {
      requestHeaders.Authorization = authorization
    }

    try {
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.POST,
        header: requestHeaders,
        extraData: JSON.stringify(data),
        expectDataType: http.HttpDataType.STRING,
        readTimeout: 60000,
        connectTimeout: 60000
      })

      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error(`HTTP ${response.responseCode}: ${String(response.result)}`)
      }

      return String(response.result)
    } finally {
      httpRequest.destroy()
    }
  }
}
