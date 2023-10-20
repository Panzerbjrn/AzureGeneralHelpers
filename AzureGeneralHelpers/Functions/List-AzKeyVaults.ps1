Function List-AzKeyVaults {
<#
	.SYNOPSIS
		Lists Azusre Key Vaults

	.DESCRIPTION
		Lists Azusre Key Vaults, either for all contexts or the active context. Or user can be asked which context to use.

	.EXAMPLE
		Lists Azusre Key Vaults

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		Outputs object with VaultName and ResourceGroupName

	.NOTES
		Version:			0.1
		Author:				Lars Panzerbjørn
		Creation Date:		2023.10.10
		Purpose/Change:     Initial script development
#>
	[CmdletBinding()]
	param(
		[Parameter(
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='Which Azure subscription would you like to target?')]
		[Alias('AzSub')]
		[string]$AzSubscription,

        [switch]$Ask,
        [switch]$All
	)

    $KVaults = @()

    IF($All){
        Get-AzSubscription | select-Object -ExpandProperty Id | ForEach-Object {
            $KVaults += Get-AzKeyVault -SubscriptionId $_
        }
    }
    ELSEIF($AzSubscription){
        Get-AzSubscription -SubscriptionName $AzSubscription | select-Object -ExpandProperty Id | ForEach-Object {
            $KVaults += Get-AzKeyVault -SubscriptionId $_
        }
    }
    ELSEIF($Ask){
        $menu = @{}
        $Items =  Get-AzSubscription | select Name,Id | Sort -Property Name
        for ($i=1;$i -le $Items.count; $i++) {
            Write-Host "$i. $($Items[$i-1].Name)"
            $menu.Add($i,($Items[$i-1]))
            }

        [int]$ans = Read-Host 'Enter selection'
        $AzSubscription = $menu.Item($ans)

    }
    ELSE{

    }

    $KVaults
}