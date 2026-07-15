// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Template {

 String get id; String get name; String get category; String get language; String get status; String get parameterFormat; String get body; List<String>? get variables; String? get headerFormat; String? get headerText; String? get headerS3Key;/// Fresh presigned URL for the header media. Only present on
/// `GET /templates/:id` (the list endpoint doesn't presign).
 String? get headerMediaUrl; String? get footerText; List<dynamic>? get buttons; Object? get bodyExample; Object? get headerExample;/// Carousel cards — non-null marks a marketing carousel template whose
/// [body] is the shared bubble message shown above the cards.
 List<TemplateCarouselCard>? get carouselCards;
/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateCopyWith<Template> get copyWith => _$TemplateCopyWithImpl<Template>(this as Template, _$identity);

  /// Serializes this Template to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Template&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.language, language) || other.language == language)&&(identical(other.status, status) || other.status == status)&&(identical(other.parameterFormat, parameterFormat) || other.parameterFormat == parameterFormat)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.headerFormat, headerFormat) || other.headerFormat == headerFormat)&&(identical(other.headerText, headerText) || other.headerText == headerText)&&(identical(other.headerS3Key, headerS3Key) || other.headerS3Key == headerS3Key)&&(identical(other.headerMediaUrl, headerMediaUrl) || other.headerMediaUrl == headerMediaUrl)&&(identical(other.footerText, footerText) || other.footerText == footerText)&&const DeepCollectionEquality().equals(other.buttons, buttons)&&const DeepCollectionEquality().equals(other.bodyExample, bodyExample)&&const DeepCollectionEquality().equals(other.headerExample, headerExample)&&const DeepCollectionEquality().equals(other.carouselCards, carouselCards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,language,status,parameterFormat,body,const DeepCollectionEquality().hash(variables),headerFormat,headerText,headerS3Key,headerMediaUrl,footerText,const DeepCollectionEquality().hash(buttons),const DeepCollectionEquality().hash(bodyExample),const DeepCollectionEquality().hash(headerExample),const DeepCollectionEquality().hash(carouselCards));

@override
String toString() {
  return 'Template(id: $id, name: $name, category: $category, language: $language, status: $status, parameterFormat: $parameterFormat, body: $body, variables: $variables, headerFormat: $headerFormat, headerText: $headerText, headerS3Key: $headerS3Key, headerMediaUrl: $headerMediaUrl, footerText: $footerText, buttons: $buttons, bodyExample: $bodyExample, headerExample: $headerExample, carouselCards: $carouselCards)';
}


}

