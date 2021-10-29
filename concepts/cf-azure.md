# Deploy Cloud Foundry on Azure

### 1 Create a Service Principal
* [Script to create Service Principal](../src/create-service-principal.sh)

### 2 Generate your Public/Private Key Pair
The parameter `sshKeyData` required in the template should be a string which starts with `ssh-rsa`.

Use ssh-keygen to create a 2048-bit RSA public and private key files, and unless you have a specific location or specific names for the files, accept the default location and name.

```bash
ssh-keygen -t rsa -b 2048
```

Then you can find your public key in `~/.ssh/id_rsa.pub`, and your private key in `~/.ssh/id_rsa`. Copy and paste the contents of `~/.ssh/id_rsa.pub` as `sshKeyData`.

> WSL users: If you get an error due to permissions on the private key & are unable to change permissions of a file using chmod in wsl, refer this [link](https://www.reddit.com/r/bashonubuntuonwindows/comments/ovmlk3/unable_to_change_permissions_of_a_file_using/). Grant permission `chmod 600 <filename>` To access the key files stored in wsl via windows, go to command prompt & type `\\wsl$\`

### 3 Deploy BOSH and Cloud Foundry
This template can help you setup the development environment to deploy BOSH and Cloud Foundry on Azure.

[![Deploy To Azure](https://raw.githubusercontent.com/abhinabsarkar/cloud-foundry/main/images/deploytoazure.png?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fabhinabsarkar%2Fcloud-foundry%2Fmain%2Fsrc%2Fbosh-setup%2Fazuredeploy.json)  [![Visualize](https://raw.githubusercontent.com/abhinabsarkar/cloud-foundry/main/images/visualizebutton.png?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fabhinabsarkar%2Fcloud-foundry%2Fmain%2Fsrc%2Fbosh-setup%2Fazuredeploy.json)

This template can help you setup the development environment to deploy [BOSH](http://bosh.io/) and [Cloud Foundry](https://www.cloudfoundry.org/) on Azure Cloud, Azure China Cloud, Azure Germany Cloud, Azure USGovernment Cloud and Azure Stack.

You can follow the guide [**HERE**](https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release/blob/master/docs/guidance.md) to deploy Cloud Foundry on Azure.

The template will create the following Azure resources that’s required for deploying BOSH and Cloud Foundry:

* A default Storage Account
* Three reserved public IPs
  * For dev-box
  * For Cloud Foundry
  * For Bosh
* A Virtual Network
* A Virtual Machine as your dev-box
* A Bosh director if enabled (default is enabled)
    * The Bosh director will be deployed by the template (default). As a result, the deployment time of bosh-setup template will be much longer (~1h).
    * If you would like to deploy Bosh using a more customized bosh.yml, you can set autoDeployBosh to disabled. After the deployment succeeds, you can login the dev-box, update ~/bosh.yml, and run ./deploy_bosh.sh.

![alt txt](/images/bosh-setup-arm-template-v2.7.0-visualizer.png)

## References
* [Deploy Cloud Foundry on Azure](https://github.com/cloudfoundry/bosh-azure-cpi-release/tree/master/docs)