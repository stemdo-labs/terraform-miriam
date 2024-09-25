# Documentación de la Solución: Módulo de Terraform y Workflow de GitHub Actions

## Descripción General

El objetivo de este ejercicio ha sido desarrollar un módulo de Terraform que permita desplegar múltiples máquinas virtuales (VMs) con atributos configurables, un balanceador de carga (LB) y los componentes de red necesarios en Azure. Además, se ha implementado un workflow de GitHub Actions para automatizar las operaciones de terraform plan, apply y destroy en función de eventos en el repositorio.

## Estructura del Proyecto

Para el desarrolo e implementación de este ejercicio he usado tres repositorios distintos:

### Repositorio de la infraestructura:

- Los archivos de la infraestuctura de Terraform están alojados en este repositorio.
- Permite la creación de múltiples VMs a través de un mapa de objetos, balanceo de carga y configuración de la red (subredes, interfaces de red, grupos de seguridad) usando el [repositorio del módulo](https://github.com/stemdo-labs/terraform-module-miriam).
- Se ha preparado un `.gitignore` para evitar subir archivos innecesarios o con información sensible.

### Repositorio del módulo:

- El módulo está compuesto por los siguientes componentes clave:
    - Máquinas Virtuales: Se definen a través de un mapa de objetos que permite configurar atributos como tamaño, imagen y etiquetas.
    - Balanceador de Carga: Distribuye el tráfico entrante entre las máquinas virtuales.
    - Red: Configuración de la red virtual, subredes, interfaces de red y grupos de seguridad.

### Repositorio del Workflow:

- El workflow de GitHub Actions fue configurado en un segundo [repositorio](https://github.com/stemdo-labs/terraform-workflow-miriam) y hace uso de este repositorio para crear la infraestructura.
- Se han configurado los secretos necesarios con las credenciales del SP (Service Principal) de Azure. Obteniéndose con los siguientes comandos:
    - Client_id: ```az ad sp list --display-name <nombre_sp>```
    - Client_secret: ```az keyvault secret show --name <nombre_sp> --vault-name <nombre_keyvault> --query value -o tsv```
    - Tenant_id: ```az account show --output table```

- Acciones Principales:
    - Terraform Plan en PR:
    Cada vez que se realiza un ``pull request``, el workflow ejecuta terraform plan para verificar los cambios propuestos. El resultado se comenta automáticamente en la PR.
    - Terraform Apply en Merge:
    Al realizar el ``merge`` de una PR, el workflow ejecuta terraform apply y despliega los recursos en Azure.
    - Ejecución Manual:
    Se implementaron jobs manuales que permiten la ejecución de ``plan``, ``apply`` o ``destroy`` sin necesidad de abrir un PR o realizar un merge.
