resource "aws_resourcegroups_group" "project" {
  name     = "${lower(var.app_name)}-${var.app_env}-resource"

 resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Stage",
      "Values": ["Stage"]
    }
  ]
}
JSON
  }
}

resource "aws_ebs_volume" "projectstorage" {
  availability_zone        = var.project_storage_location
  type                     = var.project_storage_type
  size			               = var.project_storage_size

  tags = {
      Name = "${lower(var.app_name)}-${var.app_env}-volume"
      Env  = var.app_env
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name              = "/dev/sdh"
  volume_id                = aws_ebs_volume.projectstorage.id
  instance_id              = var.aws_ebs_volume_attach
}