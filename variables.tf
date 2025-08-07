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

variable "list_content" {
  description = "The list content to write to the example.txt file"
  type        = list(string)
  default     = ["apple", "banana", "apple"]
}

variable "set_content" {
  description = "The set content to write to the example.txt file (sets are unordered collections) and duplicated content \"apples\" is removed"
  type        = set(string)
  default     = ["apple", "banana", "apple"]
}

variable "map_content" {
  description = "The map content to write to the example.txt file"
  type        = map(string)
  default     = {
    name = "Alex"
    age = 40
  }
}

variable "tuple_content" {
  description = "The tuple content to write to the example.txt file"
  type        = tuple([string, number, bool])
  default     = ["Alex", 40, true]
}

variable "object_content" {
  description = "The object content to write to the example.txt file"
  type = object({
    name = string
    age  = number
    active = bool
  })
  default = {
    name   = "Alex"
    age    = 40
    active = true
  }
}