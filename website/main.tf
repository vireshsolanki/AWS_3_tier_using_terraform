module "vpc" {
    source = "../modules/vpc"
    region = var.region
    project-name = var.project-name
    vpc-cidr = var.vpc-cidr
    public-1-1a-cidr = var.public-1-1a-cidr
    public-2-1b-cidr = var.public-2-1b-cidr
    private-3-1a-cidr = var.private-3-1a-cidr
    private-4-1b-cidr = var.private-4-1b-cidr
    db-5-1a-cidr = var.db-5-1a-cidr
    db-6-1b-cidr = var.db-6-1b-cidr
}
module "natgateway" {
    source = "../modules/natgateway"
    vpc-id = module.vpc.vpc-id
    igw-id = module.vpc.igw-id
    public-1-1a-id = module.vpc.public-1-1a-id
    public-2-1b-id = module.vpc.public-2-1b-id
    private-3-1a-id = module.vpc.private-3-1a-id
    private-4-1b-id = module.vpc.private-4-1b-id
    db-5-1a-id = module.vpc.db-5-1a-id
    db-6-1b-id = module.vpc.db-6-1a-id
}
module "sg" {
    source = "../modules/sg"
    vpc-id = module.vpc.vpc-id
}
module "key" {
  source = "../modules/key"
}
module "internalalb" {
    source = "../modules/internalalb"
    project-name = var.project-name
    vpc-id = module.vpc.vpc-id
    private-3-1a-id = module.vpc.private-3-1a-id
    private-4-1b-id = module.vpc.private-4-1b-id
    alb-internal-sg-id = module.sg.alb-internal-sg-id
}
module "apptierasg" {
    source = "../modules/apptierasg"
    project-name = var.project-name
    key-name = module.key.key-name
    app-tier-sg-id = module.sg.app-tier-sg-id
    private-3-1a-id = module.vpc.private-3-1a-id
    private-4-1b-id = module.vpc.private-4-1b-id
    tg-arn = module.internalalb.tg-arn
}
module "dbtier" {
    source = "../modules/dbtier"
    db-username = var.db-username
    db-password = var.db-password
    db-tier-sg-id = module.sg.db-tier-sg-id
    db-5-1a-id = module.vpc.db-5-1a-id
    db-6-1b-id = module.vpc.db-6-1a-id
}
module "internet-alb" {
    source = "../modules/internetalb"
    certificate-dn = var.certificate-dn
    project-name = var.project-name
    alb-internet-sg-id = module.sg.alb-internet-sg-id
    public-1-1a-id = module.vpc.public-1-1a-id
    public-2-1b-id = module.vpc.public-2-1b-id
    vpc-id = module.vpc.vpc-id
}
module "webtierasg" {
  source = "../modules/webtierasg"
  project-name = var.project-name
  key-name = module.key.key-name
  web-tier-sg-id = module.sg.web-tier-sg-id
  public-1-1a-id = module.vpc.public-1-1a-id
  public-2-1b-id = module.vpc.public-2-1b-id
  tg-internet-arn = module.internet-alb.tg-internet-arn
}
module "cloudfront" {
    source = "../modules/cloudfront"
    additional-domain-name = var.additional-domain-name
    alb-internet-dns = module.internet-alb.alb-internet-dns
    project-name = var.project-name
    certificate-dns = module.internet-alb.certificate-dns
  
}
module "route53" {
    source = "../modules/route53"
    cloudfront-dns = module.cloudfront.cloudfront-dns
    cloudfront-hosted-zone-id = module.cloudfront.cloudfront-hosted-zone-id
}