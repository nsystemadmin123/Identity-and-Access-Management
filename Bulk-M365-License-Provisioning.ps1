<#
Script Name: Bulk-M365-License-Provisioning.ps1
Purpose: Bulk assign Microsoft 365 licenses to users using Microsoft Graph
Domain: Identity & Access Management (IAM)
#>

# -------------------------
# IMPORT USERS
# -------------------------
$Users = Import-Csv "<USER_CSV_PATH>"

# -------------------------
# GET LICENSE SKU
# -------------------------
$LicenseSkuPartNumber = "<LICENSE_SKU_PART_NUMBER>"

$license = Get-MgSubscribedSku |
Where-Object { $_.SkuPartNumber -eq $LicenseSkuPartNumber }

if (-not $license) {
    Write-Host "License not found. Check SKU configuration." -ForegroundColor Red
    return
}

# -------------------------
# PROCESS USERS
# -------------------------
foreach ($user in $Users) {

    $upn = $user.UserPrincipalName

    try {
        # Get user
        $userObject = Get-MgUser -UserId $upn

        if ($userObject) {

            # Check existing license
            $userLicense = Get-MgUserLicenseDetail -UserId $userObject.Id |
            Where-Object { $_.SkuId -eq $license.SkuId }

            if ($userLicense) {
                Write-Host "ℹ️ Already licensed: $($userObject.DisplayName)" -ForegroundColor Yellow
            }
            else {
                Write-Host "Assigning license to $($userObject.DisplayName)" -ForegroundColor Green

                Set-MgUserLicense `
                    -UserId $userObject.Id `
                    -AddLicenses @{SkuId = $license.SkuId } `
                    -RemoveLicenses @() `
                    -ErrorAction Stop
            }
        }
        else {
            Write-Host "User not found: $upn" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Error processing $upn : $($_.Exception.Message)" -ForegroundColor Red
        continue
    }
}