output "depends" {
  description = "modules are missing the depends_on feature. Faking this feature with input and output variables"
  value       = "${element(null_resource.master1.*.id,1)}"
}
