resource "aws_db_subnet_group" "db-group" {
    name = "${var.db-name}-grp"
    subnet_ids = [var.db-5-1a-id,var.db-6-1b-id]
}
resource "aws_db_instance" "my-db" {
    identifier = "my-db"
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    allocated_storage = 20
    username = var.db-username
    password = var.db-password
    db_name = var.db-name
    multi_az = true
    storage_type = "gp2"
    storage_encrypted = false
    publicly_accessible = false
    skip_final_snapshot = true  
    backup_retention_period = 0
    vpc_security_group_ids = [var.db-tier-sg-id]
    db_subnet_group_name = aws_db_subnet_group.db-group.name
    tags = {
      Name = "my-db"
    }
}