# Vendor

Vendor API helps you do awesome stuff. рџљЂ

## Vendor

You will be able to:

* **Read vendor by id**
* **Read all vendors**

## Products

You will be able to:

* **Read product by id**
* **Read all products**
* **Get product by color**



## Version: 0.0.1

**Contact information:**  
Ilya Kochankov  
ilyakochankov@yandex.ru  

### /v1/vendors/{item_id}

#### GET
##### Summary:

Get Vendor

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| item_id | path |  | Yes | string (uuid) |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 422 | Validation Error |

### /v1/vendors

#### GET
##### Summary:

Get All Vendors

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |

### /v1/products/{item_id}

#### GET
##### Summary:

Get Vendor

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| item_id | path |  | Yes | string (uuid) |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 422 | Validation Error |

### /v1/products

#### GET
##### Summary:

Get All Vendors

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| color | query |  | No | string (color) |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 422 | Validation Error |

### Models


#### HTTPValidationError

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| detail | [ [ValidationError](#validationerror) ] |  | No |

#### ProductRead

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| name | string |  | Yes |
| type | [ProductType](#producttype) |  | Yes |
| color | string (color) |  | Yes |
| vendor_id | string (uuid) |  | Yes |
| id | string (uuid) |  | No |

#### ProductType

An enumeration.

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| ProductType |  | An enumeration. |  |

#### ProductWithVendor

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| name | string |  | Yes |
| type | [ProductType](#producttype) |  | Yes |
| color | string (color) |  | Yes |
| vendor_id | string (uuid) |  | Yes |
| id | string (uuid) |  | No |
| vendor | [VendorRead](#vendorread) |  | Yes |

#### ValidationError

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| loc | [ string ] |  | Yes |
| msg | string |  | Yes |
| type | string |  | Yes |

#### VendorRead

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| name | string |  | Yes |
| url | string |  | Yes |
| id | string (uuid) |  | No |

#### VendorWithProducts

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| name | string |  | Yes |
| url | string |  | Yes |
| id | string (uuid) |  | No |
| products | [ [ProductRead](#productread) ] |  | No |