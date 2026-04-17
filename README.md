# lab01-iac-miercoles

## Requisitos Previos
- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Git.

## Instrucciones de Despliegue

1. **Clonar el repositorio**
   ```bash
   git clone <https://github.com/AngheloAP1203/lab-iac-jueves-16-04-2026.git>
   cd lab01-iac-miercoles

2. **Configurar variables sensibles**
Nunca subimos credenciales a Git.
    cd terraform
    cp terraform.tfvars.example terraform.tfvars

3. **Inicializar Terraform**
Descarga los providers necesarios:
    terraform init

4. **Revisar el plan de ejecución**
Verifica qué contenedores, redes e imágenes se van a crear:
    terraform plan

5. **Aplicar la infraestructura**
Levanta todos los servicios:
    terraform apply

6. **Puertos Mapeados**

Entorno: Localhost
    Frontend (Nginx): http://localhost:4001

    Backend (Node): http://localhost:4002

    Base de Datos (Postgres): localhost:4003

Entorno: Dev
    Frontend (Nginx): http://localhost:5001

    Backend (Node): http://localhost:5002

    Base de Datos (Postgres): localhost:5003

7. **Limpieza**
Para destruir la infraestructura y detener los contenedores:
    terraform destroy