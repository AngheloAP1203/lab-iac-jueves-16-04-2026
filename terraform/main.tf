terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2" # Usamos una versión estable moderna
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "postgres" {
  name         = "postgres:13-alpine"
  keep_locally = true
}

resource "docker_image" "api" {
  name = "lab/api:latest"
  build {
    context = "${path.module}/../src/api"
  }
}

resource "docker_image" "web" {
  name = "lab/web:latest"
  build {
    context = "${path.module}/../src/web"
  }
}

resource "docker_network" "localhost_net" {
  name   = "localhost_network"
  driver = "bridge"
}

resource "docker_network" "dev_net" {
  name   = "dev_network"
  driver = "bridge"
}

resource "docker_container" "db_localhost" {
  name  = "bd-localhost"
  image = docker_image.postgres.image_id
  
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
  
  ports {
    internal = 5432
    external = 4003
  }
  
  networks_advanced {
    name = docker_network.localhost_net.name
  }
}

resource "docker_container" "api_localhost" {
  name  = "api-localhost"
  image = docker_image.api.image_id
  
  ports {
    internal = 3000
    external = 4002
  }
  
  networks_advanced {
    name = docker_network.localhost_net.name
  }
  depends_on = [docker_container.db_localhost]
}

resource "docker_container" "web_localhost" {
  name  = "web-localhost"
  image = docker_image.web.image_id
  
  ports {
    internal = 80
    external = 4001
  }
  
  networks_advanced {
    name = docker_network.localhost_net.name
  }
  depends_on = [docker_container.api_localhost]
}

resource "docker_container" "db_dev" {
  name  = "bd-dev"
  image = docker_image.postgres.image_id
  
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
  
  ports {
    internal = 5432
    external = 5003
  }
  
  networks_advanced {
    name = docker_network.dev_net.name
  }
}

resource "docker_container" "api_dev" {
  name  = "api-dev"
  image = docker_image.api.image_id
  
  ports {
    internal = 3000
    external = 5002
  }
  
  networks_advanced {
    name = docker_network.dev_net.name
  }
  depends_on = [docker_container.db_dev]
}

resource "docker_container" "web_dev" {
  name  = "web-dev"
  image = docker_image.web.image_id
  
  ports {
    internal = 80
    external = 5001
  }
  
  networks_advanced {
    name = docker_network.dev_net.name
  }
  depends_on = [docker_container.api_dev]
}