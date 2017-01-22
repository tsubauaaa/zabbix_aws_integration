AWS Integration for Zabbix
=============

## Description
This script and template can monitor AWS integrally with Zabbix.

## Features
1. CloudWatch Metrics Collecting  
Collect each metrics information and AWS billing information of CloudWatch in Zabbix.

2. AWS Health Dashboard Check  
Integrate information on [AWS Service Health Dashboard](http://status.aws.amazon.com/) into Zabbix and monitor the operation status of each service of AWS.

3. Auto Scaling Activity  
For environments where the AutoScaling function automatically reduces / extends the EC 2 instance, integrate that activity into Zabbix and monitor the number of reduced and extended instances.

4. RDS & ElastiCache Event Check  
Integrating and monitoring Event notifications from RDS and ElastiCache services to Zabbix.

5. CloudWatchLogs Filtering  
Filter the log file monitored by CloudWatchLogs with arbitrary words.

6. EC2 InstanceID Register  
When you monitor the EC 2 instance, it automatically registers the Instance ID in the user macros.

![features](http://cdn-ak.f.st-hatena.com/images/fotolife/t/tsubauaaa/20170122/20170122234219.png)

## Installation
1. Place files under [external_checks_scripts](https://github.com/tsubauaaa/zabbix_aws_integration/tree/master/external_checks_scripts) in  the location for external scripts of your zabbix server.

2. Import [template](https://github.com/tsubauaaa/zabbix_aws_integration/blob/master/templates/Template_AWS_Integration.xml) into your zabbix server.

3. Enter the value in your environment at template user macros.

## Contribution
* fork it
* develop you want
* create a pull-request !

## License
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

## Author
[tsubauaaa](https://github.com/tsubauaaa)
