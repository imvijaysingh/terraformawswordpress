###### Generate RSA public and private key-pair by tls_private_key resource and also encodes it as PEM. local_file -> Save private key in EC2 system
###### This will help in connecting via ssh.

resource "tls_private_key" "devopskey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save Private key locally
resource "local_file" "private_key" {
  content  = "tls_private_key.devopskey.private_key_pem"
  filename = "devops.pem"
}

# Upload public key to create keypair on AWS
resource "aws_key_pair" "devops" {
  key_name   = "webserver"
  public_key = "tls_private_key.devops.public_key_openssh"
}
