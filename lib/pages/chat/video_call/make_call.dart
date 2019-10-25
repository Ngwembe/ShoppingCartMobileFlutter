import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:flutter_webrtc/webrtc.dart';

class MakeCallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MakeCallState();
  }
}

class _MakeCallState extends State<MakeCallPage> {
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  MediaStream _localStream;
  bool _inCalling = false;
  @override
  void initState() {
    super.initState();
    initRenderers();
   //  _makeCall();
    // TODO make offer and render video
    //_createPeerConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('P2P Call'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: null,
            tooltip: 'setup',
          ),
        ],
      ),
      body: new OrientationBuilder(
        builder: (context, orientation) {
          return new Center(
            child: new Container(
              margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: RTCVideoView(_localRenderer),
              decoration: new BoxDecoration(color: Colors.black54),
            ),
          );
        },
      ),
       floatingActionButton: new FloatingActionButton(
        onPressed: _inCalling ? _hangUp : _makeCall,
        tooltip: _inCalling ? 'Hangup' : 'Call',
        child: new Icon(_inCalling ? Icons.call_end : Icons.phone),
      ),
    );
  }

  _hangUp() async {
    try {
      await _localStream.dispose();
      _localRenderer.srcObject = null;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _inCalling = false;
    });
  }

  initRenderers() async {
    await _localRenderer.initialize();
    //await _remoteRenderer.initialize();
    
  }

  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    MediaStream stream = await navigator.getUserMedia(mediaConstraints);
    return stream;
  }

  _makeCall() async {
    _localStream = await createStream();
    _localRenderer.srcObject = _localStream;
    _createPeerConnection();
  }

  _createPeerConnection() async {
    RTCPeerConnection pc = await createPeerConnection(_iceServers, _config);

    await pc.addStream(_localStream);
    //pc.createOffer()
    pc.onIceCandidate = (candidate) {
      _send('candidate', {
        'to': "", //set to userId here
        'candidate': {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
      });
    };

    pc.onIceConnectionState = (state) {};

    pc.onAddStream = (stream) {
      //if (this.onAddRemoteStream != null) this.onAddRemoteStream(stream);
      //_remoteStreams.add(stream);
    };

    pc.onRemoveStream = (stream) {
      // if (this.onRemoveRemoteStream != null) this.onRemoveRemoteStream(stream);
      // _remoteStreams.removeWhere((it) {
      // return (it.id == stream.id);
      // });
    };

    pc.onDataChannel = (channel) {
      // _addDataChannel(id, channel);
    };

    return pc;
  }

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      /*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
       */
    ]
  };
  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  _send(event, data) {
    data['type'] = event;
    JsonEncoder encoder = new JsonEncoder();
    //TODO implement send to server functionality
    //if (_socket != null) _socket.add(encoder.convert(data));
    //print('send: ' + encoder.convert(data));
  }
}
