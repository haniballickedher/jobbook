fx_version 'cerulean'

game "rdr3"
author 'Hannibal_Lickedher'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
	'c.lua',
	
}

shared_scripts {
	'config.lua',

}

server_scripts {
	's.lua',
	'@oxmysql/lib/MySQL.lua'
}