/// @nodoc
abstract mixin class $TemplateCopyWith<$Res>  {
  factory $TemplateCopyWith(Template value, $Res Function(Template) _then) = _$TemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, String language, String status, String parameterFormat, String body, List<String>? variables, String? headerFormat, String? headerText, String? headerS3Key, String? headerMediaUrl, String? footerText, List<dynamic>? buttons, Object? bodyExample, Object? headerExample, List<TemplateCarouselCard>? carouselCards
});




}
/// @nodoc
class _$TemplateCopyWithImpl<$Res>
    implements $TemplateCopyWith<$Res> {
  _$TemplateCopyWithImpl(this._self, this._then);

  final Template _self;
  final $Res Function(Template) _then;

/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? language = null,Object? status = null,Object? parameterFormat = null,Object? body = null,Object? variables = freezed,Object? headerFormat = freezed,Object? headerText = freezed,Object? headerS3Key = freezed,Object? headerMediaUrl = freezed,Object? footerText = freezed,Object? buttons = freezed,Object? bodyExample = freezed,Object? headerExample = freezed,Object? carouselCards = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,parameterFormat: null == parameterFormat ? _self.parameterFormat : parameterFormat // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,variables: freezed == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as List<String>?,headerFormat: freezed == headerFormat ? _self.headerFormat : headerFormat // ignore: cast_nullable_to_non_nullable
as String?,headerText: freezed == headerText ? _self.headerText : headerText // ignore: cast_nullable_to_non_nullable
as String?,headerS3Key: freezed == headerS3Key ? _self.headerS3Key : headerS3Key // ignore: cast_nullable_to_non_nullable
as String?,headerMediaUrl: freezed == headerMediaUrl ? _self.headerMediaUrl : headerMediaUrl // ignore: cast_nullable_to_non_nullable
as String?,footerText: freezed == footerText ? _self.footerText : footerText // ignore: cast_nullable_to_non_nullable
as String?,buttons: freezed == buttons ? _self.buttons : buttons // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,bodyExample: freezed == bodyExample ? _self.bodyExample : bodyExample ,headerExample: freezed == headerExample ? _self.headerExample : headerExample ,carouselCards: freezed == carouselCards ? _self.carouselCards : carouselCards // ignore: cast_nullable_to_non_nullable
as List<TemplateCarouselCard>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Template].
extension TemplatePatterns on Template {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Template value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Template() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Template value)  $default,){
final _that = this;
switch (_that) {
case _Template():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Template value)?  $default,){
final _that = this;
switch (_that) {
case _Template() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String language,  String status,  String parameterFormat,  String body,  List<String>? variables,  String? headerFormat,  String? headerText,  String? headerS3Key,  String? headerMediaUrl,  String? footerText,  List<dynamic>? buttons,  Object? bodyExample,  Object? headerExample,  List<TemplateCarouselCard>? carouselCards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.language,_that.status,_that.parameterFormat,_that.body,_that.variables,_that.headerFormat,_that.headerText,_that.headerS3Key,_that.headerMediaUrl,_that.footerText,_that.buttons,_that.bodyExample,_that.headerExample,_that.carouselCards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String language,  String status,  String parameterFormat,  String body,  List<String>? variables,  String? headerFormat,  String? headerText,  String? headerS3Key,  String? headerMediaUrl,  String? footerText,  List<dynamic>? buttons,  Object? bodyExample,  Object? headerExample,  List<TemplateCarouselCard>? carouselCards)  $default,) {final _that = this;
switch (_that) {
case _Template():
return $default(_that.id,_that.name,_that.category,_that.language,_that.status,_that.parameterFormat,_that.body,_that.variables,_that.headerFormat,_that.headerText,_that.headerS3Key,_that.headerMediaUrl,_that.footerText,_that.buttons,_that.bodyExample,_that.headerExample,_that.carouselCards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  String language,  String status,  String parameterFormat,  String body,  List<String>? variables,  String? headerFormat,  String? headerText,  String? headerS3Key,  String? headerMediaUrl,  String? footerText,  List<dynamic>? buttons,  Object? bodyExample,  Object? headerExample,  List<TemplateCarouselCard>? carouselCards)?  $default,) {final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.language,_that.status,_that.parameterFormat,_that.body,_that.variables,_that.headerFormat,_that.headerText,_that.headerS3Key,_that.headerMediaUrl,_that.footerText,_that.buttons,_that.bodyExample,_that.headerExample,_that.carouselCards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Template extends Template {
  const _Template({required this.id, this.name = '', this.category = '', this.language = '', this.status = '', this.parameterFormat = 'positional', this.body = '', final  List<String>? variables, this.headerFormat, this.headerText, this.headerS3Key, this.headerMediaUrl, this.footerText, final  List<dynamic>? buttons, this.bodyExample, this.headerExample, final  List<TemplateCarouselCard>? carouselCards}): _variables = variables,_buttons = buttons,_carouselCards = carouselCards,super._();
  factory _Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String category;
@override@JsonKey() final  String language;
@override@JsonKey() final  String status;
@override@JsonKey() final  String parameterFormat;
@override@JsonKey() final  String body;
 final  List<String>? _variables;
@override List<String>? get variables {
  final value = _variables;
  if (value == null) return null;
  if (_variables is EqualUnmodifiableListView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? headerFormat;
@override final  String? headerText;
@override final  String? headerS3Key;
/// Fresh presigned URL for the header media. Only present on
/// `GET /templates/:id` (the list endpoint doesn't presign).
@override final  String? headerMediaUrl;
@override final  String? footerText;
 final  List<dynamic>? _buttons;
@override List<dynamic>? get buttons {
  final value = _buttons;
  if (value == null) return null;
  if (_buttons is EqualUnmodifiableListView) return _buttons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  Object? bodyExample;
@override final  Object? headerExample;
/// Carousel cards — non-null marks a marketing carousel template whose
/// [body] is the shared bubble message shown above the cards.
 final  List<TemplateCarouselCard>? _carouselCards;
/// Carousel cards — non-null marks a marketing carousel template whose
/// [body] is the shared bubble message shown above the cards.
@override List<TemplateCarouselCard>? get carouselCards {
  final value = _carouselCards;
  if (value == null) return null;
  if (_carouselCards is EqualUnmodifiableListView) return _carouselCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateCopyWith<_Template> get copyWith => __$TemplateCopyWithImpl<_Template>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Template&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.language, language) || other.language == language)&&(identical(other.status, status) || other.status == status)&&(identical(other.parameterFormat, parameterFormat) || other.parameterFormat == parameterFormat)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.headerFormat, headerFormat) || other.headerFormat == headerFormat)&&(identical(other.headerText, headerText) || other.headerText == headerText)&&(identical(other.headerS3Key, headerS3Key) || other.headerS3Key == headerS3Key)&&(identical(other.headerMediaUrl, headerMediaUrl) || other.headerMediaUrl == headerMediaUrl)&&(identical(other.footerText, footerText) || other.footerText == footerText)&&const DeepCollectionEquality().equals(other._buttons, _buttons)&&const DeepCollectionEquality().equals(other.bodyExample, bodyExample)&&const DeepCollectionEquality().equals(other.headerExample, headerExample)&&const DeepCollectionEquality().equals(other._carouselCards, _carouselCards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,language,status,parameterFormat,body,const DeepCollectionEquality().hash(_variables),headerFormat,headerText,headerS3Key,headerMediaUrl,footerText,const DeepCollectionEquality().hash(_buttons),const DeepCollectionEquality().hash(bodyExample),const DeepCollectionEquality().hash(headerExample),const DeepCollectionEquality().hash(_carouselCards));

@override
String toString() {
  return 'Template(id: $id, name: $name, category: $category, language: $language, status: $status, parameterFormat: $parameterFormat, body: $body, variables: $variables, headerFormat: $headerFormat, headerText: $headerText, headerS3Key: $headerS3Key, headerMediaUrl: $headerMediaUrl, footerText: $footerText, buttons: $buttons, bodyExample: $bodyExample, headerExample: $headerExample, carouselCards: $carouselCards)';
}


}

/// @nodoc
abstract mixin class _$TemplateCopyWith<$Res> implements $TemplateCopyWith<$Res> {
  factory _$TemplateCopyWith(_Template value, $Res Function(_Template) _then) = __$TemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, String language, String status, String parameterFormat, String body, List<String>? variables, String? headerFormat, String? headerText, String? headerS3Key, String? headerMediaUrl, String? footerText, List<dynamic>? buttons, Object? bodyExample, Object? headerExample, List<TemplateCarouselCard>? carouselCards
});




}
/// @nodoc
class __$TemplateCopyWithImpl<$Res>
    implements _$TemplateCopyWith<$Res> {
  __$TemplateCopyWithImpl(this._self, this._then);

  final _Template _self;
  final $Res Function(_Template) _then;

/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? language = null,Object? status = null,Object? parameterFormat = null,Object? body = null,Object? variables = freezed,Object? headerFormat = freezed,Object? headerText = freezed,Object? headerS3Key = freezed,Object? headerMediaUrl = freezed,Object? footerText = freezed,Object? buttons = freezed,Object? bodyExample = freezed,Object? headerExample = freezed,Object? carouselCards = freezed,}) {
  return _then(_Template(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,parameterFormat: null == parameterFormat ? _self.parameterFormat : parameterFormat // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,variables: freezed == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as List<String>?,headerFormat: freezed == headerFormat ? _self.headerFormat : headerFormat // ignore: cast_nullable_to_non_nullable
as String?,headerText: freezed == headerText ? _self.headerText : headerText // ignore: cast_nullable_to_non_nullable
as String?,headerS3Key: freezed == headerS3Key ? _self.headerS3Key : headerS3Key // ignore: cast_nullable_to_non_nullable
as String?,headerMediaUrl: freezed == headerMediaUrl ? _self.headerMediaUrl : headerMediaUrl // ignore: cast_nullable_to_non_nullable
as String?,footerText: freezed == footerText ? _self.footerText : footerText // ignore: cast_nullable_to_non_nullable
as String?,buttons: freezed == buttons ? _self._buttons : buttons // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,bodyExample: freezed == bodyExample ? _self.bodyExample : bodyExample ,headerExample: freezed == headerExample ? _self.headerExample : headerExample ,carouselCards: freezed == carouselCards ? _self._carouselCards : carouselCards // ignore: cast_nullable_to_non_nullable
as List<TemplateCarouselCard>?,
  ));
}


}


