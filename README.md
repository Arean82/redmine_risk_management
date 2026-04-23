# Redmine Risk Management

V0.0.6 (23-Apr-2026)

Risk management is a plugin for [Redmine](http://www.redmine.org/) (a project management web application), allows to manage the risks for a given project.

This is a fork of [redmine_risk_management](https://github.com/imaginary-cloud/redmine_risk_management) 

## Installation

1. Download tarball
2. `cd {redmine_root}/plugins/`
3. `mkdir redmine_risk_management`
4. Extract files to {redmine_root}/plugins/redmine_risk_management/
5. `rake redmine:plugins:migrate NAME=redmine_risk_management RAILS_ENV={Environment}`

## How to use

First, you can create a custom status by going to the plugin administration page.

![redmine_rm_risks screenshot](https://github.com/Arean82/redmine_risk_management/blob/master/Screenshot_risks.png)

To create a risk for a project you need to click on the Risks tab under the project detail page. 


![redmine_rm_status screenshot](https://github.com/Arean82/redmine_risk_management/blob/master/Screenshot_status.png)

## Features

- Create and manage risks for each project
- Customizable risk statuses with color coding
- Link existing issues to risks
- Create new issues directly from a risk
- Search and add issues to risks
- Remove issues from risks
- Permission-based access control for managing risk-issue links

## Keywords

Risk Management, Risk, Impact, Management, Redmine, Plugin

## Support

Support will only be given to the following versions or above:

* Redmine version                5.1.x
* Ruby version                   3.1.2p20
* Rails version                  6.1.7.8

Note: I have tested this on Redmine v5.1.3

## Changelog

### Version 0.0.6 (23-Apr-2026)
- Added ability to link existing issues to risks
- Added search functionality to find and add issues to risks
- Added remove issue link from risk show page
- Added risk dropdown on issue edit form
- Added permission checks for managing risk-issue links

### Version 0.0.5 (11-Nov-2024)
- Initial fork

## License

Copyright © 2010-2018. This library is licensed under the MIT license.


