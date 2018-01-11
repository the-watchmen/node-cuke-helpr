Feature: test
  Background:
    Given the following initial state:
    """
    {
      data: [
        {_id: constants.ONE},
        {_id: '2'}
      ]
    }
    """

  Scenario: index
    When we HTTP GET '/'
    Then our HTTP response should be like:
    """
    [
      {_id: constants.ONE},
      {_id: '2'}
    ]
    """

  Scenario: index with query
    When we HTTP GET '/' with query 'foo=bar'
    Then our HTTP response should be like:
    """
    [
      {_id: constants.ONE},
      {_id: '2'}
    ]
    """

  Scenario: get
    When we HTTP GET '/${constants.ONE}'
    Then our HTTP response should have status code 200
    And our HTTP headers should include 'x-powered-by'
    And our HTTP response should be like:
    """
    {_id: '1'}
    """

  Scenario: get non-existent
    When we HTTP GET '/nope'
    Then our HTTP response should have status code 404

  Scenario: create
    When we HTTP POST "/" with body:
    """
    {_id: '3'}
    """
    Then our HTTP response should have status code 201
    And our resultant state should be like:
    """
    {
      data: [
        {_id: '1'},
        {_id: '2'},
        {_id: '3'}
      ]
    }
    """

  Scenario: update
    When we HTTP PUT '/2' with body:
    """
    {_id: '2', name: 'two'}
    """
    Then our HTTP response should have status code 204
    And our resultant state should be like:
    """
    {
      data: [
        {},
        {_id: '2', name: 'two'}
      ]
    }
    """

  Scenario: patch
    When we HTTP PATCH '/2' with body:
    """
    {name: 'two'}
    """
    Then our HTTP response should have status code 204
    And our resultant state should be like:
    """
    {
      data: [
        {},
        {_id: '2', name: 'two'}
      ]
    }
    """

  Scenario: update non-existent client
    When we HTTP PUT '/nope' with body:
    """
    {foo: 'bar'}
    """
    Then our HTTP response should have status code 404

  Scenario: delete
    When we HTTP DELETE '/1'
    Then our HTTP response should have status code 204
    And our resultant state should be like:
    """
    {
      data: [
        {_id: '2'}
      ]
    }
    """

  Scenario: delete non-existent
    When we HTTP DELETE '/nope'
    Then our HTTP response should have status code 404

  Scenario: jwt
    Given we set the following JWT claims with secret "listener.auth.secret":
    """
    {
      preferred_username: 'tony-k',
      given_name: 'tony',
      family_name: 'kerz',
      email: 'anthony.kerz@gmail.com'
    }
    """
    When we HTTP GET "/user"
    Then our HTTP response should be like:
    """
    {
      preferred_username: 'tony-k',
      given_name: 'tony',
      family_name: 'kerz',
      email: 'anthony.kerz@gmail.com'
    }
    """

  Scenario: user
    Given we set the following HTTP headers:
    """
    {
      authorization: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ0b255LWsiLCJnaXZlbl9uYW1lIjoidG9ueSIsImZhbWlseV9uYW1lIjoia2VyeiIsImVtYWlsIjoiYW50aG9ueS5rZXJ6QGdtYWlsLmNvbSIsImlhdCI6MTUxNTcwNDg5Nn0.blPuhpCd_AK7XhRJnT7Te-R-uCHUCvN3eSNPNZzE3iI'
    }
    """
    When we HTTP GET "/user"
    Then our HTTP response should be like:
    """
    {
      preferred_username: 'tony-k',
      given_name: 'tony',
      family_name: 'kerz',
      email: 'anthony.kerz@gmail.com'
    }
    """



  Scenario: external
    When we HTTP GET 'http://github.com'
    Then our HTTP response should have status code 200
