provider "google" {
  project     = "devproject-348110"
  region      = "us-central1"
  zone        = "us-central1-c"
  credentials = file("devproject.json")
}