module "compute" {
  source              = "../terraform-modules/vpc"
  cidr                = "10.0.0.0/16"
  azs                 = slice(data.aws_availability_zones.available.names, 0, 2)
  tags                = {}
  name                = "compute"
  public_subnet_tags  = { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = "1" }
  single_nat_gateway  = true
}
