Function List-AzResourceGroups{
<#
	.SYNOPSIS
		Lists Azure Resourcegroups in the current Azure context

	.DESCRIPTION
		Lists Azure Resourcegroups in the current Azure context

	.EXAMPLE
		List-AzResourceGroups

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		Outputs to screen

	.NOTES
		Version:			0.1
		Author:				Lars Panzerbj�rn
		Creation Date:		2023.10.06
		Purpose/Change: Initial script development
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$false,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='What Azure subscription would you like to target?')]
		[Alias('AzureSubscription')]
		[string[]]$AzSubscription
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

        IF($AzSubscription){
            Set-AzContext -Subscription $AzSubscription
        }

        Get-AzResourceGroup | select -ExpandProperty ResourceGroupName | Sort
    }

	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
	}
}