# Changelog

## [4.0.0](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v3.0.0...v4.0.0) (2024-10-09)


### ⚠ BREAKING CHANGES

* point the Argo CD provider to the new repository ([#37](https://github.com/camptocamp/devops-stack-module-applicationset/issues/37))

### Features

* point the Argo CD provider to the new repository ([#37](https://github.com/camptocamp/devops-stack-module-applicationset/issues/37)) ([91930ee](https://github.com/camptocamp/devops-stack-module-applicationset/commit/91930eed4d41f341b2bdd58eb7cae2cf8c752849))

### Migrate provider source `oboukili` -> `argoproj-labs`

We've tested the procedure found [here](https://github.com/argoproj-labs/terraform-provider-argocd?tab=readme-ov-file#migrate-provider-source-oboukili---argoproj-labs) and we think the order of the steps is not exactly right. This is the procedure we recommend (**note that this should be run manually on your machine and not on a CI/CD workflow**):

1. First, make sure you are already using version 6.2.0 of the `oboukili/argocd` provider.

1. Then, check which modules you have that are using the `oboukili/argocd` provider.

```shell
$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/helm] 2.15.0
├── (...)
└── provider[registry.terraform.io/oboukili/argocd] 6.2.0

Providers required by state:

    (...)

    provider[registry.terraform.io/oboukili/argocd]

    provider[registry.terraform.io/hashicorp/helm]
```

3. Afterwards, proceed to point **ALL*  the DevOps Stack modules to the versions that have changed the source on their respective requirements. In case you have other personal modules that also declare `oboukili/argocd` as a requirement, you will also need to update them.

4. Also update the required providers on your root module. If you've followed our examples, you should find that configuration on the `terraform.tf` file in the root folder.

5. Execute the migration  via `terraform state replace-provider`:

```bash
$ terraform state replace-provider registry.terraform.io/oboukili/argocd registry.terraform.io/argoproj-labs/argocd
Terraform will perform the following actions:

  ~ Updating provider:
    - registry.terraform.io/oboukili/argocd
    + registry.terraform.io/argoproj-labs/argocd

Changing 13 resources:

  module.argocd_bootstrap.argocd_project.devops_stack_applications
  module.secrets.module.secrets.argocd_application.this
  module.metrics-server.argocd_application.this
  module.efs.argocd_application.this
  module.loki-stack.module.loki-stack.argocd_application.this
  module.thanos.module.thanos.argocd_application.this
  module.cert-manager.module.cert-manager.argocd_application.this
  module.kube-prometheus-stack.module.kube-prometheus-stack.argocd_application.this
  module.argocd.argocd_application.this
  module.traefik.module.traefik.module.traefik.argocd_application.this
  module.ebs.argocd_application.this
  module.helloworld_apps.argocd_application.this
  module.helloworld_apps.argocd_project.this

Do you want to make these changes?
Only 'yes' will be accepted to continue.

Enter a value: yes

Successfully replaced provider for 13 resources.
```

6. Perform a `terraform init -upgrade` to upgrade your local `.terraform` folder.

7. Run a `terraform plan` or `terraform apply` and you should see that everything is OK and that no changes are necessary. 

## [3.0.0](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v2.1.1...v3.0.0) (2024-01-19)


### ⚠ BREAKING CHANGES

* remove the Argo CD namespace variable ([#34](https://github.com/camptocamp/devops-stack-module-applicationset/issues/34))

### Bug Fixes

* remove the Argo CD namespace variable ([#34](https://github.com/camptocamp/devops-stack-module-applicationset/issues/34)) ([0b86204](https://github.com/camptocamp/devops-stack-module-applicationset/commit/0b86204da1d820b3ddbc3c09bbdfd8cf04d6bf9a))

## [2.1.1](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v2.1.0...v2.1.1) (2023-10-19)


### Bug Fixes

* add new variable to specifically set the AppSet destination ([#32](https://github.com/camptocamp/devops-stack-module-applicationset/issues/32)) ([ca0be76](https://github.com/camptocamp/devops-stack-module-applicationset/commit/ca0be76ba589173322d5cf8374f795ba2efe1206))

## [2.1.0](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v2.0.1...v2.1.0) (2023-09-14)


### Features

* add way to define destination cluster through name or address ([e1c5827](https://github.com/camptocamp/devops-stack-module-applicationset/commit/e1c5827567587f599bdbd124bc2f484feae52578))

## [2.0.1](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v2.0.0...v2.0.1) (2023-08-09)


### Bug Fixes

* readd support to deactivate auto-sync which was broken by [#26](https://github.com/camptocamp/devops-stack-module-applicationset/issues/26) ([#28](https://github.com/camptocamp/devops-stack-module-applicationset/issues/28)) ([594b09d](https://github.com/camptocamp/devops-stack-module-applicationset/commit/594b09dddd73cbfb49ed19ab9cea8e72914c63cf))

## [2.0.0](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.2.6...v2.0.0) (2023-07-11)


### ⚠ BREAKING CHANGES

* add support to oboukili/argocd v5 ([#26](https://github.com/camptocamp/devops-stack-module-applicationset/issues/26))

### Features

* add support to oboukili/argocd v5 ([#26](https://github.com/camptocamp/devops-stack-module-applicationset/issues/26)) ([80cff79](https://github.com/camptocamp/devops-stack-module-applicationset/commit/80cff79d8a7d0e2cf5d0fc548c5e9732848c1c2b))

## [1.2.6](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.2.5...v1.2.6) (2023-06-16)


### Documentation

* add link to images to better visualize them ([#24](https://github.com/camptocamp/devops-stack-module-applicationset/issues/24)) ([37f30e1](https://github.com/camptocamp/devops-stack-module-applicationset/commit/37f30e10c07f1995e57212bd1885a87ba43a4e2f))

## [1.2.5](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.2.4...v1.2.5) (2023-05-30)


### Bug Fixes

* add missing provider ([8a88ee5](https://github.com/camptocamp/devops-stack-module-applicationset/commit/8a88ee573450fd60c96144578784c818334e3a95))

## [1.2.4](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.2.3...v1.2.4) (2023-03-31)


### Documentation

* fix images on the README.adoc ([e9f53d7](https://github.com/camptocamp/devops-stack-module-applicationset/commit/e9f53d76f1a3c863399e7ca7afac23c97bcbe90b))

## [1.2.3](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.2.2...v1.2.3) (2023-03-08)


### Bug Fixes

* change to looser versions constraints as per best practices ([46cc257](https://github.com/camptocamp/devops-stack-module-applicationset/commit/46cc257b1c77bfecfd5ef29a14a12d26a9183180))

## [1.2.2](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.2.1...v1.2.2) (2023-02-28)


### Bug Fixes

* add bracket to unclosed variable block ([a497e45](https://github.com/camptocamp/devops-stack-module-applicationset/commit/a497e45cc165b65bf9023410f4f20e69305a6d38))
* add loose version constraints to the required providers ([3a311a4](https://github.com/camptocamp/devops-stack-module-applicationset/commit/3a311a424cc45e23eb07de7656193ae8b81466e6))
* use comparison with null instead of can() ([a986e46](https://github.com/camptocamp/devops-stack-module-applicationset/commit/a986e4655e5fa177e32c5e217c172451dac5eec8))

## [1.2.1](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.2.0...v1.2.1) (2023-02-22)


### Bug Fixes

* **argocd:** let user choose a specific module version ([#12](https://github.com/camptocamp/devops-stack-module-applicationset/issues/12)) ([5025839](https://github.com/camptocamp/devops-stack-module-applicationset/commit/5025839a3a19f752c08423c837e8cbba80ca55cf))

## [1.2.0](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.1.1...v1.2.0) (2023-01-30)


### Features

* add variable to configure auto-sync of the Argo CD Application ([#9](https://github.com/camptocamp/devops-stack-module-applicationset/issues/9)) ([7636bf8](https://github.com/camptocamp/devops-stack-module-applicationset/commit/7636bf8bb57c576cb0c0666e16694f36183eec1b))

## [1.1.1](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.1.0...v1.1.1) (2022-12-09)


### Documentation

* add repo link to sidebar and correct images ([#7](https://github.com/camptocamp/devops-stack-module-applicationset/issues/7)) ([d6499fb](https://github.com/camptocamp/devops-stack-module-applicationset/commit/d6499fb2e8a601463a803e2380c453c4418238ae))

## [1.1.0](https://github.com/camptocamp/devops-stack-module-applicationset/compare/v1.0.0...v1.1.0) (2022-11-18)


### Features

* add variables to configure credentials for private repositories ([#5](https://github.com/camptocamp/devops-stack-module-applicationset/issues/5)) ([b032b65](https://github.com/camptocamp/devops-stack-module-applicationset/commit/b032b659b796e2e4d5c77c2521fe1a759a5c57f9))

## 1.0.0 (2022-10-28)


### Features

* pass project_source_repos ([fc56cd3](https://github.com/camptocamp/devops-stack-module-applicationset/commit/fc56cd366c2dc25447e67917a7c986f056aeb238))
* revamp applicationset module ([#2](https://github.com/camptocamp/devops-stack-module-applicationset/issues/2)) ([53d4cf0](https://github.com/camptocamp/devops-stack-module-applicationset/commit/53d4cf0daf4e377b64af3ad5599491210e320acf))


### Bug Fixes

* **argocd:** solve allow_empty error ([1b0dbd1](https://github.com/camptocamp/devops-stack-module-applicationset/commit/1b0dbd17100130cb2b56aae556a11a552deface2))
* **namespace:** deploy ApplicationSet in argocd_namespace ([55f877b](https://github.com/camptocamp/devops-stack-module-applicationset/commit/55f877bc6828a43fdaea4f034b5f9aac86e75303))
* Use project for Applications, default for root app ([442881c](https://github.com/camptocamp/devops-stack-module-applicationset/commit/442881ceee8136b4f87264f769ac4ab570d4b04e))


### Code Refactoring

* move Terraform module at repository root ([46f0975](https://github.com/camptocamp/devops-stack-module-applicationset/commit/46f097549e63f2b2631db349e54af6e574abae68))
