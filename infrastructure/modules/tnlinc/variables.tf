variable "app_name" {
  type        = string
  description = "A prefix applied to all resourses"
  default     = "change-me"
}

variable "vpc_id" {
  type = string
}


//ALB
variable "alb_subnet_ids" {
  type        = list(string)
  description = "A list of subnets for the Application Load Balancer"
  default     = null
}

variable "controller_subnet_ids" {
  type        = list(string)
  description = "A list of subnets for application continers"
  default     = null
}
//DB
variable "db_port" {
  type    = number
  default = 5432
}

variable "db_cpu" {
  type    = number
  default = 256
}

variable "db_memory" {
  type    = number
  default = 512
}

variable "db_name" {
  type    = string
  default = "vendor"
}

variable "db_user" {
  type    = string
  default = "postgres"
}

variable "db_ip" {
  type    = string
  default = "0.0.0.0"
}

variable "db_password" {
  type    = string
  default = "postgres"
}

// Admin
variable "admin_cpu" {
  type    = number
  default = 256
}

variable "admin_memory" {
  type    = number
  default = 512
}

variable "admin_debug" {
  type    = bool
  default = true
}

variable "admin_secret_key" {
  type    = string
  default = "some-secret-string"
}

// Vendor
variable "vendor_cpu" {
  type    = number
  default = 256
}

variable "vendor_memory" {
  type    = number
  default = 512
}

variable "vendor_db_auth" {
  type    = string
  default = "vendor"
}

// CV
variable "cv_cpu" {
  type    = number
  default = 256
}

variable "cv_memory" {
  type    = number
  default = 512
}

variable "cv_debug" {
  type    = bool
  default = true
}

variable "cv_secret_key" {
  type    = string
  default = "some-secret-string"
}
variable "tags" {
  type        = map(any)
  description = "An object of tag key value pairs"
  default     = {}
}
