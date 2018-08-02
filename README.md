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
  * Upload the generated public key to HuaweiCLoud as `cf-validator`

* import cf-validator key pair in huaweicloud 


* change validator.template.yml to validator.yml  and use your own value instead of <replace-me> in validator.yml

## run

 ./validate --stemcell bosh-stemcell-3541.10-openstack-kvm-ubuntu-trusty-go_agent.tgz --config validator.yml

