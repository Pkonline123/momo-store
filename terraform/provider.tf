terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.85"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "momo-back"
    region     = "ru-central1"
    key        = "terraform/terraform.tfstate"
    access_key = "YCAJEjO5whONIQTFIZZqgzjWV"
    secret_key = "YCPVjpu0j9GhJ2ck7w_OZNYe5cVsIP8YRLDU37EX"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
} 

provider "yandex" {
  token     = var.iam_token #secret.tfvars
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}