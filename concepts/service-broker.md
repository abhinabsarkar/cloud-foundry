# Service Broker
The Service Broker API defines an HTTP interface between the services marketplace of a platform and service brokers.

The service broker is the component of the service that implements the Service Broker API, for which a platform's marketplace is a client. Service brokers are responsible for advertising a catalog of service offerings and service plans to the marketplace, and acting on requests from the marketplace for <ins>**provisioning, binding, unbinding, and deprovisioning**</ins>.

In general, <ins>**provisioning**</ins> reserves a resource on a service; we call this reserved resource a service instance. What a service instance represents can vary by service. Examples include a single database on a multi-tenant server, a dedicated cluster, or an account on a SaaS app.

What a <ins>**binding**</ins> represents MAY also vary by service. In general creation of a binding either generates credentials necessary for accessing the resource or provides the service instance with information for a configuration change.

A platform marketplace MAY expose services from one or many service brokers, and an individual service broker MAY support one or many platform marketplaces using different URL prefixes and credentials.

## Service Broker in Cloud Foundry
Cloud Foundry implements a mechanism for provisioning services known as a service broker. This implementation enables a self-service model that allows developers to provision access to a service, e.g. a database, for use by an application. This is also referred to as binding an application to a service. The underlying mechanics of provisioning a tenant or deploying a dedicated instance of the service for the application are transparent to the developer.

![alt text](/images/sb-architecture-cf.png)

Services are integrated with Cloud Foundry by using a documented API for which the Cloud Controller is the client, called the Service Broker API. 
> This should not be confused with the Cloud Controller API (CAPI), often used to refer to the version of Cloud Foundry. The Service Broker API is versioned independently of CAPI.

The component of the service that uses the Service Broker API is called the service broker.Service brokers advertise a catalog of service offerings and service plans, as well as interpreting calls for provision, bind, unbind, and deprovision. What a broker does with each call can vary between services. In general, ‘provision’ reserves resources on a service and 'bind’ delivers information to an app necessary for accessing the resource. The reserved resource is called a service instance.

## Binding workflow without CredHub integration

![alt text](/images/binding-workflow-no-credhub.png)

1. User requests to bind Service1 to App1
2. Cloud Controller send bind request to Service Broker
3. Service Broker provisions service credentials with service
4. Service returns credential values
5. Service Broker returns 'VCAP_SERVICES' data containing credential values to Cloud Controller
6. Cloud Controller sends 'VCAP_SERVICES' data containing credential values to Diego
7. Diego places data containing credential values into App1 environment
8. Success response
9. Success response
10. Success response

## Binding workflow with CredHub integration
CredHub is a component designed for centralized credential management in Cloud Foundry. At the highest level, CredHub centralizes and secures credential generation, storage, lifecycle management, and access.

Credentials exist in many places in the Cloud Foundry ecosystem. Applications consume service credentials through the VCAP_SERVICES environment variable. CF components in the management backplane use them for authenticated communications with other components. It is common for a CF installation to have hundreds of active credentials, and all of them are important in their own way. It is widely known that leaked credentials are a common culprit in data breaches. It behooves all of us in the community to do what we can to improve how the CF ecosystem manages credentials.

This modified workflow reduces the requests containing credentials to only those essential to the process & addresses the below mentioned concerns:
* Leaking environment variables to logs increase risk of disclosure
* Transiting credentials between components increases risk of disclosure
* Rotating credentials delivered via the environment require container recreation

![alt text](/images/binding-workflow-credhub.png)

1. User requests to bind Service1 to App1
2. Cloud Controller send bind request to Service Broker
3. Service Broker provisions service credentials with service
4. Service returns credential values
5. Service Broker sets credential value into CredHub with access control allowing App1 to read the value
6. Success response
7. Service Broker returns 'VCAP_SERVICES' data containing CredHub reference to Cloud Controller
8. Cloud Controller sends 'VCAP_SERVICES' data containing CredHub reference to Diego
9. Diego places data containing CredHub reference into App1 environment
10. Success response
11. Success response
12. Success response
> N stands for the reference to the data stored in the CredHub

A service broker would return a reference to the stored credentials in response to a binding request from Cloud Controller. To facilitate retrieval of the credentials by bound applications, the credentials returned to Cloud Controller should contain the single key “credhub-ref”, and the name of the stored credential as the value for that key. 

## Meta Azure Service Broker
It is built on Node.JS & made available as a module to cf cli.
* [How a Cloud Foundry Admin manages the meta Azure service broker](https://github.com/Azure/meta-azure-service-broker/blob/master/docs/how-admin-deploy-the-broker.md)

![alt txt](/images/azure-sb.png)

> The Microsoft Azure Service Broker for VMware Tanzu is supported until January 31, 2021. It is strongly discouraged to adopt this tile for any new or existing projects by VMware. https://docs.pivotal.io/partners/azure-sb/index.html

## Cloud Service Broker
Cloud Service Broker is an extension of the GCP Service Broker, which adheres to the Open Service Broker API (OSBAPI). It is cloud-agnostic. As long as your target public cloud has a Terraform provider, services can be provisioned via a common interface using standard cf CLI commands. Cloud Service Broker uses brokerpaks (courtesy of Google). A brokerpak is a zip package that contains bundled versions of Terraform, service definitions (as Terraform modules), Terraform providers, and source code for regulatory compliance. These Terraform templates are then packaged as brokerpaks to be consumed by the broker.

![alt txt](/images/cloud-sb.png)

* [Extend Your Apps with AWS, Azure, and GCP Services using Cloud Service Broker](https://tanzu.vmware.com/content/blog/extend-your-apps-with-aws-azure-and-gcp-services-using-cloud-service-broker)
* [Cloud Service Broker for Azure](https://docs.pivotal.io/csb-azure/1-2/index.html)

## References
* [Open Service Broker API v2.12](https://github.com/openservicebrokerapi/servicebroker/blob/v2.12/spec.md)
* [Service Broker Cloud Foundry](https://docs.cloudfoundry.org/services/overview.html)
* [Meta Azure Service Broker](https://github.com/Azure/meta-azure-service-broker)
* **Securing Service Credentials with Runtime CredHub**
    * [CredHub - Cloud Foundry component - Github documentation](https://github.com/cloudfoundry-incubator/credhub/blob/main/docs/product-summary.md)
    * [CredHub - Secure Service Credential Delivery - Official Github documentation](https://github.com/cloudfoundry-incubator/credhub/blob/main/docs/secure-service-credentials.md)
    * [CredHub - Pivotal Cloud Foundry - Official documentation](https://docs.pivotal.io/credhub)
    * [CredHub - Cloud Foundry - Official documentation](https://docs.cloudfoundry.org/credhub/index.html)
* [Cloud Service Broker](https://tanzu.vmware.com/content/blog/extend-your-apps-with-aws-azure-and-gcp-services-using-cloud-service-broker)
* [Brokerpak](https://github.com/GoogleCloudPlatform/gcp-service-broker/blob/master/docs/brokerpak-intro.md)