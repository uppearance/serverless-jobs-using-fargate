######################### Role used by the container
resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.project}_ecs_service_role_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_assume_role_policy.json}"
}

resource "aws_iam_role_policy" "ecs_service_policy" {
  name   = "${var.project}_ecs_service_role_policy_${var.env}"
  policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
  role   = "${aws_iam_role.ecs_service_role.id}"
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
        "iam:ListPolicies",
        "iam:GetPolicyVersion"
    ]
  }
}

data "aws_iam_policy_document" "ecs_service_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

######################### Role used for ECS Events

resource "aws_iam_role" "ecs_events_role" {
  name               = "${var.project}_ecs_events_role_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_events_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_events_role_policy" {
  policy_arn = "${data.aws_iam_policy.ecs_events_policy.arn}"
  role       = "${aws_iam_role.ecs_events_role.id}"
}

data "aws_iam_policy" "ecs_events_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

data "aws_iam_policy_document" "ecs_events_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

