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
        [switch]$All,
	)


    IF($All){
        $KVaults = @()
        List-AzSubscriptions | ForEach-Object {
            Set-Azcontext $_
            $KVaults += Get-AzKeyVault
        }
    }

}