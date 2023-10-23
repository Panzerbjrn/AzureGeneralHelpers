Function List-AzRoleAssignments {
<#
	.SYNOPSIS
		Lists Azure Role Assignments

	.DESCRIPTION
		Lists Azusre Role Assignments, either for all contexts or the active context. Or user can be asked which context to use.

	.EXAMPLE
		Lists Azusre Role Assignments

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		Outputs object with VaultName and ResourceGroupName

	.NOTES
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

    IF($All){
        Get-AzRoleAssignment
    }
    IF($AzSubscription){
        Get-AzRoleAssignment -Scope "/subscriptions/$(Get-AzSubscription -SubscriptionName $AzSubscription)"
    }

}