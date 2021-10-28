#!/bin/sh
#
# this script is modified from https://github.com/cf-platform-eng/bosh-azure-template/blob/master/create_azure_principal.sh,
# and makes the following assumptions
#   1. Azure CLI is installed on the machine when this script is runnning
#   2. User has set Azure CLI to arm mode, and logged in with work or school account
#   3. Current account has sufficient privileges to create AAD application and service principal
#
#   This script will return clientID, tenantID, client-secret that can be used to
#   populate cloud foundry on Azure.

set +e

echo "Check if Azure CLI has been installed..."
VERSION_CHECK=`az -v | grep '[^0-9\.rc]'`
if [ -z "$VERSION_CHECK" ]; then
    echo "Azure CLI is not installed. Please install Azure CLI by following tutorial at https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/."
    exit 1
fi

# check if user needs to login
LOGIN_CHECK=`az resource list 2>&1 | grep error`
if [ -n "$LOGIN_CHECK" ]; then
    echo "You need login to continue..."
    echo "Which Azure environment do you want to login?"
    echo "1) AzureCloud (default)"
    echo "2) AzureChinaCloud"
    echo "3) AzureUSGovernment"
    echo "4) AzureGermanCloud"
    read -p "Please choose by entering 1, 2, 3 or 4: " ENV_OPT
    ENV="AzureCloud"
    if [ "$ENV_OPT" -eq 2 ]; then
      ENV="AzureChinaCloud"
    fi
    if [ "$ENV_OPT" -eq 3 ]; then
      ENV="AzureUSGovernment"
    fi
    if [ "$ENV_OPT" -eq 4 ]; then
      ENV="AzureGermanCloud"
    fi
    echo "Login to $ENV..."
    az login --environment $ENV
fi

set -e

# get subscription count, let user choose one if there're multiple subcriptions
echo "Getting subscription list"
SUBSCRIPTION_COUNT=`az account list | grep Enabled | awk '{print NR}' | tail -1`
echo "Subscription(s) found: $SUBSCRIPTION_COUNT"

if [ "$SUBSCRIPTION_COUNT" -gt 1 ]; then
  echo "There are $SUBSCRIPTION_COUNT subscriptions in your account:"
  az account list
  read -p "Copy and paste the Id of the subscription that you want to create Service Principal with: " INPUT_ID
  SUBSCRIPTION_ID=$INPUT_ID
else
  SUBSCRIPTION_ID=`az account list --query "[].id" -o tsv`
fi

echo "Use subscription $SUBSCRIPTION_ID..."
az account set --subscription $SUBSCRIPTION_ID

# get identifier for Service Principal
DEFAULT_IDENTIFIER=BOSHv`date +"%Y%m%d%M%S"`
# IDENTIFIER="1"
# while [ ${#IDENTIFIER} -gt 0 ] && [ ${#IDENTIFIER} -lt 8 ] || [ -n "`echo "$IDENTIFIER" | grep ' '`" ]; do
#   read -p "Please input identifier for your Service Principal with (1) MINIMUM length of 8, (2) NO space [press Enter to use default identifier $DEFAULT_IDENTIFIER]: " IDENTIFIER
# done
IDENTIFIER=${IDENTIFIER:-$DEFAULT_IDENTIFIER}

echo "Use $IDENTIFIER as identifier..."
BOSHNAME="${IDENTIFIER}"

# create Service Principal
TENANT_ID=`az account list --query "[].tenantId" -o tsv`

echo "Create Service Principal & assign the contributor role on subscription..."
# CLIENT_ID=`az ad app create --name "$BOSHNAME" --password "$CLIENT_SECRET" --identifier-uris ""$IDURIS"" --home-page ""$HOMEPAGE"" | grep  "AppId:" | awk -F':' '{ print $3 } ' | tr -d ' '`
sp_details=$(az ad sp create-for-rbac --name $BOSHNAME --role "contributor" --scopes "/subscriptions/$SUBSCRIPTION_ID")
# store the client ID & client secret details
CLIENT_ID=$(echo $sp_details | jq .appId)
CLIENT_SECRET=$(echo $sp_details | jq .password)
# remove the service principal details from the variable
sp_details=""

# output service principal
echo "Successfully created Service Principal."
echo "==============Created Serivce Principal=============="
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "TENANT_ID:       $TENANT_ID"
echo "SP_NAME:         $DEFAULT_IDENTIFIER"
echo "CLIENT_ID:       $CLIENT_ID"
echo "CLIENT_SECRET:   $CLIENT_SECRET"