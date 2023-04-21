resource "aws_instance" "test-server" {
  ami           = "ami-0c768662cc797cd75" 
  instance_type = "t2.micro" 
  key_name = "bhem"
  vpc_security_group_ids= ["sg-09865566f5f0fa10a"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./bhem.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
		}
  provisioner "local-exec" {
  command = " ansible-playbook /var/lib/jenkins/workspace/bankproject/deployments/bankplaybook.yml "
  } 
}
