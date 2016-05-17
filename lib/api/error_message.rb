module API
  module ErrorMessage
    ERROR_CODES = {
        'API_AUTH_FAILED'            => '-101',
        'AUTH_TOKEN_FAILED'          => '-102',
        'BLANK_SHOP_DATA'            => '-103',
        'INTERNAL_ISSUE'             => '-104',
        'SHOP_ALREADY_EXIST'         => '-105',
        'LATITUTE_OUT_OF_RANGE'      => '-106',
        'LONGITUTE_OUT_OF_RANGE'     => '-107',
        'INVALID_AUTH_TOKEN'         => '-108',
        'BLANK_USER_DATA'            => '-109',
        'USER_ALREADY_EXISTS'        => '-110',
        'WRONG_PASSWORD_LENGTH'      => '-111',
        'WRONG_GENDER_FORMAT'        => '-112',
        'WRONG_DATE_FORMAT'          => '-113',
        'USER_CREATED'               => '-114',
        'BLANK_EMAIL_PASSWORD'       => '-115',
        'INVALID_EMAIL_PASSWORD'     => '-116',
        'SHOP_NOT_EXIST'             => '-117',
        'BLANK_PRIVILEGE_DATA'       => '-118',
        'PRIVILEGE_ALREADY_EXISTS'   => '-119',
        'PRIVILEGE_NOT_EXISTS'       => '-120',
        'BLANK_ROLE_DATA'            => '-121',
        'ROLE_ALREADY_EXISTS'        => '-122',
        'ROLE_NOT_EXISTS'            => '-123'
    }

    ERROR_MESSAGES = {
        '-101' => 'API authentication failed.',
        '-102' => 'Invaid authentication.',
        '-103' => 'Shop data is blank.',
        '-104' => 'Internal issue occurred',
        '-105' => 'Shop details already exist. Please provide another shop details.',
        '-106' => 'Latitute is out of range, please provide valid latitute.',
        '-107' => 'Longitute is out of range, please provide valid longitute.',
        '-108' => 'Authentication token is invalid. Please provide valid authentication token.',
        '-109' => 'User data is blank.',
        '-110' => 'User already registered with this email id.',
        '-111' => 'Password should be in between range of 7 to 21',
        '-112' => 'Gender should be <M> or <male> and <F> or <female>.',
        '-113' => 'Date should be in ths format (13/01/2010).',
        '-114' => 'User successfully created.',
        '-115' => 'Email or Password field is blank.',
        '-116' => 'Invalid email or password.',
        '-117' => 'Shop is not available.',
        '-118' => 'Privilege data is blank.',
        '-119' => 'Privilege already exists.',
        '-120' => 'Privilege not exists.',
        '-121' => 'Role data is blank.',
        '-122' => 'Role already exists.',
        '-123' => 'Role not exists.'
    }
  end
end