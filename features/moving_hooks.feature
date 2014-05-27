Feature: Moving a Git hook with the gem to another hook type
  In order to move an installed hook to another hook type
  As developer
  I want to move the hook with the script

  Scenario: Not having a Git repository
    Given I am in a directory that isnt a Git repository
    When I run the move script with "pre-commit" from flag and "pre-push" to flag
    Then it should fail with:
      """
      I can't detect a Git repository
      """

  Scenario Outline: Having a Git repository and moving a hook
    Given I am in a directory that is a Git repository
    And a "<From>" is present
    And I run the move script with "<From>" from flag and "<To>" to flag
    Then it should pass with:
      """
      The <From> hook is moved to <To> hook
      """
    And a "<To>" hook file exists
    And a "<From>" hook file did not exists

    Examples:
      |From             | To             |
      | pre-commit      | pre-push       |
      | pre-push        | pre-rebase     |
      | pre-rebase      | post-update    |
      | post-update     | commit-msg     |
      | commit-msg      | applypatch-msg |
      | applypatch-msg  | post-update    |
      | post-update     | pre-applypatch |
      | pre-applypatch  | pre-commit     | 
