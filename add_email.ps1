####################################
## ADD EMAIL ATTRIBUTE TO AD USER ##
####################################


# Define the OU path and AD group name
$ouPath = "OU=UserAccounts,OU=Resources,DC=domain,DC=com"

$action = "Update"  # "Remove"
$groupName = "VPN"
$domain = "domain.com"

# Get the users in the specified AD group within the OU
$groupUsers = Get-ADGroupMember -Identity $groupName -Recursive | Where-Object { $_.objectClass -eq "user" }

# Array to store the results
$results = @()

# Loop through each user and prepare data for GridView
foreach ($groupUser in $groupUsers) {
    $name = $groupUser.Name.Split()[0]  # Get the first name
    $surname = $groupUser.Name.Split()[1]  # Get the last name
    $email = "$name.$surname@$domain"
    $sid = $groupUser.SID 
    $guid = $groupUser.objectGUID
    
     
    # Create a custom object to store user information
    $userObject = New-Object PSObject -Property @{
        Identity = $groupUser.DistinguishedName
        Name = $groupUser.Name
        Email = $email
        Action = $action  # Default action is update
        Array = "{[$sid, $guid]}"
    }
    
    # Add the user object to the results array
    $results += $userObject
}

# Display results in a GridView and allow selection
$selectedUsers = $results | Out-GridView -Title "Select users and action" -PassThru

# Loop through selected users and perform the selected action
foreach ($user in $selectedUsers) {
    if ($user.Action -eq "Update") {
  <#      # Split the user's name to extract first and last name
        $name = $user.Name.Split()[0]
        $surname = $user.Name.Split()[1]
        $email = "$name.$surname@$domain"
        
        # Set the email attribute
        Set-ADUser -Identity $user.Identity -EmailAddress $email
    #>

   $name = $user.Name
   Set-ADUser -Identity $user.Identity -EmailAddress $user.Email  # -Description "$name is now a VPN user"
    
    }
    elseif ($user.Action -eq "Remove") {
        # Remove the email attribute
        Set-ADUser -Identity $user.Identity -EmailAddress $null   # -Description $null
    }
}
