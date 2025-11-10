library;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'list_products.dart';

part 'update_product.dart';

part 'get_reviews_for_product.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser () {
    return CreateUserVariablesBuilder(dataConnect, );
  }
  
  
  ListProductsVariablesBuilder listProducts () {
    return ListProductsVariablesBuilder(dataConnect, );
  }
  
  
  UpdateProductVariablesBuilder updateProduct ({required String id, }) {
    return UpdateProductVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetReviewsForProductVariablesBuilder getReviewsForProduct ({required String productId, }) {
    return GetReviewsForProductVariablesBuilder(dataConnect, productId: productId,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'multisalesapp',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
