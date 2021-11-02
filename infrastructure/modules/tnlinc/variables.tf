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

//Container
variable "container_port" {
  type    = number
  default = 80
}

variable "controller_cpu" {
  type    = number
  default = 1024
}

variable "controller_memory" {
  type    = number
  default = 2048
}

variable "tags" {
  type        = map(any)
  description = "An object of tag key value pairs"
  default     = {}
}
