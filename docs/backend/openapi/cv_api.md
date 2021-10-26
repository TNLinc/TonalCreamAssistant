# Cv api

CV API helps you do awesome stuff. 🚀

## Tonal

You will be able to:

* **Get tone of your skin by photo**


## Version: v1

### /api/cv/v1/skin_tone

#### POST
##### Description:

Search face on the photo and determine its skin color

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| image | formData | Selfie | Yes | file |

##### Responses

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | Return color in hex code | [Color](#color) |
| 400 | Problem with file | [Error](#error) |
| 401 | Wrong file extension | [Error](#error) |

### /health

#### GET
##### Description:

Check service health

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |

##### Responses

| Code | Description |
| ---- | ----------- |

### Models


#### Color

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| color | string |  | No |

#### Error

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| error | string |  | No |