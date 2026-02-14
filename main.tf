# This is where the resources are defined.

provider "docker" {
    
}

resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.name
  name = "nginx_container"
  ports {
    internal = 80
    external = 8080
  }
}
