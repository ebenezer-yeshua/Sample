resource "aws_lb" "loadbalancer-1" {
   name                       = "${lower(var.app_name)}-${lower(var.app_env)}-lb"
   internal                   = false
   load_balancer_type         = var.aws_loadbalancer_type
   security_groups            = [var.aws_instance_security_group]
   subnets                    = [for subnet in var.aws_instance_subnet : subnet.id]  
   enable_deletion_protection = true

 tags = {
    Environment = var.app_env
  }
}
resource "aws_lb_target_group" "lb-tg-1" {
    name                      = "${lower(var.app_name)}-${lower(var.app_env)}-lb-tg"
    port                      = 80
    protocol                  = "HTTP"
    vpc_id                    = var.aws_instance_vpc_id
    health_check {
        path                  = "/var/www/html/index.html"
        port                  = 80
        protocol              = "HTTP"
    }
}
resource "aws_lb_target_group_attachment" "lb-tg-at-1" {
  target_group_arn            = aws_lb_target_group.lb-tg-1.arn
  target_id                   = var.aws_intance_id
  port                        = 80
  depends_on = [ 
    aws_lb_target_group.lb-tg-1,
    var.aws_intance_name
   ]
}
resource "aws_lb_listener" "lb_listener-1" {
  load_balancer_arn           = aws_lb.loadbalancer-1.arn
  port                        = 80
  protocol                    = "HTTP"
  default_action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.lb-tg-1.arn
  }
}
