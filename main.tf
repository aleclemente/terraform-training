terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }
}

resource "local_file" "txtFileExample" {
  filename = "${path.module}/example.txt"
    content  = <<EOF
      string content: ${var.string_content}
      
      number content: ${var.number_content}
      boolean content: ${var.boolean_content}
      list first element: ${var.list_content[0]}
      list content: ${join(", ", var.list_content)}
      set first element: ${tolist(var.set_content)[0]}
      set content: ${join(", ", var.set_content)}
      map first element: ${var.map_content["name"]} - age: ${var.map_content["age"]}
      map content: ${jsonencode(var.map_content)}
      tuple first element: ${var.tuple_content[0]}, second element: ${var.tuple_content[1]}, third element: ${var.tuple_content[2]}
      tuple content: ${jsonencode(var.tuple_content)}
      object name: ${var.object_content.name}, age: ${var.object_content.age}, active: ${var.object_content.active}
      object content: ${jsonencode(var.object_content)}
  EOF
}