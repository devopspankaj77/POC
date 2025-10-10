  terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.47.0"
    }
    # backend "azurerm" {
   
    # tenant_id            = "e270fd69-de2c-4331-b82d-ecdd35b46120"  # Can also be set via `ARM_TENANT_ID` environment variable. Azure CLI will fallback to use the connected tenant ID if not supplied.
    # storage_account_name = "stgbackend25"                           # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    # container_name       = "backendcont"                           # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    # key                  = "terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    #   }
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "bfa25a35-e77a-47a6-8d20-5557ab211ef7"
}

