part of 'generated.dart';

class GetReviewsForProductVariablesBuilder {
  String productId;

  final FirebaseDataConnect _dataConnect;
  GetReviewsForProductVariablesBuilder(this._dataConnect, {required  this.productId,});
  Deserializer<GetReviewsForProductData> dataDeserializer = (dynamic json)  => GetReviewsForProductData.fromJson(jsonDecode(json));
  Serializer<GetReviewsForProductVariables> varsSerializer = (GetReviewsForProductVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetReviewsForProductData, GetReviewsForProductVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetReviewsForProductData, GetReviewsForProductVariables> ref() {
    GetReviewsForProductVariables vars= GetReviewsForProductVariables(productId: productId,);
    return _dataConnect.query("GetReviewsForProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetReviewsForProductReviews {
  final String id;
  final String? comment;
  final int rating;
  GetReviewsForProductReviews.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  comment = json['comment'] == null ? null : nativeFromJson<String>(json['comment']),
  rating = nativeFromJson<int>(json['rating']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReviewsForProductReviews otherTyped = other as GetReviewsForProductReviews;
    return id == otherTyped.id && 
    comment == otherTyped.comment && 
    rating == otherTyped.rating;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, comment.hashCode, rating.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (comment != null) {
      json['comment'] = nativeToJson<String?>(comment);
    }
    json['rating'] = nativeToJson<int>(rating);
    return json;
  }

  const GetReviewsForProductReviews({
    required this.id,
    this.comment,
    required this.rating,
  });
}

@immutable
class GetReviewsForProductData {
  final List<GetReviewsForProductReviews> reviews;
  GetReviewsForProductData.fromJson(dynamic json):
  
  reviews = (json['reviews'] as List<dynamic>)
        .map((e) => GetReviewsForProductReviews.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReviewsForProductData otherTyped = other as GetReviewsForProductData;
    return reviews == otherTyped.reviews;
    
  }
  @override
  int get hashCode => reviews.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['reviews'] = reviews.map((e) => e.toJson()).toList();
    return json;
  }

  const GetReviewsForProductData({
    required this.reviews,
  });
}

@immutable
class GetReviewsForProductVariables {
  final String productId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetReviewsForProductVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReviewsForProductVariables otherTyped = other as GetReviewsForProductVariables;
    return productId == otherTyped.productId;
    
  }
  @override
  int get hashCode => productId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    return json;
  }

  const GetReviewsForProductVariables({
    required this.productId,
  });
}

