# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
- creating reverse translation while editing
- ExMachina factories

### Modified
- Accounts context with tests
- Tasks context with tests
- Sessions context with tests
- Positions context with tests
- Translations context with tests
- uniquness for Example, Translation and Sentence

## [0.2.2] - 2019-01-20
### Added
- Users controller, templates
- plug to check email confirmation
- Translations controller, templates
- render/edit existed translations
- create new translations

## [0.2.1] - 2019-01-06
### Added
- Session model

### Modified
- sessions
- session belongs to user after signin/signup
- styles

## [0.2.0] - 2019-01-05
### Added
- user creation by signup
- user mailer with confirmation email
- confirmation process
- alerts block
- signout process
- signin process
- presenter for validation errors
- dashboard page with auth check for access
- authorization policies system with dashboard policy

## [0.1.0] - 2019-01-01
### Added
- background job for task file handling
- saving sentences and translations
- reusing translations
- render result file for downloading

## [0.0.3] - 2018-12-08
### Added
- tasks rendering for main page
- controller action tasks#detection for locale autodetection
- custom 404 and 500 pages
- tasks context
- RoomChannel for updating tasks

### Modified
- styles for main page
- controller action page#index
- file uploading

### Fixed
- new task request from vue component

## [0.0.2] - 2018-12-04
### Added
- controller action page#index, with tests
- controller action tasks#create, with tests
- file uploader for tasks
- CHANGELOG.md
