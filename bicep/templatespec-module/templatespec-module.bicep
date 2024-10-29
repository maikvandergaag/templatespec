// ****************************************
// Azure Bicep:
// Bicep files that uses modules from template spec
// ****************************************

//storage name parameter
param storageName string = 'azstrdeploytest'

// Location parameter
param location string = resourceGroup().location

// Use storage module
module automation 'ts/TemplateSpecs:az-tempspec-certifiedstorage:1.2' ={
  name: 'certifiedstorage'
  params:{
    storageName: storageName
    location: location
  }
}
