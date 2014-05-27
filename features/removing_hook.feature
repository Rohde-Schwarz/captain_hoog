Feature: Removing a Git hook with the gem
  In order to remove an installed hook
  As developer
  I want to remove the hook with the script

  Scenario: Not having a Git repository
    Given I am in a directory that isnt a Git repository
    When I run the remove script with "pre-commit" type flag
    Then it should fail with:
      """
      I can't detect a Git repository
      """

  Scenario Outline: Having a Git repository and removing a hook
    Given I am in a directory that is a Git repository
    And a "<Hook>" is present
    And I run the remove script with "<Hook>" type flag
    Then it should pass with:
      """
      The <Hook> hook is removed.
      """
    And a "<Hook>" hook file did not exists

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
