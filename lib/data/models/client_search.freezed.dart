// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientSearchMatch {

 String get source; String get snippet;/// Custom field label — present only when [source] == 'customField'.
 String? get fieldLabel;
/// Create a copy of ClientSearchMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSearchMatchCopyWith<ClientSearchMatch> get copyWith => _$ClientSearchMatchCopyWithImpl<ClientSearchMatch>(this as ClientSearchMatch, _$identity);

  /// Serializes this ClientSearchMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSearchMatch&&(identical(other.source, source) || other.source == source)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.fieldLabel, fieldLabel) || other.fieldLabel == fieldLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,snippet,fieldLabel);

@override
String toString() {
  return 'ClientSearchMatch(source: $source, snippet: $snippet, fieldLabel: $fieldLabel)';
}


}

/// @nodoc
abstract mixin class $ClientSearchMatchCopyWith<$Res>  {
  factory $ClientSearchMatchCopyWith(ClientSearchMatch value, $Res Function(ClientSearchMatch) _then) = _$ClientSearchMatchCopyWithImpl;
@useResult
$Res call({
 String source, String snippet, String? fieldLabel
});




}
/// @nodoc
class _$ClientSearchMatchCopyWithImpl<$Res>
    implements $ClientSearchMatchCopyWith<$Res> {
  _$ClientSearchMatchCopyWithImpl(this._self, this._then);

  final ClientSearchMatch _self;
  final $Res Function(ClientSearchMatch) _then;

/// Create a copy of ClientSearchMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? snippet = null,Object? fieldLabel = freezed,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,fieldLabel: freezed == fieldLabel ? _self.fieldLabel : fieldLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientSearchMatch].
extension ClientSearchMatchPatterns on ClientSearchMatch {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSearchMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSearchMatch() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSearchMatch value)  $default,){
final _that = this;
switch (_that) {
case _ClientSearchMatch():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSearchMatch value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSearchMatch() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  String snippet,  String? fieldLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSearchMatch() when $default != null:
return $default(_that.source,_that.snippet,_that.fieldLabel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  String snippet,  String? fieldLabel)  $default,) {final _that = this;
switch (_that) {
case _ClientSearchMatch():
return $default(_that.source,_that.snippet,_that.fieldLabel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  String snippet,  String? fieldLabel)?  $default,) {final _that = this;
switch (_that) {
case _ClientSearchMatch() when $default != null:
return $default(_that.source,_that.snippet,_that.fieldLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientSearchMatch implements ClientSearchMatch {
  const _ClientSearchMatch({required this.source, required this.snippet, this.fieldLabel});
  factory _ClientSearchMatch.fromJson(Map<String, dynamic> json) => _$ClientSearchMatchFromJson(json);

@override final  String source;
@override final  String snippet;
/// Custom field label — present only when [source] == 'customField'.
@override final  String? fieldLabel;

/// Create a copy of ClientSearchMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSearchMatchCopyWith<_ClientSearchMatch> get copyWith => __$ClientSearchMatchCopyWithImpl<_ClientSearchMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientSearchMatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSearchMatch&&(identical(other.source, source) || other.source == source)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.fieldLabel, fieldLabel) || other.fieldLabel == fieldLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,snippet,fieldLabel);

@override
String toString() {
  return 'ClientSearchMatch(source: $source, snippet: $snippet, fieldLabel: $fieldLabel)';
}


}

/// @nodoc
abstract mixin class _$ClientSearchMatchCopyWith<$Res> implements $ClientSearchMatchCopyWith<$Res> {
  factory _$ClientSearchMatchCopyWith(_ClientSearchMatch value, $Res Function(_ClientSearchMatch) _then) = __$ClientSearchMatchCopyWithImpl;
@override @useResult
$Res call({
 String source, String snippet, String? fieldLabel
});




}
/// @nodoc
class __$ClientSearchMatchCopyWithImpl<$Res>
    implements _$ClientSearchMatchCopyWith<$Res> {
  __$ClientSearchMatchCopyWithImpl(this._self, this._then);

  final _ClientSearchMatch _self;
  final $Res Function(_ClientSearchMatch) _then;

/// Create a copy of ClientSearchMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? snippet = null,Object? fieldLabel = freezed,}) {
  return _then(_ClientSearchMatch(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,fieldLabel: freezed == fieldLabel ? _self.fieldLabel : fieldLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ClientSearchResult {

 Client get client; int get score; List<ClientSearchMatch> get matches;
/// Create a copy of ClientSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSearchResultCopyWith<ClientSearchResult> get copyWith => _$ClientSearchResultCopyWithImpl<ClientSearchResult>(this as ClientSearchResult, _$identity);

  /// Serializes this ClientSearchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSearchResult&&(identical(other.client, client) || other.client == client)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.matches, matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,client,score,const DeepCollectionEquality().hash(matches));

@override
String toString() {
  return 'ClientSearchResult(client: $client, score: $score, matches: $matches)';
}


}

/// @nodoc
abstract mixin class $ClientSearchResultCopyWith<$Res>  {
  factory $ClientSearchResultCopyWith(ClientSearchResult value, $Res Function(ClientSearchResult) _then) = _$ClientSearchResultCopyWithImpl;
@useResult
$Res call({
 Client client, int score, List<ClientSearchMatch> matches
});


$ClientCopyWith<$Res> get client;

}
/// @nodoc
class _$ClientSearchResultCopyWithImpl<$Res>
    implements $ClientSearchResultCopyWith<$Res> {
  _$ClientSearchResultCopyWithImpl(this._self, this._then);

  final ClientSearchResult _self;
  final $Res Function(ClientSearchResult) _then;

/// Create a copy of ClientSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? client = null,Object? score = null,Object? matches = null,}) {
  return _then(_self.copyWith(
client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<ClientSearchMatch>,
  ));
}
/// Create a copy of ClientSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res> get client {
  
  return $ClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClientSearchResult].
extension ClientSearchResultPatterns on ClientSearchResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSearchResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _ClientSearchResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSearchResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Client client,  int score,  List<ClientSearchMatch> matches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSearchResult() when $default != null:
return $default(_that.client,_that.score,_that.matches);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Client client,  int score,  List<ClientSearchMatch> matches)  $default,) {final _that = this;
switch (_that) {
case _ClientSearchResult():
return $default(_that.client,_that.score,_that.matches);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Client client,  int score,  List<ClientSearchMatch> matches)?  $default,) {final _that = this;
switch (_that) {
case _ClientSearchResult() when $default != null:
return $default(_that.client,_that.score,_that.matches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientSearchResult implements ClientSearchResult {
  const _ClientSearchResult({required this.client, required this.score, required final  List<ClientSearchMatch> matches}): _matches = matches;
  factory _ClientSearchResult.fromJson(Map<String, dynamic> json) => _$ClientSearchResultFromJson(json);

@override final  Client client;
@override final  int score;
 final  List<ClientSearchMatch> _matches;
@override List<ClientSearchMatch> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}


/// Create a copy of ClientSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSearchResultCopyWith<_ClientSearchResult> get copyWith => __$ClientSearchResultCopyWithImpl<_ClientSearchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientSearchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSearchResult&&(identical(other.client, client) || other.client == client)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other._matches, _matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,client,score,const DeepCollectionEquality().hash(_matches));

@override
String toString() {
  return 'ClientSearchResult(client: $client, score: $score, matches: $matches)';
}


}

/// @nodoc
abstract mixin class _$ClientSearchResultCopyWith<$Res> implements $ClientSearchResultCopyWith<$Res> {
  factory _$ClientSearchResultCopyWith(_ClientSearchResult value, $Res Function(_ClientSearchResult) _then) = __$ClientSearchResultCopyWithImpl;
@override @useResult
$Res call({
 Client client, int score, List<ClientSearchMatch> matches
});


@override $ClientCopyWith<$Res> get client;

}
/// @nodoc
class __$ClientSearchResultCopyWithImpl<$Res>
    implements _$ClientSearchResultCopyWith<$Res> {
  __$ClientSearchResultCopyWithImpl(this._self, this._then);

  final _ClientSearchResult _self;
  final $Res Function(_ClientSearchResult) _then;

/// Create a copy of ClientSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? client = null,Object? score = null,Object? matches = null,}) {
  return _then(_ClientSearchResult(
client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<ClientSearchMatch>,
  ));
}

/// Create a copy of ClientSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res> get client {
  
  return $ClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}

// dart format on
