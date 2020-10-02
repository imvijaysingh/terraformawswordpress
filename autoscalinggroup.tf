resource "aws_autoscaling_group" "wordpress" {
  availability_zones = ["ap-south-1"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
}
