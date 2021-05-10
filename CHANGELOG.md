# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [3.0.1] - 2021-05-10
## Added
- Update dependency to fix possible vulnerability.

## [3.0.0] - 2020-03-11
## Changed
- Add support for ruby 2.7
- Remove support for ruby < 2.3
- Change required version for gem heartcheck to fit for newer supported ruby versions

## [2.2.0] - 2019-10-17
## Changed
- Checks response body only if a `body_match` is defined

## [2.1.0] - 2018-11-29
## Added
- Custom implementation of Check#uri_info to provide webservices connectivity info

## [2.0.0] - 2017-10-11
## Changed
- Changed the default for open_timeout from 60s to 3s
- Changed the default for read_timeout from 60s to 5s
