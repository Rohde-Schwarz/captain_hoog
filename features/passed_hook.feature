Feature: Having a hook plugin that passed
  In order to have a commit to take place
  As developer
  I want to see the hook test passed

  Scenario: Running a successful commit test
    When I run `ruby pre-commit-pass`
    Then it should pass with:
      """
      All tests passed. No reason to prevent the commit.
      """
    And the exit status should be 0
