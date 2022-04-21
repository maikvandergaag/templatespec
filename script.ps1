#Login to the correct azure subscription
Login-AzAccount

$subscription = "f124b668-7e3d-4b53-ba80-09c364def1f3"
$resourcegroup = "sponsor-rg-templatespecs";
$rgDeploy = "sponsor-rg-templatespecs-deploy"
$location = "westeurope"
$versionnumber = "1.2"

Set-AzContext $subscription
New-AzResourceGroup -Name $resourcegroup -Location $location -Force
New-AzResourceGroup -Name $rgDeploy -Location $location -Force

#01
New-AzTemplateSpec -Name "az-tempspec-webapp" `
         -Version "$versionnumber" `
         -ResourceGroupName "$resourcegroup" `
         -Location "$location" `
         -TemplateFile ".\templatespecs\01-simpletemplatespec\01-simpletemplatespec.json"

$id = (Get-AzTemplateSpec -Name az-tempspec-webapp -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#02
New-AzTemplateSpec -Name "az-tempspec-linkedtemplate" `
         -Version "$versionnumber" `
         -ResourceGroupName "$resourcegroup" `
         -Location "$location" `
         -TemplateFile ".\templatespecs\02-linkedtemplatespec\02-linkedtemplatespec.json"

$id = (Get-AzTemplateSpec -Name az-tempspec-linkedtemplate -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#03
New-AzTemplateSpec -Name "az-tempspec-bicepwebapp" `
         -Version "$versionnumber" `
         -ResourceGroupName "$resourcegroup" `
         -Location "$location" `
         -TemplateFile ".\templatespecs\03-biceptemplatespec\03-biceptemplatespec.bicep"

$id = (Get-AzTemplateSpec -Name az-tempspec-bicepwebapp -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#04
#bicep build ".\templatespecs\04-bicepmoduletemplatespec\04-bicepmoduletemplatespec.bicep"
New-AzTemplateSpec -Name "az-tempspec-bicepmodulestorage" `
             -Version "$versionnumber" `
             -ResourceGroupName "$resourcegroup" `
             -Location "$location" `
             -TemplateFile ".\templatespecs\04-bicepmoduletemplatespec\04-bicepmoduletemplatespec.bicep"

$id = (Get-AzTemplateSpec -Name az-tempspec-bicepmodulestorage -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#certified storgage
New-AzTemplateSpec -Name "az-tempspec-certifiedstorage" `
             -Version "$versionnumber" `
             -ResourceGroupName "$resourcegroup" `
             -Location "$location" `
             -TemplateFile ".\templatespecs\05-certifiedstorage\05-storage.bicep"

$id = (Get-AzTemplateSpec -Name az-tempspec-certifiedstorage -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#05
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy `
             -TemplateFile ".\arm\armlinkedtemplatespec\armlinkedtemplatespec.json" `
             -TemplateParameterFile ".\arm\armlinkedtemplatespec\armlinkedtemplatespec.parameters.json" `
             -Confirm

