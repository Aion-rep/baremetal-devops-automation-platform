resource "kubernetes_namespace_v1" "devops_automation" {
  metadata {
    name = "devops-automation"

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "project"                      = "baremetal-devops-automation-platform"
    }
  }
}

resource "kubernetes_service_account_v1" "jenkins_deployer" {
  metadata {
    name      = "jenkins-deployer"
    namespace = kubernetes_namespace_v1.devops_automation.metadata[0].name

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "jenkins-deployer"
      "project"                      = "baremetal-devops-automation-platform"
    }
  }
}

resource "kubernetes_role_v1" "jenkins_deployer" {
  metadata {
    name      = "jenkins-deployer-role"
    namespace = kubernetes_namespace_v1.devops_automation.metadata[0].name

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "jenkins-deployer"
      "project"                      = "baremetal-devops-automation-platform"
    }
  }

  rule {
    api_groups = [""]

    resources = [
      "pods",
      "services",
      "configmaps",
      "persistentvolumeclaims"
    ]

    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "patch",
      "delete"
    ]
  }

  rule {
    api_groups = [""]

    resources = [
      "pods/log"
    ]

    verbs = [
      "get"
    ]
  }

  rule {
    api_groups = ["apps"]

    resources = [
      "deployments",
      "replicasets"
    ]

    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "patch",
      "delete"
    ]
  }

  rule {
    api_groups = ["batch"]

    resources = [
      "jobs"
    ]

    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "patch",
      "delete"
    ]
  }

  rule {
    api_groups = ["networking.k8s.io"]

    resources = [
      "ingresses",
      "networkpolicies"
    ]

    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "patch",
      "delete"
    ]
  }
}



resource "kubernetes_role_binding_v1" "jenkins_deployer" {
  metadata {
    name      = "jenkins-deployer-binding"
    namespace = kubernetes_namespace_v1.devops_automation.metadata[0].name

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "jenkins-deployer"
      "project"                      = "baremetal-devops-automation-platform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.jenkins_deployer.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.jenkins_deployer.metadata[0].name
    namespace = kubernetes_namespace_v1.devops_automation.metadata[0].name
  }
}
