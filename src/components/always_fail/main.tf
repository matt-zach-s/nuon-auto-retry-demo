terraform {
  required_version = ">= 1.11.0"
}

resource "terraform_data" "always_fail" {
  input = timestamp()

  provisioner "local-exec" {
    command = "echo 'INTENTIONAL FAILURE: max_auto_retries demo' && exit 1"
  }
}
