provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "shared" {
  name       = "tfnet"
  attachable = true
}

resource "docker_container" "example-app" {
  name  = "example-app"
  image = docker_image.example_app.image_id
  networks_advanced {
    name = docker_network.shared.name
  }
  env = [
    "DB_ENGINE=postgresql",
    "DB_HOST=db",
    "DB_NAME=app",
    "DB_USERNAME=app_user",
    "DB_PASS=app_pass",
    "DB_PORT=5432"
  ]
  ports {
    internal = 8000
    external = 8000
  }
}

resource "docker_container" "db" {
  name = "db"
  networks_advanced {
    name = docker_network.shared.name
  }
  image = docker_image.db.image_id
  env = [
    "POSTGRES_DB=app",
    "POSTGRES_USERNAME=app_user",
    "POSTGRES_PASSWORD=app_pass"
  ]
}
