# provides configuration details from terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.31.1"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore"
    storage_account_name = "tfstoragesv21041979"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Provides configuration details for the Azure Terraform provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_test" {
  name     = "tfmainrg"
  location = "ukwest"
  tags = {
    environment = "Dev"
    owner       = "Scott Vaughan"
  }
}

resource "azurerm_container_group" "tfcg_test" {
  name     = "weatherapi"
  location = azurerm_resource_group.tf_test.location
  tags = {
    environment = "Dev"
    owner       = "Scott Vaughan"
  }
  resource_group_name = azurerm_resource_group.tf_test.name
  ip_address_type     = "public"
  dns_name_label      = "scottvaughanamidoweatherapi"
  os_type             = "Linux"
  container {
    name   = "weatherapi"
    image  = "scottvaughanamido/weatherapi"
    cpu    = "1"
    memory = "1"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}