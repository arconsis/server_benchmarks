################################################################################
# ALB Definition
################################################################################
resource "aws_alb" "this" {
  name               = var.alb_name
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.security_groups
  subnets            = var.subnet_ids
  tags               = {
    Name = "${var.alb_name}-server-benchmarks-alb"
    Role = var.internal ? "internal" : "external"
  }
}

################################################################################
# ALB HTTP Listener Definition
################################################################################
resource "aws_alb_listener" "http_tcp" {
  count = length(var.http_tcp_listeners)

  load_balancer_arn = aws_alb.this.arn
  port              = var.http_tcp_listeners[count.index]["port"]
  protocol          = var.http_tcp_listeners[count.index]["protocol"]

  dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [var.http_tcp_listeners[count.index]]

    # Defaults to forward action if action_type not specified
    content {
      type = lookup(default_action.value, "action_type", "fixed-response")

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [
          lookup(default_action.value, "fixed_response", {})
        ]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }
    }
  }
}
