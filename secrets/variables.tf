# variable "user_information" {
#   type = object({
#     pass    = string
#     address = string
#   })
#   sensitive = true
# }

variable "pass" {
  description = "this is rds password"
  type        = string
  sensitive = true
}

variable "address" {
  description = "this is my address"
  type        = string
  sensitive = true
}
