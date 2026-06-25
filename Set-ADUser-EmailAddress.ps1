#Username "user1" -NewEmail "user1@domain.com"


<#
Script Name: Set-ADUser-EmailAddress.ps1
Purpose: Update a user's email address in Active Directory
Domain: Identity & Access Management (IAM)
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# -------------------------
# INPUT PARAMETERS (SAFE)
# -------------------------
$username = "<AD_USERNAME>"
$newEmail = "<NEW_EMAIL_ADDRESS>"

# -------------------------
# UPDATE USER EMAIL
# -------------------------
try {
    Set-ADUser -Identity $username -EmailAddress $newEmail
    Write-Host "Email address for '$username' has been set to: $newEmail" -ForegroundColor Green
}
catch {
    Write-Host "Failed to update email address for '$username'. Error: $_" -ForegroundColor Red
}