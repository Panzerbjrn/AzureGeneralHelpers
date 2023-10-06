Function List-AzContainerContents{
<#
	.SYNOPSIS
		Lists contents of an Azure Container

	.DESCRIPTION
		Lists contents of an Azure Container. Will ask for Resource Group/Storage Account/Container if none is specified.

	.EXAMPLE
		List-AzContainerContents

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		Outputs to screen

	.NOTES
		Version:			0.1
		Author:				Lars Panzerbjørn
		Creation Date:		2023.10.06
		Purpose/Change:     Initial script development
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='Which Azure subscription would you like to target?')]
		[Alias('AzSub')]
		[string]$AzSubscription,

		[Parameter(Mandatory=$false,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='Which Azure resource group would you like to target?')]
		[Alias('AzRG')]
		[string]$AzResourceGroup,

		[Parameter(Mandatory=$false,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='Which Azure storage account would you like to target?')]
		[Alias('AzSA')]
		[string]$AzStorageAccount,

		[Parameter(Mandatory=$false,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='Which Azure storage container would you like to target?')]
		[Alias('AzCont')]
		[string]$AzStoragecontainer
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

        IF($AzSubscription){
            Set-AzContext -Subscription $AzSubscription | Out-null
        }

		IF(!$AzResourceGroup){
			$menu = @{}
        	$Items = Get-AzResourceGroup | Sort-Object -Property ResourceGroupName
			for ($i=1;$i -le $Items.count; $i++) {
				Write-Host "$i. $($Items[$i-1].ResourceGroupName)"
				$menu.Add($i,($Items[$i-1].ResourceGroupName))
				}

			[int]$ans = Read-Host 'Enter selection'
			$AzResourceGroup = $menu.Item($ans)
		}

        IF($AzStorageAccount){$AzStorageAccount = Get-AzStorageAccount -ResourceGroupName $AzResourceGroup -Name $AzStorageAccount}
		IF(!$AzStorageAccount){
			$menu = @{}
        	$Items = Get-AzStorageAccount -ResourceGroupName $AzResourceGroup | Sort-Object -Property StorageAccountName
			for ($i=1;$i -le $Items.count; $i++) {
				Write-Host "$i. $($Items[$i-1].StorageAccountName)"
				$menu.Add($i,($Items[$i-1].StorageAccountName))
			}

			[int]$ans = Read-Host 'Enter selection'
			$AzStorageAccount = $menu.Item($ans)
		}

        IF($AzStoragecontainer){
            $AzStoragecontainer = Get-AzStorageContainer -Context (Get-AzStorageAccount -ResourceGroupName $AzResourceGroup -Name $AzStorageAccount).Context -Name $AzStoragecontainer | Select-Object -ExpandProperty Name
        }
        IF(!$AzStoragecontainer){
			$menu = @{}
        	$Items = Get-AzStorageContainer -Context (Get-AzStorageAccount -ResourceGroupName $AzResourceGroup -Name $AzStorageAccount).Context | Sort-Object -Property Name
			for ($i=1;$i -le $Items.count; $i++) {
				Write-Host "$i. $($Items[$i-1].Name)"
				$menu.Add($i,($Items[$i-1].Name))
			}

			[int]$ans = Read-Host 'Enter selection'
			$AzStoragecontainer = $menu.Item($ans)
		}


        Get-AzStorageBlob -Context (Get-AzStorageAccount -ResourceGroupName $AzResourceGroup -Name $AzStorageAccount).Context -Container $AzStoragecontainer | Select-Object -ExpandProperty Name

    }

	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
	}
}