resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  tags                             = merge(var.tags, { Name = var.name })
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { Name = "Default Security Group" })
}

locals {
  vpc_public_cidr_block  = cidrsubnet(var.cidr, 1, 0)
  vpc_private_cidr_block = cidrsubnet(var.cidr, 1, 1)

  # Max number of subnets per type (private/public)
  max_subnets = 3

  limited_azs_list = local.max_subnets < length(var.azs) ? slice(var.azs, 0, local.max_subnets) : var.azs


  public_azs  = var.enable_public_subnets ? { for index, az in local.limited_azs_list : az => index } : {}
  private_azs = { for index, az in local.limited_azs_list : az => index }

  eips = var.single_nat_gateway ? { for k, v in local.public_azs : k => v if k == local.limited_azs_list[0] } : local.public_azs
}


resource "aws_subnet" "public" {
  for_each          = local.public_azs
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.vpc_public_cidr_block, ceil(log(local.max_subnets, 2)), each.value)
  ipv6_cidr_block   = null
  availability_zone = each.key
  tags              = merge(var.tags, var.public_subnet_tags, tomap({ "Name" = format("%sPublic-%s", var.name, each.key) }))

  map_public_ip_on_launch = true
}


resource "aws_subnet" "private" {
  for_each          = local.private_azs
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.vpc_private_cidr_block, ceil(log(local.max_subnets, 2)), each.value)
  ipv6_cidr_block   = null
  availability_zone = each.key
  tags              = merge(var.tags, var.private_subnet_tags, tomap({ "Name" = format("%sPrivate-%s", var.name, each.key) }))
}


resource "aws_eip" "nateip" {
  vpc = true
  # count = length(var.azs) * (var.enable_nat_gateway ? 1 : 0)
  for_each = var.enable_internet_gateway && var.enable_nat_gateway ? local.eips : {}
  tags     = merge(var.tags, tomap({ "Name" = format("%s-%s-NAT-EIP", var.name, each.key) }))

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_internet_gateway.vpc]
}

resource "aws_internet_gateway" "vpc" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

resource "aws_nat_gateway" "natgw" {
  for_each      = var.enable_internet_gateway && var.enable_nat_gateway ? local.eips : {}
  allocation_id = aws_eip.nateip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = merge(var.tags, tomap({ "Name" = format("%s-%s-NAT-GW", var.name, each.key) }))
}

resource "aws_route" "public_internet_gateway" {
  for_each               = var.enable_internet_gateway ? local.public_azs : {}
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = one(aws_internet_gateway.vpc[*].id)
}


resource "aws_route" "private_nat_gateway" {
  for_each               = local.private_azs
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.natgw[keys(local.eips)[0]].id : aws_nat_gateway.natgw[each.key].id
}

resource "aws_route_table" "public" {
  for_each = local.public_azs
  vpc_id   = aws_vpc.vpc.id
  tags     = merge(var.tags, { Name = format("%sPublic-%s", var.name, each.key) })
}

# for each of the private ranges, create a "private" route table.
resource "aws_route_table" "private" {
  for_each = local.private_azs
  vpc_id   = aws_vpc.vpc.id
  tags     = merge(var.tags, { Name = format("%sPrivate-%s", var.name, each.key) })
}


resource "aws_route_table_association" "private" {
  for_each       = local.private_azs
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_azs
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}
