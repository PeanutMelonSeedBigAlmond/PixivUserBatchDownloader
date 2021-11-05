import 'dart:io';

class ProxyHelper {
  static Future<bool> _isSystemProxyEnable() async {
    var regQuery=await _queryRegistry(
        "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings",
        "ProxyEnable"
    );
    var regex=RegExp("ProxyEnable\\s+REG_DWORD\\s+0x(\\d*)");
    var match=regex.firstMatch(regQuery);
    var res=int.parse(match?.group(1) as String,radix: 16);
    return res==1;
  }

  static Future<String> _getProxyServer()async{
    var regQuery=await _queryRegistry(
        "HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings",
        "ProxyServer"
    );
    var regex=RegExp("\\s([\\w\\.]+:\\d+)");
    var match=regex.firstMatch(regQuery);
    return match?.group(1) as String;
  }

  static Future<String> getSystemProxy()async{
    try{
      var systemProxyEnable=await _isSystemProxyEnable();
      if(!systemProxyEnable) return "DIRECT";
      var proxyServer=await _getProxyServer();
      return "PROXY $proxyServer";
    } on Exception{
      return "DIRECT";
    }
  }

  static Future<String> _queryRegistry(String key,String valueEntry) async {
    var process = await Process.run(
        "reg",
        [
          "query",
          key,
          "/v",
          valueEntry
        ],
        runInShell: true);
    var exitCode =process.exitCode;
    if (exitCode != 0) {
      throw _RegQueryFailedException();
    }
    return process.stdout;
  }
}

class _RegQueryFailedException implements Exception {
  final String msg;

  _RegQueryFailedException({this.msg = "查询注册表失败"});
}
