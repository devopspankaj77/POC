resource "azurerm_resource_group" "rg" {
  name     = "rg-backend"
  location = "East US"
}

resource "azurerm_storage_account" "stg" {
  name                     = "stgbackend25"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [azurerm_resource_group.rg  ]
  }

resource "azurerm_storage_container" "cont" {
  name                  = "backendcont"
  storage_account_id    = azurerm_storage_account.stg.id
  container_access_type = "private"
  depends_on = [azurerm_storage_account.stg  ]
}

