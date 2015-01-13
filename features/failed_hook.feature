Feature: Having a hook plugin that fails
  In order to have a commit to take place
  As developer that did something wrong
  I want to see that the hook test failed

  Scenario: Running a unsuccessful commit test
    When I run `ruby pre-commit-fail`
    Then it should fail with:
      """
      Commit failed. See errors below.

      The test failed in with_git. Prevent you from doing anything.
      """
    And the exit status should be 1
