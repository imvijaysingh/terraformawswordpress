# Generates RSA Keypair
resource "tls_private_key" "mycloudkey1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save Private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.mycloudkey1.private_key_pem
  filename = "mycloudkey1.pem"
}

# Upload public key to create keypair on AWS
resource "aws_key_pair" "mycloudkey1" {
  key_name   = "webserver"
  public_key = tls_private_key.mycloudkey1.public_key_openssh
}
