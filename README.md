## Prerequisites

### Huaweicloud

* Create an Huaweicloud project/tenant
* Create a network
  * Connect the network with a router to your external network
* Allocate a EIP
* Allow ssh access in the `default` security group
* Create a key pair by executing
```bash
$ ssh-keygen -t rsa -b 4096 -N "" -f cf-validator.rsa_id
```
  * Upload the generated public key to OpenStack as `cf-validator`

* import cf-validator key pair in huaweicloud 


