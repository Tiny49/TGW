provider "aws" {
  alias      = "mpa"
  access_key = var.AWS_ACCESS_KEY_ID_MPA
  secret_key = var.AWS_SECRET_ACCESS_KEY_MPA
  token      = var.AWS_SESSION_TOKEN_MPA
  region     = var.region
}
