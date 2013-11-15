Feature: Test command
  In order to run tests written with rspec
  As a user of Busser
  I want my tests to run when the rspec runner plugin is installed

  Background:
    Given a test BUSSER_ROOT directory named "busser-rspec-test"
    And a sandboxed GEM_HOME directory named "busser-rspec-gem-home"
    When I successfully run `busser plugin install busser-rspec --force-postinstall`
    Given a suite directory named "rspec"

  Scenario: A passing test suite
    Given a file in suite "rspec" named "default_spec.rb" with:
    """
    describe 'default' do
      it 'succeed' do
      end
    end
    """
    When I run `busser test rspec`
    Then the output should contain:
    """
    1 example, 0 failures
    """
    And the exit status should be 0

  Scenario: A failing test suite
    Given a file in suite "rspec" named "default_spec.rb" with:
    """
    describe 'default' do
      it 'fail' do
        raise
      end
    end
    """
    When I run `busser test rspec`
    Then the output should contain:
    """
    1 example, 1 failure
    """
    And the exit status should not be 0
