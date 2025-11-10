import { ConnectorConfig, DataConnect, QueryRef, QueryPromise, MutationRef, MutationPromise } from 'firebase/data-connect';

export const connectorConfig: ConnectorConfig;

export type TimestampString = string;
export type UUIDString = string;
export type Int64String = string;
export type DateString = string;




export interface CreateUserData {
  user_insert: User_Key;
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
  product_update?: Product_Key | null;
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

interface CreateUserRef {
  /* Allow users to create refs without passing in DataConnect */
  (): MutationRef<CreateUserData, undefined>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect): MutationRef<CreateUserData, undefined>;
  operationName: string;
}
export const createUserRef: CreateUserRef;

export function createUser(): MutationPromise<CreateUserData, undefined>;
export function createUser(dc: DataConnect): MutationPromise<CreateUserData, undefined>;

interface ListProductsRef {
  /* Allow users to create refs without passing in DataConnect */
  (): QueryRef<ListProductsData, undefined>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect): QueryRef<ListProductsData, undefined>;
  operationName: string;
}
export const listProductsRef: ListProductsRef;

export function listProducts(): QueryPromise<ListProductsData, undefined>;
export function listProducts(dc: DataConnect): QueryPromise<ListProductsData, undefined>;

interface UpdateProductRef {
  /* Allow users to create refs without passing in DataConnect */
  (vars: UpdateProductVariables): MutationRef<UpdateProductData, UpdateProductVariables>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect, vars: UpdateProductVariables): MutationRef<UpdateProductData, UpdateProductVariables>;
  operationName: string;
}
export const updateProductRef: UpdateProductRef;

export function updateProduct(vars: UpdateProductVariables): MutationPromise<UpdateProductData, UpdateProductVariables>;
export function updateProduct(dc: DataConnect, vars: UpdateProductVariables): MutationPromise<UpdateProductData, UpdateProductVariables>;

interface GetReviewsForProductRef {
  /* Allow users to create refs without passing in DataConnect */
  (vars: GetReviewsForProductVariables): QueryRef<GetReviewsForProductData, GetReviewsForProductVariables>;
  /* Allow users to pass in custom DataConnect instances */
  (dc: DataConnect, vars: GetReviewsForProductVariables): QueryRef<GetReviewsForProductData, GetReviewsForProductVariables>;
  operationName: string;
}
export const getReviewsForProductRef: GetReviewsForProductRef;

export function getReviewsForProduct(vars: GetReviewsForProductVariables): QueryPromise<GetReviewsForProductData, GetReviewsForProductVariables>;
export function getReviewsForProduct(dc: DataConnect, vars: GetReviewsForProductVariables): QueryPromise<GetReviewsForProductData, GetReviewsForProductVariables>;

