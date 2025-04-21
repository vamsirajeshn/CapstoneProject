resource "aws_lb" "bg_alb" {
  name               = "blue-green-alb-r"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.bg_subnet.id, aws_subnet.bg_subnet_2.id]
  security_groups    = [aws_security_group.bg_web_sg.id]
}

resource "aws_lb_target_group" "bg_blue_tg" {
  name     = "blue-target-group-r"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bg_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "bg_blue_attach" {
  target_group_arn = aws_lb_target_group.bg_blue_tg.arn
  target_id        = aws_instance.bg_blue.id
  port             = 80
}

resource "aws_lb_target_group" "bg_green_tg" {
  name     = "green-target-group-r"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bg_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "bg_green_attach" {
  target_group_arn = aws_lb_target_group.bg_green_tg.arn
  target_id        = aws_instance.bg_green.id
  port             = 80
}

resource "aws_lb_listener" "bg_front_end" {
  load_balancer_arn = aws_lb.bg_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bg_blue_tg.arn
  }
}
