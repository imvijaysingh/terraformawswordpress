resource "aws_autoscaling_group" "wordpress-asg" {
  availability_zones = ["ap-south-1"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  launch_configuration = "${aws_launch_configuration.wordpress-lc.name}"
}

resource "aws_launch_configuration" "wordpress-lc" {
    image_id                    = "ami-0e306788ff2473ccb"
    instance_type               = "t2.micro"
    user_data = "${file("userdata.sh")}"
    # Required to redeploy without an outage.
    lifecycle {
    create_before_destroy = true
  }
}
