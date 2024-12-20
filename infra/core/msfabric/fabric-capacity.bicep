param location string
param name string
param tags object = {}
param sku object 
param members array 

resource fabricCapacity 'Microsoft.Fabric/capacities@2023-11-01' = {
  location: location
  name: name
  tags: tags
  properties: {
    administration: {
      members: members
    }
  }
  sku: sku
}
