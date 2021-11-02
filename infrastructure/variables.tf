variable "app_name" {
  type    = string
  default = "tnlinc"
}

variable "tags" {
  type        = map(any)
  description = "An object of tag key-value pairs"
  default     = {}
}
