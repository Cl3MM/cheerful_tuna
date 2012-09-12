class ChangeCountriesAndCategoryTypeForEmailListing < ActiveRecord::Migration
  def up
    remove_index  :email_listings, :countries
    change_column :email_listings, :countries, :text
    change_column :email_listings, :categories, :text
  end

  def down
    change_column :email_listings, :countries, :string
    change_column :email_listings, :categories, :string
  end
end




Mysql2::Error: You have an error in your SQL syntax; check the manual that
corresponds to your MySQL server version for the right syntax to use near
'Ivoire','Croatia','Cuba','Curacao','Cyprus','Czech
Republic','Denmark','Djibouti' at line 1: 

"SELECT emails.address FROM `contacts`
LEFT JOIN `emails` ON contacts.id = emails.contact_id WHERE ( contacts.country
                                                             in
                                                             ('Afghanistan','Aland
Islands','Albania','Algeria','American
Samoa','Andorra','Angola','Anguilla','Antarctica','Antigua And
Barbuda','Argentina','Armenia','Aruba','Australia','Austria','Azerbaijan','Bahamas','Bahrain','Bangladesh','Barbados','Belarus','Belgium','Belize','Benin','Bermuda','Bhutan','Bolivia','Bo','Afghanistan','Aland
Islands','Albania','Algeria','American
Samoa','Andorra','Angola','Anguilla','Antarctica','Antigua And
Barbuda','Argentina','Armenia','Aruba','Australia','Austria','Azerbaijan','Bahamas','Bahrain','Bangladesh','Barbados','Belarus','Belgium','Belize','Benin','Bermuda','Bhutan','Bolivia','Bosnia
and Herzegowina','Botswana','Bouvet Island','Brazil','British Indian Ocean
Territory','Brunei Darussalam','Bulgaria','Burkina
Faso','Burundi','Cambodia','Cameroon','Canada','Cape Verde','Cayman
Islands','Central African Republic','Chad','Chile','China','Christmas
Island','Cocos (Keeling) Islands','Colombia','Comoros','Congo','Congo, the
Democratic Republic of the','Cook Islands','Costa Rica','Cote
d\'Ivoire','Croatia','Cuba','Curacao','Cyprus','Czech
Republic','Denmark','Djibouti','Dominica','Dominican
Republic','Ecuador','Egypt','El Salvador','Equatorial
Guinea','Eritrea','Estonia','Ethiopia','Falkland Islands (Malvinas)','Faroe
Islands','Fiji','Finland','France','French Guiana','French Polynesia','French
Southern
Territories','Gabon','Gambia','Georgia','Germany','Ghana','Gibraltar','Greece','Greenland','Grenada','Guadeloupe','Guam','Guatemala','Guernsey','Guinea','Guinea-Bissau','Guyana','Haiti','Heard
and McDonald Islands','Holy See (Vatican City State)','Honduras','Hong
Kong','Hungary','Iceland','India','Indonesia','Iran, Islamic Republic
of','Iraq','Ireland','Isle of
Man','Israel','Italy','Jamaica','Japan','Jersey','Jordan','Kazakhstan','Kenya','Kiribati','Korea,
  Democratic People's Republic of','Korea, Republic
of','Kuwait','Kyrgyzstan','Lao People's Democratic
Republic','Latvia','Lebanon','Lesotho','Liberia','Libyan Arab
Jamahiriya','Liechtenstein','Lithuania','Luxembourg','Macao','Macedonia, The
Former Yugoslav Republic
Of','Madagascar','Malawi','Malaysia','Maldives','Mali','Malta','Marshall
Islands','Martinique','Mauritania','Mauritius','Mayotte','Mexico','Micronesia,
  Federated States of','Moldova, Republic
of','Monaco','Mongolia','Montenegro','Montserrat','Morocco','Mozambique','Myanmar','Namibia','Nauru','Nepal','Netherlands','New
Caledonia','New Zealand','Nicaragua','Niger','Nigeria','Niue','Norfolk
Island','Northern Mariana
Islands','Norway','Oman','Pakistan','Palau','Palestinian Territory,
  Occupied','Panama','Papua New
Guinea','Paraguay','Peru','Philippines','Pitcairn','Poland','Portugal','Puerto
Rico','Qatar','Reunion','Romania','Russian Federation','Rwanda','Saint
Barthelemy','Saint Helena','Saint Kitts and Nevis','Saint Lucia','Saint Pierre
and Miquelon','Saint Vincent and the Grenadines','Samoa','San Marino','Sao Tome
and Principe','Saudi Arabia','Senegal','Serbia','Seychelles','Sierra
Leone','Singapore','Sint Maarten','Slovakia','Slovenia','Solomon
Islands','Somalia','South Africa','South Georgia and the South Sandwich
Islands','Spain','Sri Lanka','Sudan','Suriname','Svalbard and Jan
Mayen','Swaziland','Sweden','Switzerland','Syrian Arab Republic','Taiwan,
  Province of China','Tajikistan','Tanzania, United Republic
of','Thailand','Timor-Leste','Togo','Tokelau','Tonga','Trinidad and
  Tobago','Tunisia','Turkey','Turkmenistan','Turks and Caicos
Islands','Tuvalu','Uganda','Ukraine','United Arab Emirates','United
Kingdom','United States','United States Minor Outlying
Islands','Uruguay','Uzbekistan','Vanuatu','Venezuela','Viet Nam','Virgin
Islands, British','Virgin Islands, U.S.','Wallis and Futuna','Western
Sahara','Yemen','Zambia','Zimbabwe') AND contacts.category NOT LIKE 'Sénat%'
AND contacts.is_active )
"
