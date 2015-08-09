Feature: Init a Captain Hoog environment
  In order to bootstrap a Captain Hoog environment
  As a developer
  I want to init the environment with a init script

  Background:
    Given I run the init script with a custom home path

  Scenario: Not having the environment bootstraped before
    Then the init script outputs "Initializing treasury"
    Then it should create a .hoog directory
    And inside the .hoog directory a treasury directory exists

  Scenario: Having the environment already bootstrapped
    Given I run the init script with a custom home path
    Then the init script outputs "Treasury already exists. Skipping."
