# Basic Usage

Always prioritize using a supported framework over using the generated SDK
directly. Supported frameworks simplify the developer experience and help ensure
best practices are followed.





## Advanced Usage
If a user is not using a supported framework, they can use the generated SDK directly.

Here's an example of how to use it with the first 5 operations:

```js
import { createUser, listProducts, updateProduct, getReviewsForProduct } from '@dataconnect/generated';


// Operation CreateUser: 
const { data } = await CreateUser(dataConnect);

// Operation ListProducts: 
const { data } = await ListProducts(dataConnect);

// Operation UpdateProduct:  For variables, look at type UpdateProductVars in ../index.d.ts
const { data } = await UpdateProduct(dataConnect, updateProductVars);

// Operation GetReviewsForProduct:  For variables, look at type GetReviewsForProductVars in ../index.d.ts
const { data } = await GetReviewsForProduct(dataConnect, getReviewsForProductVars);


```