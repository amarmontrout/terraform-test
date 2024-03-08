terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 1.1.1"
    }
  }
}

provider "azurerm" {
  features {}
}
