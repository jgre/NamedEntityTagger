Feature: Tag named entities
  As a reader
  I want named entities to be automatically tagged
  So that I can see and edit additional information

  Scenario: A text is submitted for tagging
    Given the text "Mrs. Schmidt drives to Copenhagen on Monday. Acme Inc. doesn't care."
    When tagging is requested
    Then I should get "Mrs. <span class="person">Schmidt</span> drives to <span class="location">Copenhagen</span> on <span class="date">Monday</span>. <span class="organization">Acme Inc.</span> doesn't care."