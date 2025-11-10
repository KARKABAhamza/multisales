import { ConnectorConfig, DataConnect, OperationOptions, ExecuteOperationResponse } from 'firebase-admin/data-connect';

export const connectorConfig: ConnectorConfig;

export type TimestampString = string;
export type UUIDString = string;
export type Int64String = string;
export type DateString = string;


export interface CreateUserData {
  user_insert: {
    id: UUIDString;
  };
}

export interface GetReviewsForProductData {
  reviews: ({
    id: UUIDString;
    comment?: string | null;
    rating: number;
  } & Review_Key)[];
}

export interface GetReviewsForProductVariables {
  productId: UUIDString;
}

export interface ListProductsData {
  products: ({
    id: UUIDString;
    name: string;
    price: number;
    description: string;
  } & Product_Key)[];
}

export interface OrderItem_Key {
  orderId: UUIDString;
  productId: UUIDString;
  __typename?: 'OrderItem_Key';
}

export interface Order_Key {
  id: UUIDString;
  __typename?: 'Order_Key';
}

export interface Product_Key {
  id: UUIDString;
  __typename?: 'Product_Key';
}

export interface Review_Key {
  id: UUIDString;
  __typename?: 'Review_Key';
}

export interface UpdateProductData {
  product_update?: {
    id: UUIDString;
  };
}

export interface UpdateProductVariables {
  id: UUIDString;
  name?: string | null;
  price?: number | null;
}

export interface User_Key {
  id: UUIDString;
  __typename?: 'User_Key';
}

/** Generated Node Admin SDK operation action function for the 'CreateUser' Mutation. Allow users to execute without passing in DataConnect. */
export function createUser(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateUserData>>;
/** Generated Node Admin SDK operation action function for the 'CreateUser' Mutation. Allow users to pass in custom DataConnect instances. */
export function createUser(options?: OperationOptions): Promise<ExecuteOperationResponse<CreateUserData>>;

/** Generated Node Admin SDK operation action function for the 'ListProducts' Query. Allow users to execute without passing in DataConnect. */
export function listProducts(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<ListProductsData>>;
/** Generated Node Admin SDK operation action function for the 'ListProducts' Query. Allow users to pass in custom DataConnect instances. */
export function listProducts(options?: OperationOptions): Promise<ExecuteOperationResponse<ListProductsData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateProduct' Mutation. Allow users to execute without passing in DataConnect. */
export function updateProduct(dc: DataConnect, vars: UpdateProductVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateProductData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateProduct' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateProduct(vars: UpdateProductVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateProductData>>;

/** Generated Node Admin SDK operation action function for the 'GetReviewsForProduct' Query. Allow users to execute without passing in DataConnect. */
export function getReviewsForProduct(dc: DataConnect, vars: GetReviewsForProductVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetReviewsForProductData>>;
/** Generated Node Admin SDK operation action function for the 'GetReviewsForProduct' Query. Allow users to pass in custom DataConnect instances. */
export function getReviewsForProduct(vars: GetReviewsForProductVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetReviewsForProductData>>;

