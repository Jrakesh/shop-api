module API
  module ErrorMessage
    ERROR_CODES = {
        'API_AUTH_FAILED' => '-101',
        'AUTH_TOKEN_FAILED' => '-102',
        'BLANK_SHOP_DATA' => '-103',
        'INTERNAL_ISSUE' => '-104',
        'SHOP_ALREADY_EXIST' => '-105'
    }

    ERROR_MESSAGES = {
        '-101' => 'API authentication failed.',
        '-102' => 'Invaid authentication',
        '-103' => 'Shop data is blank.',
        '-104' => 'Internal issue occurred',
        '-105' => 'Shop details already exist. Please provide another shop details.'
    }
  end
end