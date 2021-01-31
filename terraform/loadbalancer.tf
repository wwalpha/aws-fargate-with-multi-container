# ----------------------------------------------------------------------------------------------
# Application Load Balancer - Public
# ----------------------------------------------------------------------------------------------
resource "aws_lb" "public" {
  name               = "onecloud-multi-container"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.vpc_security_groups
  subnets            = var.public_subnet_ids
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Target Group - Multi Container
# ----------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "multi_container" {
  name        = "onecloud-multi-container-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

# ----------------------------------------------------------------------------------------------
# Load Balancer Listener - Multi Container
# ----------------------------------------------------------------------------------------------
resource "aws_lb_listener" "multi_container" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.multi_container.arn
  }
}
