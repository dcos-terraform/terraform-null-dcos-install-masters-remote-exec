output "depends" {
  description = "Modules are missing the depends_on feature. Faking this feature with input and output variables"
  value       = "${join(",", flatten(list(null_resource.master1.*.id,null_resource.master2.*.id,null_resource.master3.*.id,null_resource.master4.*.id,null_resource.master5.*.id,null_resource.master6.*.id,null_resource.master7.*.id,null_resource.master8.*.id,null_resource.master9.*.id)))}"
}
