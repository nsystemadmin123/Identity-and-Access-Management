<#
Script Name: Add-Users-To-M365-Group.ps1
Purpose: Bulk add users to M365 group using Microsoft Graph
Domain: Identity & Access Management (IAM)
#>

# -------------------------
# Connect to Microsoft Graph
# -------------------------
Connect-MgGraph -Scopes "GroupMember.ReadWrite.All", "User.Read.All"

# -------------------------
# INPUT CONFIG
# -------------------------
$userListPath = "<CSV_OR_TXT_PATH>"
$groupId = "<ENTRA_ID_GROUP_OBJECT_ID>"

# -------------------------
# Read user list
# -------------------------
$userEmails = Get-Content -Path $userListPath

foreach ($email in $userEmails) {
    try {
        $email = $email.Trim()

        # Get user object from Entra ID
        $user = Get-MgUser -UserId $email

        # Add user to M365 group
        New-MgGroupMember -GroupId $groupId -DirectoryObjectId $user.Id

        Write-Host "✅ Added $email to the group." -ForegroundColor Green
    }
    catch {
        Write-Warning "❌ Failed to add $email: $_"
        Add-Content -Path "<ERROR_LOG_PATH>" -Value "Failed to add $email: $_"
    }
}