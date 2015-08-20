Feature: Pull a plugin repository into the treasury
  In order to use plugins from a global location
  As a developer
  I want to add plugins to the treasury

  Background:
    Given I run the init script with a custom home path

  Scenario: Pulling an existing repository
    Given I pull a plugin repository into the treasury
    Then the repository is installed in the treasury
