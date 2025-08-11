# This file is used to define variables for the Terraform configuration. subscribe to the variables defined in variables.tf.
# The values here will override the defaults specified in variables.tf.
# This file is typically used to set environment-specific values or to provide custom inputs.
# The variables defined here will be used to populate the example.txt file created by the local_file
string_content = "Contents for terraform training. \nThis specific text value come from terraform.tfvars and are used to populate the example.txt file with various types of content, demonstrating Terraform's capabilities with complex variable types. \nOthers values below comes from the default values at variables.tf file."