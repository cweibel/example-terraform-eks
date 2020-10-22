locals {
    login_cf_template = "templates/login_cf.tpl"
    login_cf_output_file = "login_cf.sh"
}



data "template_file" "login_cf_template" {
  template = "${file("./${local.login_cf_template}")}"

  vars = {
    cluster_name = local.cluster_name
    system_domain = local.system_domain
  }
}


resource "local_file" "local_file_login_cf" {
    content     = data.template_file.login_cf_template.rendered
    filename    = "${local.artifact_folder}/${local.login_cf_output_file}"
}

