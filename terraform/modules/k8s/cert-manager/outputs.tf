output "crds_sha1" {
  value = null_resource.cert-manager-crds.triggers.manifest_sha1
}