/// @nodoc
mixin _$TemplateCarouselCard {

 String get headerFormat; String get body; Object? get bodyExample; List<dynamic>? get buttons;/// Fresh presigned URL for the card media (from `GET /templates/:id`).
 String? get mediaUrl;
/// Create a copy of TemplateCarouselCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateCarouselCardCopyWith<TemplateCarouselCard> get copyWith => _$TemplateCarouselCardCopyWithImpl<TemplateCarouselCard>(this as TemplateCarouselCard, _$identity);

  /// Serializes this TemplateCarouselCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateCarouselCard&&(identical(other.headerFormat, headerFormat) || other.headerFormat == headerFormat)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.bodyExample, bodyExample)&&const DeepCollectionEquality().equals(other.buttons, buttons)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,headerFormat,body,const DeepCollectionEquality().hash(bodyExample),const DeepCollectionEquality().hash(buttons),mediaUrl);

@override
String toString() {
  return 'TemplateCarouselCard(headerFormat: $headerFormat, body: $body, bodyExample: $bodyExample, buttons: $buttons, mediaUrl: $mediaUrl)';
}


}

/// @nodoc
abstract mixin class $TemplateCarouselCardCopyWith<$Res>  {
  factory $TemplateCarouselCardCopyWith(TemplateCarouselCard value, $Res Function(TemplateCarouselCard) _then) = _$TemplateCarouselCardCopyWithImpl;
@useResult
$Res call({
 String headerFormat, String body, Object? bodyExample, List<dynamic>? buttons, String? mediaUrl
});




}
/// @nodoc
class _$TemplateCarouselCardCopyWithImpl<$Res>
    implements $TemplateCarouselCardCopyWith<$Res> {
  _$TemplateCarouselCardCopyWithImpl(this._self, this._then);

  final TemplateCarouselCard _self;
  final $Res Function(TemplateCarouselCard) _then;

/// Create a copy of TemplateCarouselCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headerFormat = null,Object? body = null,Object? bodyExample = freezed,Object? buttons = freezed,Object? mediaUrl = freezed,}) {
  return _then(_self.copyWith(
headerFormat: null == headerFormat ? _self.headerFormat : headerFormat // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,bodyExample: freezed == bodyExample ? _self.bodyExample : bodyExample ,buttons: freezed == buttons ? _self.buttons : buttons // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateCarouselCard].
extension TemplateCarouselCardPatterns on TemplateCarouselCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateCarouselCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateCarouselCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateCarouselCard value)  $default,){
final _that = this;
switch (_that) {
case _TemplateCarouselCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateCarouselCard value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateCarouselCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String headerFormat,  String body,  Object? bodyExample,  List<dynamic>? buttons,  String? mediaUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateCarouselCard() when $default != null:
return $default(_that.headerFormat,_that.body,_that.bodyExample,_that.buttons,_that.mediaUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String headerFormat,  String body,  Object? bodyExample,  List<dynamic>? buttons,  String? mediaUrl)  $default,) {final _that = this;
switch (_that) {
case _TemplateCarouselCard():
return $default(_that.headerFormat,_that.body,_that.bodyExample,_that.buttons,_that.mediaUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String headerFormat,  String body,  Object? bodyExample,  List<dynamic>? buttons,  String? mediaUrl)?  $default,) {final _that = this;
switch (_that) {
case _TemplateCarouselCard() when $default != null:
return $default(_that.headerFormat,_that.body,_that.bodyExample,_that.buttons,_that.mediaUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateCarouselCard extends TemplateCarouselCard {
  const _TemplateCarouselCard({this.headerFormat = 'IMAGE', this.body = '', this.bodyExample, final  List<dynamic>? buttons, this.mediaUrl}): _buttons = buttons,super._();
  factory _TemplateCarouselCard.fromJson(Map<String, dynamic> json) => _$TemplateCarouselCardFromJson(json);

@override@JsonKey() final  String headerFormat;
@override@JsonKey() final  String body;
@override final  Object? bodyExample;
 final  List<dynamic>? _buttons;
@override List<dynamic>? get buttons {
  final value = _buttons;
  if (value == null) return null;
  if (_buttons is EqualUnmodifiableListView) return _buttons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Fresh presigned URL for the card media (from `GET /templates/:id`).
@override final  String? mediaUrl;

/// Create a copy of TemplateCarouselCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateCarouselCardCopyWith<_TemplateCarouselCard> get copyWith => __$TemplateCarouselCardCopyWithImpl<_TemplateCarouselCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateCarouselCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateCarouselCard&&(identical(other.headerFormat, headerFormat) || other.headerFormat == headerFormat)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.bodyExample, bodyExample)&&const DeepCollectionEquality().equals(other._buttons, _buttons)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,headerFormat,body,const DeepCollectionEquality().hash(bodyExample),const DeepCollectionEquality().hash(_buttons),mediaUrl);

@override
String toString() {
  return 'TemplateCarouselCard(headerFormat: $headerFormat, body: $body, bodyExample: $bodyExample, buttons: $buttons, mediaUrl: $mediaUrl)';
}


}

/// @nodoc
abstract mixin class _$TemplateCarouselCardCopyWith<$Res> implements $TemplateCarouselCardCopyWith<$Res> {
  factory _$TemplateCarouselCardCopyWith(_TemplateCarouselCard value, $Res Function(_TemplateCarouselCard) _then) = __$TemplateCarouselCardCopyWithImpl;
@override @useResult
$Res call({
 String headerFormat, String body, Object? bodyExample, List<dynamic>? buttons, String? mediaUrl
});




}
/// @nodoc
class __$TemplateCarouselCardCopyWithImpl<$Res>
    implements _$TemplateCarouselCardCopyWith<$Res> {
  __$TemplateCarouselCardCopyWithImpl(this._self, this._then);

  final _TemplateCarouselCard _self;
  final $Res Function(_TemplateCarouselCard) _then;

/// Create a copy of TemplateCarouselCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headerFormat = null,Object? body = null,Object? bodyExample = freezed,Object? buttons = freezed,Object? mediaUrl = freezed,}) {
  return _then(_TemplateCarouselCard(
headerFormat: null == headerFormat ? _self.headerFormat : headerFormat // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,bodyExample: freezed == bodyExample ? _self.bodyExample : bodyExample ,buttons: freezed == buttons ? _self._buttons : buttons // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
