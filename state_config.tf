terraform {
  backend "s3" {
    bucket = "tf.remote.state"
  }
}