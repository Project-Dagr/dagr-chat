///
//  Generated code. Do not modify.
//  source: dagr.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum toDagr_Variant {
  message, 
  user, 
  notSet
}

class toDagr extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, toDagr_Variant> _toDagr_VariantByTag = {
    1 : toDagr_Variant.message,
    2 : toDagr_Variant.user,
    0 : toDagr_Variant.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('toDagr', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<ChatMessage>(1, 'message', subBuilder: ChatMessage.create)
    ..aOM<User>(2, 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  toDagr._() : super();
  factory toDagr() => create();
  factory toDagr.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory toDagr.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  toDagr clone() => toDagr()..mergeFromMessage(this);
  toDagr copyWith(void Function(toDagr) updates) => super.copyWith((message) => updates(message as toDagr));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static toDagr create() => toDagr._();
  toDagr createEmptyInstance() => create();
  static $pb.PbList<toDagr> createRepeated() => $pb.PbList<toDagr>();
  @$core.pragma('dart2js:noInline')
  static toDagr getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<toDagr>(create);
  static toDagr _defaultInstance;

  toDagr_Variant whichVariant() => _toDagr_VariantByTag[$_whichOneof(0)];
  void clearVariant() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);

  @$pb.TagNumber(2)
  User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(User v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);
  @$pb.TagNumber(2)
  User ensureUser() => $_ensure(1);
}

class ChatMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ChatMessage', createEmptyInstance: create)
    ..aOS(1, 'from')
    ..aOS(2, 'to')
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
  $core.String get from => $_getSZ(0);
  @$pb.TagNumber(1)
  set from($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get to => $_getSZ(1);
  @$pb.TagNumber(2)
  set to($core.String v) { $_setString(1, v); }
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

class User extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('User', createEmptyInstance: create)
    ..aOS(1, 'id')
    ..aOS(2, 'longName')
    ..aOS(3, 'shortName')
    ..a<$core.List<$core.int>>(4, 'macaddr', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  User._() : super();
  factory User() => create();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  User clone() => User()..mergeFromMessage(this);
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get longName => $_getSZ(1);
  @$pb.TagNumber(2)
  set longName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get shortName => $_getSZ(2);
  @$pb.TagNumber(3)
  set shortName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasShortName() => $_has(2);
  @$pb.TagNumber(3)
  void clearShortName() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get macaddr => $_getN(3);
  @$pb.TagNumber(4)
  set macaddr($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMacaddr() => $_has(3);
  @$pb.TagNumber(4)
  void clearMacaddr() => clearField(4);
}

