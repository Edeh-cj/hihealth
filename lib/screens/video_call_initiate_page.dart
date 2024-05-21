import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:hihealth/providers/auth_notifier.dart';
import 'package:hihealth/utilities/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

const appId = "9b8ee428e37b47cf92ccc8d7c09a1bb6";
// const token = "007eJxTYLCLtny49cmsJ2nzFjxxPXy4L2krg7/dvO9NHTKfFi6YybJSgcEyySI11cTIItXYPMnEPDnN0ig5OdkixTzZwDLRMCnJLMtCP60hkJHh/bEuBkYoBPE5GDIyM1ITc0oyGBgAleYjkA==";
const channel = "hihealth";

class VideoCallInitiatePage extends StatefulWidget {
  const VideoCallInitiatePage({super.key});

  @override
  State<VideoCallInitiatePage> createState() => _VideoCallInitiatePageState();
}

class _VideoCallInitiatePageState extends State<VideoCallInitiatePage> {

  int? _remoteUid;
  bool _isLocalUserConnected = false;
  late RtcEngine _engine;

  @override
  void dispose() {
    _disposeAgora();
    super.dispose();
  }

  @override
  void initState() {
    initAgora(token: context.read<AuthNotifier>().videoChatToken);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 131, 0, 1),
      body: Stack(
        children: [
          _remoteView('Dr Uche Jane'), 
          Align(
            alignment: Alignment.topLeft,
            child: _localView(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(
                onTap:() => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 40,
                  child: Center(
                    child: Icon(Icons.call_end),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  

   

  Future<void> initAgora({required String token}) async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _isLocalUserConnected = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }


  Future<void> _disposeAgora() async {
    await _engine.leaveChannel();
    await _engine.release();
  }


  Widget _localView()=> Container(
    height: 100,
    width: 100,
    margin: const EdgeInsets.all(24),
    color: AppColors.borderGrey,
    child: _isLocalUserConnected? AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine, 
        canvas: const VideoCanvas(uid: 0)
      )
    )
    : null,
  );

  Widget _remoteView(String remoteUserName)=> Center(
    child: _remoteUid != null? AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine, 
        canvas: VideoCanvas(uid: _remoteUid), 
        connection: const RtcConnection(
          channelId: channel
        )
      ),
    )
    :Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 64.0),
          child: Text(
            'Calling $remoteUserName...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        const SizedBox(height: 48,),
        
      ],
    ),
  );
}