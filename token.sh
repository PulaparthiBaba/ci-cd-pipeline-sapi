#!/bearer.txt
###########################################################################
# name : shell script for entry into api manager
# created by : vizag offshore mulesoft team
# version : 1.0.0
###########################################################################
varOrg="a53ca6a9-0248-438b-85e4-016cb8263934"
varEnv="9ee99212-8f41-4339-af19-ed638a058300"
varAssetName="ci-cd-pipeline-sapi"
varoutput=$(curl -X POST "https://anypoint.mulesoft.com/accounts/login" -H "Content-Type: application/json" -d ' {"username":"Baba_pulaparthi1", "password":"Pulaparthi@789"}' )
echo $varoutput
varAccess=$(echo $varoutput | cut -d '"' -f 4,4)
echo 'access token is ' $varAccess
# 2nd step to get details from exchange using org id and our asset
var1=$(curl -X GET "https://anypoint.mulesoft.com/exchange/api/v2/assets?search=$varAssetName&organizationId=$varOrg" -H "Authorization: Bearer $varAccess")
#echo "${var1}"
# derive the group id and asset name and version from the var1 field
varExch=$(echo $var1 | cut -d ',' -f 1,2,3,4)
varGrp=$(echo $varExch | cut -d '"' -f 4)
varAsset=$(echo $varExch | cut -d '"' -f 8)
varVersion=$(echo $varExch | cut -d '"' -f 12)
echo "group id is $varGrp  asset name is $varAsset  version is $varVersion"
# 3rd step to post the api into api manager
curl -X POST "https://anypoint.mulesoft.com/apimanager/api/v1/organizations/$varOrg/environments/$varEnv/apis" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $varAccess" \
    -d '{
   "endpoint":{
      "deploymentType":"CH",
      "isCloudHub":null,
      "muleVersion4OrAbove":true,
      "proxyUri":null,
      "referencesUserDomain":null,
      "responseTimeout":null,
      "type":"raml",
      "uri":null
   },
   "providerId":null,
   "instanceLabel":null,
   "spec":{
      "assetId":"'$varAsset'",
      "groupId":"'$varGrp'",
      "version":"'$varVersion'"
   }
}'