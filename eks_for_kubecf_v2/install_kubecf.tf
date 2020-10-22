
locals {
    install_kubecf_template = "templates/install_kubecf.tpl"
    install_kubecf_output_file = "install_kubecf.sh"
    artifact_folder = "artifacts"
}


data "template_file" "install_kubecf_template" {
  template = "${file("./${local.install_kubecf_template}")}"

  vars = {
    cluster_name = local.cluster_name
    system_domain = local.system_domain
  }
}


resource "local_file" "local_file_install_kubecf" {
    content     = data.template_file.install_kubecf_template.rendered
    filename    = "${local.artifact_folder}/${local.install_kubecf_output_file}"
}




resource "null_resource" "export_rendered_install_kubecf_template" {

  # Force this resource to regenerate each time
  #triggers = {
  #  run_every_time = "${uuid()}"
  #}

  # No point in executing until the db is running
  depends_on = [module.eks, local_file.local_file_install_kubecf]

  provisioner "local-exec"  {
      command = "${local.artifact_folder}/${local.install_kubecf_output_file} "
  }
}
