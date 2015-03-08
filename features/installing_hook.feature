Feature: Installing a Git hook with the gem
  In order to use the plugin based Git hook
  As developer
  I want to run the install script

  Scenario: Not having a Git directory
    Given I am in a directory that isnt a Git repository
    When I run the install script with "pre-commit" type flag
    Then it should fail with:
      """
      I can't detect a Git repository
      """

  Scenario Outline: Having a Git repository and installing hook
    Given I am in a directory that is a Git repository
    When I run the install script with "<Hook>" type flag
    Then it should pass with:
      """
      Installed hook as <Hook> hook
      """
    And a "<Hook>" hook file exists
    And a hook config file exists
    And the config file includes the "plugins" directory
    And the config file includes the "project" directory

    Examples:
      | Hook |
      | pre-commit |
      | pre-push |
      | pre-rebase |
      | post-update |
      | commit-msg |
      | applypatch-msg |
      | post-update |
      | pre-applypatch |
