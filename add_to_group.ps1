###################################
## ADD USERS TO GROUP            ##
###################################

# Prompt for OU distinguished name
$OU = 'OU=UserAccounts,OU=Resources,DC=domain,DC=com' #Read-Host "Enter the distinguished name of the OU (e.g., 'OU=Users,DC=domain,DC=com')"
$VPNGroup = "VPN"


# Get users in the specified OU
$Users = Get-ADUser -Filter *   | Select-Object SamAccountName, Name | Out-GridView -Title "Select Users to Add to VPN Group" -PassThru

# If users are selected, add them to the VPN group
if ($Users) {

    foreach ($User in $Users) {
        Add-ADGroupMember -Identity $VPNGroup -Members $User.SamAccountName
    }
    
    # Show the members of the VPN group
    Get-ADGroupMember -Identity $VPNGroup | Select-Object SamAccountName, Name | Out-GridView -Title "Members of VPN Group"

} else {
    Write-Host "No users selected."
}
