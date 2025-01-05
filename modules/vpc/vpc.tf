# Fargateコンテナが動作する仮想環境(ホスト数: 65,536)
resource "aws_vpc" "main_vpc" {
  // CIDR範囲
  cidr_block = "10.0.0.0/16"
  // VPCでDNSサポート 有効/無効 (デフォルト: 有効)
  enable_dns_support = true
  // VPCでDNSホスト名 有効/無効 (デフォルト: 有効)
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.envname}-${var.systemid}"
    Module_Name = var.module_name
    Application = var.systemid
  }
}

# API Gateway用 VPC エンドポイント
resource "aws_vpc_endpoint" "vpc-endpoint-apigw" {
  // vpcエンドポイントが所属するvpcid
  vpc_id = aws_vpc.main_vpc.id
  // APIGateway用サービス名
  service_name = "com.amazonaws.${var.region}.execute-api"

  // エンドポイントにアタッチするポリシー (デフォルト: フルアクセス)
  // policy = jsonencode({ Version: "2012-10-17" })

  // サービスのリージョン
  service_region = var.region

  // VPCエンドポイントタイプ
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "vpced-${var.envname}-${var.systemid}"
    Module_Name = var.module_name
    Application = var.systemid
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "public-subnet-1-${var.envname}"
    Module_Name = var.module_name
    Application = var.systemid
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "public-subnet-2-${var.envname}"
    Module_Name = var.module_name
    Application = var.systemid
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "private-subnet-1-${var.envname}"
    Module_Name = var.module_name
    Application = var.systemid
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "private-subnet-2-${var.envname}"
    Module_Name = var.module_name
    Application = var.systemid
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "igw-${var.envname}"
    Module_Name = var.module_name
    Application = var.systemid
  }
}