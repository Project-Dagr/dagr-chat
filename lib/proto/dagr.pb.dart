///
//  Generated code. Do not modify.
//  source: dagr.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ChatMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ChatMessage', createEmptyInstance: create)
    ..a<$core.int>(1, 'from', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'to', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(3, 'message', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ChatMessage._() : super();
  factory ChatMessage() => create();
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  ChatMessage createEmptyInstance() => create();
  static $pb.PbList<ChatMessage> createRepeated() => $pb.PbList<ChatMessage>();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get from => $_getIZ(0);
  @$pb.TagNumber(1)
  set from($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get to => $_getIZ(1);
  @$pb.TagNumber(2)
  set to($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get message => $_getN(2);
  @$pb.TagNumber(3)
  set message($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => clearField(3);
}

class DagrPacket extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DagrPacket', createEmptyInstance: create)
    ..a<$core.int>(1, 'packetNum', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(3, 'fragment', $pb.PbFieldType.OY)
    ..a<$core.int>(4, 'rxTime', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  DagrPacket._() : super();
  factory DagrPacket() => create();
  factory DagrPacket.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DagrPacket.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DagrPacket clone() => DagrPacket()..mergeFromMessage(this);
  DagrPacket copyWith(void Function(DagrPacket) updates) => super.copyWith((message) => updates(message as DagrPacket));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DagrPacket create() => DagrPacket._();
  DagrPacket createEmptyInstance() => create();
  static $pb.PbList<DagrPacket> createRepeated() => $pb.PbList<DagrPacket>();
  @$core.pragma('dart2js:noInline')
  static DagrPacket getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DagrPacket>(create);
  static DagrPacket _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get packetNum => $_getIZ(0);
  @$pb.TagNumber(1)
  set packetNum($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPacketNum() => $_has(0);
  @$pb.TagNumber(1)
  void clearPacketNum() => clearField(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get fragment => $_getN(1);
  @$pb.TagNumber(3)
  set fragment($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasFragment() => $_has(1);
  @$pb.TagNumber(3)
  void clearFragment() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get rxTime => $_getIZ(2);
  @$pb.TagNumber(4)
  set rxTime($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasRxTime() => $_has(2);
  @$pb.TagNumber(4)
  void clearRxTime() => clearField(4);
}

