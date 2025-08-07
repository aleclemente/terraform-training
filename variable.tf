variable "string_content" {
  description = "The string content to write to the example.txt file"
  type        = string
  default     = "This is an default example text file created by Terraform."
}

variable "number_content" {
  description = "The number content to write to the example.txt file"
  type        = number
  default     = 1
}

variable "boolean_content" {
  description = "The boolean content to write to the example.txt file"
  type        = bool
  default     = true
}