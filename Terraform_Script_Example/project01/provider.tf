terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "aws" {
  access_key = "**********"
  secret_key = "**************"
  region     = "eu-north-1"
}
