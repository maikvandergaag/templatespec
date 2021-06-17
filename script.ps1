#Login to the correct azure subscription
Login-AzAccount

$resourcegroup = "sponsor-rg-templatespecs";
$rgDeploy = "sponsor-rg-templatespecs-deploy" 
$location = "westeurope"
$versionnumber = "1.2"

New-AzResourceGroup -Name $resourcegroup -Location $location -Force
New-AzResourceGroup -Name $rgDeploy -Location $location -Force

#01
New-AzTemplateSpec -Name "az-tempspec-webapp" -Version "$versionnumber" -ResourceGroupName "$resourcegroup" -Location "$location" -TemplateFile ".\01-simpletemplatespec\01-simpletemplatespec.json"

$id = (Get-AzTemplateSpec -Name az-tempspec-webapp -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#02
New-AzTemplateSpec -Name "az-tempspec-linkedtemplate" -Version "$versionnumber" -ResourceGroupName "$resourcegroup" -Location "$location" -TemplateFile ".\02-linkedtemplatespec\02-linkedtemplatespec.json"

$id = (Get-AzTemplateSpec -Name az-tempspec-linkedtemplate -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#03
bicep build ".\03-biceptemplatespec\03-biceptemplatespec.bicep"
New-AzTemplateSpec -Name "az-tempspec-bicepwebapp" -Version "$versionnumber" -ResourceGroupName "$resourcegroup" -Location "$location" -TemplateFile ".\03-biceptemplatespec\03-biceptemplatespec.json"

$id = (Get-AzTemplateSpec -Name az-tempspec-bicepwebapp -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id

#04
bicep build ".\04-bicepmoduletemplatespec\04-bicepmoduletemplatespec.bicep"
New-AzTemplateSpec -Name "az-tempspec-bicepmodulestorage" -Version "$versionnumber" -ResourceGroupName "$resourcegroup" -Location "$location" -TemplateFile ".\04-bicepmoduletemplatespec\04-bicepmoduletemplatespec.json"

$id = (Get-AzTemplateSpec -Name az-tempspec-bicepmodulestorage -ResourceGroupName $resourcegroup -Version $versionnumber).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateSpecId $id 

#05
New-AzResourceGroupDeployment -ResourceGroupName $rgDeploy -TemplateFile ".\05-module\05-module.json" -Confirm

