Function List-AzComputeResourceSku {
<#
	.SYNOPSIS
		Lists Azusre Compute Resource Skus

	.DESCRIPTION
		Lists Azusre Compute Resource Skus. Will ask for region if none is specified.

	.EXAMPLE
		List-AzComputeResourceSku

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
			HelpMessage='Which region do you want information about?')]
		[Alias('Location','AzRegion','Region')]
		[string]$AzLocation,

		[Parameter(Mandatory=$false,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='Which Type of resource Sku do you want information about?')]
		[Alias('Type')]
		[string]$AzResourceType
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		IF((!$AzLocation) -and ($Ask)){
			$menu = @{}
        	$Items =  Get-AzLocation | select DisplayName | Sort -Property DisplayName
			for ($i=1;$i -le $Items.count; $i++) {
				Write-Host "$i. $($Items[$i-1].DisplayName)"
				$menu.Add($i,($Items[$i-1].DisplayName))
				}

			[int]$ans = Read-Host 'Enter selection'
			$AzLocation = $menu.Item($ans)
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