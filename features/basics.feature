Feature: Basic YAML schema

  Scenario: Empty YAML
    Given a YAML schema:
      ```
      ```

    Then it should accept:
      ```
      42
      ```
    And it should accept:
      ```
      "I'm a string"
      ```
    And it should accept:
      ```
      an:
        - arbitrarily
        - nested
      data: structure
      ```

  Scenario: `true` should accept anything
    Given a YAML schema:
      ```
      true
      ```

    Then it should accept:
      ```
      42
      ```
    And it should accept:
      ```
      "I'm a string"
      ```
    And it should accept:
      ```
      an:
        - arbitrarily
        - nested
      data: structure
      ```

  Scenario: `false` should reject anything
    Given a YAML schema:
      ```
      false
      ```

    Then it should NOT accept:
      ```
      42
      ```
    And it should NOT accept:
      ```
      "I'm a string"
      ```
    And it should NOT accept:
      ```
      an:
        - arbitrarily
        - nested
      data: structure
      ```

  Scenario: "type: string" should accept strings
    Given a YAML schema:
      ```
      type: string
      ```

    Then it should accept:
      ```
      "I'm a string"
      ```
    Then it should NOT accept:
      ```
      42
      ```
    And it should NOT accept:
      ```
      an:
        - arbitrarily
        - nested
      data: structure
      ```