module "tnlinc" {
  source                = "./modules/tnlinc"
  vpc_id                = aws_vpc.vpc.id
  app_name              = var.app_name
  alb_subnet_ids        = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  controller_subnet_ids = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}