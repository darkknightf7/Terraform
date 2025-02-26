resource "aws_vpc_endpoint" "client-pathfinder-s3-vpc-endpoint" {

  vpc_id       = "vpc-321312"

  service_name = "com.amazonaws.us-east-1.s3"

  vpc_endpoint_type = "Gateway"

  route_table_ids = ["rtb-1121213"]

}

resource "aws_vpc_endpoint_policy" "client-pathfinder-s3-vpc-endpoint-policy" {

  vpc_endpoint_id = aws_vpc_endpoint.client-pathfinder-s3-vpc-endpoint.id

  policy = jsonencode({

    "Version": "2008-10-17",

	"Statement": [

		{

			"Effect": "Allow",

			"Principal": "*",

			"Action": "s3:*",

			"Resource": [

				"arn:aws:s3:::client-pathfinder-internal-bucket/*",

				"arn:aws:s3:::client-pathfinder-internal-bucket",

				"arn:aws:s3:::client-pathfinder-external-bucket",

				"arn:aws:s3:::client-pathfinder-external-bucket/*"

			]

		}

	]

  })

}
