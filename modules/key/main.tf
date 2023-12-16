resource "aws_key_pair" "tier" {
    key_name = "tier"
    public_key = file("../modules/key/tier.pub")
}   

