# Cloud Foundry on Azure
[Cloud Foundry](https://github.com/cloudfoundry) is an open-source platform-as-a-service (PaaS) for building, deploying, and operating 12-factor applications developed in various languages and frameworks.

[Cloud Foundry on Azure - Official documentation](https://docs.microsoft.com/en-us/azure/cloudfoundry/cloudfoundry-get-started)

###  Cloud Foundry offerings in Azure
1. Open-source Cloud Foundry (OSS CF) - OSS CF is an entirely open-source version of Cloud Foundry managed by the Cloud Foundry Foundation. You can deploy OSS Cloud Foundry on Azure by first deploying a BOSH director and then deploying Cloud Foundry.
    * [Deploy Cloud Foundry on Azure - Github documentation](https://github.com/cloudfoundry/bosh-azure-cpi-release/blob/master/docs/guidance.md)
2. Pivotal Cloud Foundry (PCF) / VMware Tanzu Application Service (TAS) - It is an enterprise distribution of Cloud Foundry from Pivotal Software Inc. Pivotal Cloud Foundry (PCF) was acquired by VMware in 2019 & is now branded as VMware Tanzu Application Service (TAS). 
    * PCF/TAS includes the same core platform as the OSS distribution, along with a set of proprietary management tools and enterprise support. To run PCF/TAS on Azure, you must acquire a license from Pivotal. 
    * The tools include [Pivotal Operations Manager](https://docs.pivotal.io/ops-manager/2-10/install/), a web application that simplifies deployment and management of a Cloud Foundry foundation, and [Pivotal Apps Manager](https://docs.pivotal.io/pivotalcf/console/), a web application for managing users and applications.

## Cloud Foundry Install
* [Deploy Cloud Foundry on Azure](concepts/cf-azure.md)
* [Service Broker](concepts/service-broker.md)
