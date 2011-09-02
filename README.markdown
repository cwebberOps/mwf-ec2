# EC2/fog/MWF Proof of Concept

This is a proof of concept on getting UCLA MWF deployed to an ec2 instance in nothing more than a single script. 

## Requirements
fog gem >= 0.11.0
.fog setup with AWS credentials

## Instructions
Run mwfup.rb to create a new instance on ec2 and apply the mwf puppet module.

## Notes
You will need to manually destroy thie instance and the newly created security group mwf-http
