# Install OpenEdx juniper
## Requirement System
- Ubuntu 16.04 amd64 (only support -- juniper or early)
- Minimum 8GB of memory
- At least one 2.00GHz CPU or EC2 compute unit
- Minimum 25GB of free disk, 50GB recommended for production servers
Note: For hosting in Amazon we recommend an t2.large with at least a 50Gb EBS volume, see https://aws.amazon.com/ec2/pricing. Community Ubuntu AMIs have 8GB on the root directory, make sure to expand it before installing.
## Set up Environment
Set the OPENEDX_RELEASE variable. You choose the version of software by setting the OPENEDX_RELEASE variable before running the commands
[Edx Releases](https://edx.readthedocs.io/projects/edx-developer-docs/en/latest/named_releases.html#juniper)
```
export OPENEDX_RELEASE=open-release/juniper.2
```

