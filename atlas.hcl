env "local" {
  src = "./schema.hcl"
  dev = "docker://mysql/8/dev"
  migration {
    dir = "file://migrations"
  }
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}

variable "cloud_token" {
  type    = string
  default = getenv("ATLAS_TOKEN")
}

atlas {
  cloud {
    token = var.cloud_token
  }
}

data "remote_dir" "migration" {
  name = "app"
}

env {
  name = atlas.env
  url  = getenv("DATABASE_URL")
  migration {
    dir = data.remote_dir.migration.url
  }
}
