terraform {
    required_providers {
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "2.6.1"
        }
    }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "example" {
    metadata {
        name = "my-namespace"
    }
}

resource "kubernetes_deployment" "example" {
    metadata {
        name      = "my-deployment"
        namespace = kubernetes_namespace.example.metadata[0].name
    }

    spec {
        replicas = 3

        selector {
            match_labels = {
                app = "my-app"
            }
        }

        template {
            metadata {
                labels = {
                    app = "my-app"
                }
            }

            spec {
                container {
                    image = "nginx:latest"
                    name  = "my-container"
                }
            }
        }
    }
}
