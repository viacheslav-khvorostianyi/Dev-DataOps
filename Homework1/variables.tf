variable "gsp_region" {
    description = "region for GSP deployment"
    type        = string
    default     = "europe-central2"
}

variable "project_id" {
    description = "GCP project ID"
    type        = string
    default = "quickstart-1571836766309"
}

variable "zone" {
    description = "GCP zone"
    type        = string
    default     = "europe-central2-a"
}