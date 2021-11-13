import 'dart:math';

import 'package:PixivUserDownload/dll/native_library.g.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

class UgoiraMergeUtilOpenCV {
  static const double MAX_FPS=60;
  static const double MIN_DURATION_PEER_FRAME=1000/MAX_FPS; // 30fps
  late NativeLibrary nativeLibrary;
  UgoiraMergeUtilOpenCV(){
    var dll=ffi.DynamicLibrary.open("PixivUgoiraMerge.dll");
    nativeLibrary=NativeLibrary(dll);
  }
  Future merge(List<Frame> frames,String output)async{
    return Future((){
      var durations=frames.map((e) => e.duration).toSet();
      var timePeerFrame=_gcdMulti(durations).toDouble();// 一帧的时间
      var videoFps=1000/timePeerFrame;
      if(videoFps>MAX_FPS){
        videoFps=MAX_FPS;
        timePeerFrame=MIN_DURATION_PEER_FRAME;
      }
      nativeLibrary.init(frames[0].fileName.toNativeUtf8().cast(), videoFps, output.toNativeUtf8().cast());

      var remain=0.0;
      for(var f in frames){
        var repeatTimes=(f.duration+remain)~/timePeerFrame;
        remain+=(f.duration-repeatTimes*timePeerFrame);
        for(var i=0;i<repeatTimes;i++){
          nativeLibrary.addImage(f.fileName.toNativeUtf8().cast());
        }
      }

      if(remain>timePeerFrame/2){
        nativeLibrary.addImage(frames.last.fileName.toNativeUtf8().cast());
      }
      nativeLibrary.finish();
    });
  }

  static int _gcd(int a, int b) {
    if (a == 0 || b == 0) return 0;
    int count2 = 0;
    // 约掉2
    while (a % 2 == 0 && b % 2 == 0) {
      a ~/= 2;
      b ~/= 2;
      count2++;
    }
    while (true) {
      if (a < b) {
        // 交换ab的值
        a = a ^ b;
        b = a ^ b;
        a = a ^ b;
      } else if (a == b) {
        break;
      }
      a = a - b;
    }
    return count2 == 0 ? a : a * 2 * count2;
  }

  static int _gcdMulti(Set<int> nums) {
    if(nums.length==1)return nums.elementAt(0);
    var res = _gcd(nums.elementAt(0), nums.elementAt(1));
    for (var i = 2; i < nums.length; i++) {
      res = _gcd(res, nums.elementAt(i));
    }
    return res;
  }

  static int _lcm(int a, int b) {
    if (a == 0 || b == 0) return 0;
    if (a % b == 0 || b % a == 0) return max(a, b);
    return a * b ~/ _gcd(a, b);
  }

  static int _lcmMulti(Set<int> nums){
    if(nums.length==1)return nums.elementAt(0);
    var res = _lcm(nums.elementAt(0), nums.elementAt(1));
    for (var i = 2; i < nums.length; i++) {
      res = _lcm(res, nums.elementAt(i));
    }
    return res;
  }
}

class Frame{
  String fileName;
  int duration;
  Frame(this.fileName, this.duration);
}
