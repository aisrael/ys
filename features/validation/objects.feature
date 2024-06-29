Feature: Object types

  Scenario: object type
    Given a YAML schema:
      ```
      type: object
      ```
    Then it should accept:
      ```
      key: value
      another_key: another_value
      ```
    And it should accept:
      ```
      Sun: 1.9891e30
      Jupiter: 1.8986e27
      Saturn: 5.6846e26
      Neptune: 10.243e25
      Uranus: 8.6810e25
      Earth: 5.9736e24
      Venus: 4.8685e24
      Mars: 6.4185e23
      Mercury: 3.3022e23
      Moon: 7.349e22
      Pluto: 1.25e22
      ```
    # Unlike JSON, YAML allows numeric keys, which are treated as strings
    And it should accept:
      ```
      0.01: cm
      1: m
      1000: km
      ```
    But it should NOT accept:
      ```
      "Not an object"
      ```
    And it should NOT accept:
      ```
      ["An", "array", "not", "an", "object"]
      ```

  Scenario: object type with properties
    Given a YAML schema:
      ```
      type: object
      properties:
        number:
          type: number
        street_name:
          type: string
        street_type:
          enum: [Street, Avenue, Boulevard]
      ```
    Then it should accept:
      ```
      number: 1600
      street_name: Pennsylvania
      street_type: Avenue
      ```
    # If we provide the number in the wrong type, it is invalid:
    But it should NOT accept:
      ```
      number: "1600"
      street_name: Pennsylvania
      street_type: Avenue
      ```
    # By default, leaving out properties is valid
    And it should accept:
      ```
      number: 1600
      street_name: Pennsylvania
      ```

  Scenario: Required properties
    Given a YAML schema:
      ```
      type: object
      properties:
        name:
          type: string
        email:
          type: string
        address:
          type: string
        telephone:
          type: string
      required: [name, email]
      ```
    Then it should accept:
      ```
      name: William Shakespeare
      email: bill@stratford-upon-avon.co.uk
      ```
    # Providing extra properties is fine, even properties not defined in the schema:
    And it should accept:
      ```
      name: William Shakespeare
      email: bill@stratford-upon-avon.co.uk
      address: Henley Street, Stratford-upon-Avon, Warwickshire, England
      authorship: in question
      ```
    # Missing the required "email" property makes the YAML document invalid:
    But it should NOT accept:
      ```
      name: William Shakespeare
      address: Henley Street, Stratford-upon-Avon, Warwickshire, England
      ```
    # A property with a null value is considered not being present:
    And it should NOT accept:
      ```
      name: William Shakespeare
      address: Henley Street, Stratford-upon-Avon, Warwickshire, England
      email: null
      ```
  Scenario: Additional properties
    Given a YAML schema:
      ```
      type: object
      properties:
        number:
          type: number
        street_name:
          type: string
        street_type:
          enum: [Street, Avenue, Boulevard]
      additionalProperties: false
      ```
    Then it should accept:
      ```
      number: 1600
      street_name: Pennsylvania
      street_type: Avenue
      ```
    # Since additionalProperties is false, an extra property "direction" makes the object invalid:
    But it should NOT accept:
      ```
      number: 1600
      street_name: Pennsylvania
      street_type: Avenue
      direction: NW
      ```
