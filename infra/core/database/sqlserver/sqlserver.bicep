metadata description = 'Creates an Azure SQL Server instance.'
param name string
param location string = resourceGroup().location
param tags object = {}
param principalId string
param upn string
param sqlAuthAdminLogin string
@secure()
param sqlAuthAdminPassword string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    version: '12.0'
    minimalTlsVersion: '1.2'
    administratorLogin: sqlAuthAdminLogin
    administratorLoginPassword: sqlAuthAdminPassword
    publicNetworkAccess: 'Enabled'
       administrators: {
       administratorType: 'ActiveDirectory'
       principalType: 'User'
       azureADOnlyAuthentication: false
       login: upn
       sid: principalId
       tenantId: subscription().tenantId
      }
  }


  resource databaseWWI 'databases' = {
    name: 'wide_world_importers'
    location: location
    sku: {
      name: 'GP_S_Gen5_4'
      tier: 'GeneralPurpose'
      }
  }

  resource databaseAW 'databases'= {
    name: 'adventureworks'
    location: location
    tags: tags
    sku: {
      name: 'GP_S_Gen5_4'
      tier: 'GeneralPurpose'
      }
    properties: {
      autoPauseDelay: 60
      minCapacity: json('0.5')
      sampleName: 'AdventureWorksLT'
      }
  }

  resource firewall 'firewallRules' = {
    name: 'Azure Services'
    properties: {
      // Allow all clients
      // Note: range [0.0.0.0-0.0.0.0] means "allow all Azure-hosted clients only".
      // This is not sufficient, because we also want to allow direct access from developer machine, for debugging purposes.
      startIpAddress: '0.0.0.1'
      endIpAddress: '255.255.255.254'
    }
  }
}

/* resource sqlDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: '${name}-deployment-script'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.37.0'
    retentionInterval: 'PT1H' // Retain the script resource for 1 hour after it ends running
    timeout: 'PT5M' // Five minutes
    cleanupPreference: 'OnSuccess'
    environmentVariables: [
      {
        name: 'DBNAME'
        value: sqlServer::database.name
      }
      {
        name: 'DBSERVER'
        value: sqlServer.properties.fullyQualifiedDomainName
      }
      
    ]

    scriptContent: '''
wget https://github.com/microsoft/go-sqlcmd/releases/download/v0.8.1/sqlcmd-v0.8.1-linux-x64.tar.bz2
tar x -f sqlcmd-v0.8.1-linux-x64.tar.bz2 -C .

cat <<SCRIPT_END > ./initDb.sql
drop user if exists ${APPUSERNAME}
go
create user ${APPUSERNAME} with password = '${APPUSERPASSWORD}'
go
alter role db_owner add member ${APPUSERNAME}
go
SCRIPT_END

./sqlcmd -S ${DBSERVER} -d ${DBNAME} -U ${SQLADMIN} -i ./initDb.sql
    '''
  }
}
*/ 
output databaseAWName string = sqlServer::databaseAW.name
output databaseWWIName string = sqlServer::databaseWWI.name
