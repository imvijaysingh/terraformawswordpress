resource "aws_autoscaling_group" "wordpress" {
  availability_zones = ["ap-south-1"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
}
