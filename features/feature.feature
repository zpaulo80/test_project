Feature: Feature Example

  @TEST_ID_1
Scenario: passing scenario
  Given true

  @TEST_ID_2
  Scenario: failure scenario
    Given false

  @TEST_ID_3
  Scenario: pending scenario
    Given pending