# lau-shared-infrastructure

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 

This module sets up the shared infrastructure for LAU services.

## Overview

<p align="center">
<a href="https://github.com/hmcts/lau-frontend">lau-frontend</a> • <a href="https://github.com/hmcts/lau-case-backend">lau-case-backend</a> • <a href="https://github.com/hmcts/lau-idam-backend">lau-idam-backend</a> • <b><a href="https://github.com/hmcts/lau-shared-infrastructure">lau-shared-infrastructure</a></b>
</p>

<br>

<p align="center">
  <img src="https://raw.githubusercontent.com/hmcts/reform-api-docs/master/docs/c4/lau/images/structurizr-lau-overview.png" width="500"/>
</p>

## Variables

### Configuration

The following parameters are required by this module

- `env` The environment of the deployment, such as "prod" or "sandbox".
- `tenant_id` The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
- `jenkins_AAD_objectId` The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.

The following parameters are optional

- `product` The (short) name of the product. Default is "lau". 
- `location` The location of the Azure data center. Default is "UK South".
- `appinsights_location` Location for Application Insights. Default is "West Europe".
- `application_type` Type of Application Insights (Web/Other). Default is "Web".

### Output

- `appInsightsInstrumentationKey` The instrumentation key for the application insights instance.
- `vaultName` The name of the key vault.
