SERVER_ADDRESS = "mt.matematicasuperpiatta.it"
--SERVER_ADDRESS = "0.0.0.0"
URL_GET = "http://"..SERVER_ADDRESS..":29999"

-- Mac OS-X
package.cpath = "./MS-client-minetest-5.01.app/Contents/Resources/share/Mac/?.so;" .. package.cpath
package.path = "./MS-client-minetest-5.01.app/Contents/Resources/share/Mac/?.lua;" .. package.path
-- Android
package.cpath = "./share/minetest/builtin/?.so;" .. package.cpath
package.path = "./share/minetest/builtin/?.lua;" .. package.path
package.cpath = "./share/minetest/builtin/socket/?.so;" .. package.cpath
package.path = "./share/minetest/builtin/socket/?.lua;" .. package.path

local http = require "socket.http"
local data = ""
local function collect(chunk)
	if chunk ~= nil then
		data = data .. chunk
		end
	return true
end
--Minetest
--Copyright (C) 2014 sapier
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

--------------------------------------------------------------------------------
local function get_formspec(tabview, name, tabdata)
	-- Update the cached supported proto info,
	-- it may have changed after a change by the settings menu.
	common_update_cached_supp_proto()
	local fav_selected = nil
	if menudata.search_result then
		fav_selected = menudata.search_result[tabdata.fav_selected]
	else
		fav_selected = menudata.favorites[tabdata.fav_selected]
	end

	if not tabdata.search_for then
		tabdata.search_for = ""
	end

	local retval =
		-- Search
--		"field[0.15,0.075;5.91,1;te_search;;" .. core.formspec_escape(tabdata.search_for) .. "]" ..
--		"button[5.62,-0.25;1.5,1;btn_mp_search;" .. fgettext("Search") .. "]" ..
--		"image_button[6.97,-.165;.83,.83;" .. core.formspec_escape(defaulttexturedir .. "refresh.png")
--			.. ";btn_mp_refresh;]" ..
		"image[-0.20,1.8;4.5,4.5;" .. core.formspec_escape(defaulttexturedir .. "cubes.png").."]"..
		"image[8.80,1.5;3.0,3.0;" .. core.formspec_escape(defaulttexturedir .. "univaq_block_image_small.png").."]"..
--		"image[4.3,-3.6.0;4.3,2.9;" .. core.formspec_escape(defaulttexturedir .. "street_science.png").."]"..
--		"image[9.40,3.95;1.8,1.8;" .. core.formspec_escape(defaulttexturedir .. "stemblocks_logo_small.png").."]"..
		-- Address / Port
		"label[4.35,0.6;" .. fgettext("MATEMATICA SUPERPIATTA ") .. "]" ..
		"label[4.00,1.3;" .. fgettext("UN VIDEOGIOCO PER LA SCUOLA") .. "]" ..
		"label[8.1,4.5;" .. fgettext("Università degli Studi dell'Aquila") .. "]" ..
		"label[5.75,5.1;" .. fgettext("per informazioni: matematicasuperpiatta@gmail.com") .. "]" ..
--		"field[6,0.75;4.70,0.5;te_address;;" ..
--			core.formspec_escape(core.settings:get("address")) .. "]" ..
--		"field[11.1,0.75;1.4,0.5;te_port;;" ..
--			core.formspec_escape(core.settings:get("remote_port")) .. "]" ..
		-- Name / Password
--		"label[3.75,1.05;" .. fgettext("Nome                                                      Password") .. "]" ..
--		"field[3.75,1.95;3.75,0.5;te_name;;" ..
--			core.formspec_escape(core.settings:get("name")) .. "]" ..
--		"pwdfield[7.78,1.95;1.77,0.5;te_pwd;]" ..

		-- Description Background
--		"box[7.73,2.25;4.25,2.6;#999999]"..

		-- Connect
		"button[5.00,2.6;2.3,1;btn_mp_connect;" .. fgettext("Inizia") .. "]"

	if tabdata.fav_selected and fav_selected then
		if gamedata.fav then
			retval = retval .. "button[7.73,4.9;2.3,1;btn_delete_favorite;" ..
				fgettext("Del. Favorite") .. "]"
		end
		if fav_selected.description then
			retval = retval .. "textarea[8.1,2.3;4.23,2.9;;;" ..
				core.formspec_escape((gamedata.serverdescription or ""), true) .. "]"
		end
	end

	--favourites
		retval = retval
--	retval = retval .. "tablecolumns[" ..
--		image_column(fgettext("Favorite"), "favorite") .. ";" ..
--		image_column(fgettext("Ping")) .. ",padding=0.25;" ..
--		"color,span=3;" ..
--		"text,align=right;" ..                -- clients
--		"text,align=center,padding=0.25;" ..  -- "/"
--		"text,align=right,padding=0.25;" ..   -- clients_max
--		image_column(fgettext("Creative mode"), "creative") .. ",padding=1;" ..
--		image_column(fgettext("Damage enabled"), "damage") .. ",padding=0.25;" ..
--		image_column(fgettext("PvP enabled"), "pvp") .. ",padding=0.25;" ..
--		"color,span=1;" ..
--		"text,padding=1]" ..
--		"table[-0.15,0.6;7.75,5.15;favourites;"

	if menudata.search_result then
		for i = 1, #menudata.search_result do
			local favs = core.get_favorites("local")
			local server = menudata.search_result[i]

			for fav_id = 1, #favs do
				if server.address == favs[fav_id].address and
						server.port == favs[fav_id].port then
					server.is_favorite = true
				end
			end

			if i ~= 1 then
				retval = retval .. ","
			end

			retval = retval .. render_serverlist_row(server, server.is_favorite)
		end
	elseif #menudata.favorites > 0 then
		local favs = core.get_favorites("local")
		if #favs > 0 then
			for i = 1, #favs do
			for j = 1, #menudata.favorites do
				if menudata.favorites[j].address == favs[i].address and
						menudata.favorites[j].port == favs[i].port then
					table.insert(menudata.favorites, i, table.remove(menudata.favorites, j))
				end
			end
				if favs[i].address ~= menudata.favorites[i].address then
					table.insert(menudata.favorites, i, favs[i])
				end
			end
		end
		retval = retval .. render_serverlist_row(menudata.favorites[1], (#favs > 0))
		for i = 2, #menudata.favorites do
			retval = retval .. "," .. render_serverlist_row(menudata.favorites[i], (i <= #favs))
		end
	end

	if tabdata.fav_selected then
		retval = retval .. ";" .. tabdata.fav_selected .. "]"
	else
		retval = retval .. ";0]"
	end

	return retval
end

--------------------------------------------------------------------------------
local function main_button_handler(tabview, fields, name, tabdata)
	local serverlist = menudata.search_result or menudata.favorites

--	if fields.te_name then
		gamedata.playername = 'test'
		core.settings:set("name", 'test')
--	end

	if fields.favourites then
		local event = core.explode_table_event(fields.favourites)
		local fav = serverlist[event.row]

		if event.type == "DCL" then
			if event.row <= #serverlist then
				if menudata.favorites_is_public and
						not is_server_protocol_compat_or_error(
							fav.proto_min, fav.proto_max) then
					return true
				end

--				gamedata.address    = fav.address
--				gamedata.port       = fav.port
--  GET PORT NUMBER BY HTTP REQUEST
				local ok, statusCode, headers, statusText = http.request {
					method = "GET",
					url = URL_GET,
					sink = collect
				}
				print("ok\t", ok)
				print("statusCode", statusCode)
				print("statusText", statusText)
				print("headers:")
				print("data", data)
				gamedata.address = SERVER_ADDRESS
				gamedata.port       = data
--  GET PORT NUMBER BY HTTP REQUEST

				gamedata.playername = 'test'
				gamedata.selected_world = 0

--				if fields.te_pwd then
					gamedata.password = ""
--				end

				gamedata.servername        = fav.name
				gamedata.serverdescription = fav.description

				if gamedata.address and gamedata.port then
					core.settings:set("address", gamedata.address)
					core.settings:set("remote_port", gamedata.port)
					core.start()
				end
			end
			return true
		end

		if event.type == "CHG" then
			if event.row <= #serverlist then
				gamedata.fav = false
				local favs = core.get_favorites("local")
				local address = fav.address
				local port    = fav.port
				gamedata.serverdescription = fav.description

				for i = 1, #favs do
					if fav.address == favs[i].address and
							fav.port == favs[i].port then
						gamedata.fav = true
					end
				end

				if address and port then
					core.settings:set("address", address)
					core.settings:set("remote_port", port)
				end
				tabdata.fav_selected = event.row
			end
			return true
		end
	end

	if fields.key_up or fields.key_down then
		local fav_idx = core.get_table_index("favourites")
		local fav = serverlist[fav_idx]

		if fav_idx then
			if fields.key_up and fav_idx > 1 then
				fav_idx = fav_idx - 1
			elseif fields.key_down and fav_idx < #menudata.favorites then
				fav_idx = fav_idx + 1
			end
		else
			fav_idx = 1
		end

		if not menudata.favorites or not fav then
			tabdata.fav_selected = 0
			return true
		end

		local address = fav.address
		local port    = fav.port
		gamedata.serverdescription = fav.description
		if address and port then
			core.settings:set("address", address)
			core.settings:set("remote_port", port)
		end

		tabdata.fav_selected = fav_idx
		return true
	end

	if fields.btn_delete_favorite then
		local current_favourite = core.get_table_index("favourites")
		if not current_favourite then return end

		core.delete_favorite(current_favourite)
		asyncOnlineFavourites()
		tabdata.fav_selected = nil

		core.settings:set("address", "ms.matematicasuperpiatta.it")
		core.settings:set("remote_port", "30000")
		return true
	end

	if fields.btn_mp_search or fields.key_enter_field == "te_search" then
		tabdata.fav_selected = 1
		local input = fields.te_search:lower()
		tabdata.search_for = fields.te_search

		if #menudata.favorites < 2 then
			return true
		end

		menudata.search_result = {}

		-- setup the keyword list
		local keywords = {}
		for word in input:gmatch("%S+") do
			word = word:gsub("(%W)", "%%%1")
			table.insert(keywords, word)
		end

		if #keywords == 0 then
			menudata.search_result = nil
			return true
		end

		-- Search the serverlist
		local search_result = {}
		for i = 1, #menudata.favorites do
			local server = menudata.favorites[i]
			local found = 0
			for k = 1, #keywords do
				local keyword = keywords[k]
				if server.name then
					local name = server.name:lower()
					local _, count = name:gsub(keyword, keyword)
					found = found + count * 4
				end

				if server.description then
					local desc = server.description:lower()
					local _, count = desc:gsub(keyword, keyword)
					found = found + count * 2
				end
			end
			if found > 0 then
				local points = (#menudata.favorites - i) / 5 + found
				server.points = points
				table.insert(search_result, server)
			end
		end
		if #search_result > 0 then
			table.sort(search_result, function(a, b)
				return a.points > b.points
			end)
			menudata.search_result = search_result
			local first_server = search_result[1]
			core.settings:set("address",     first_server.address)
			core.settings:set("remote_port", first_server.port)
			gamedata.serverdescription = first_server.description
		end
		return true
	end

	if fields.btn_mp_refresh then
		asyncOnlineFavourites()
		return true
	end


--	if (fields.btn_mp_connect or fields.key_enter)
--			and fields.te_address ~= "" and fields.te_port then
	if (fields.btn_mp_connect or fields.key_enter) then

		gamedata.playername = 'test'
		gamedata.password   = ''
--		gamedata.address    = fields.te_address
--		gamedata.port       = fields.te_port
--  GET PORT NUMBER BY HTTP REQUEST - START
		local ok, statusCode, headers, statusText = http.request {
			method = "GET",
			url = URL_GET,
			sink = collect
		}
		print("ok\t",         ok)
		-- print("url", url)
		print("statusCode", statusCode)
		print("statusText", statusText)
		print("headers:")
		print("data", data)
		gamedata.address = SERVER_ADDRESS
		gamedata.port       = data
--  GET PORT NUMBER BY HTTP REQUEST - END

		gamedata.selected_world = 0
		local fav_idx = core.get_table_index("favourites")
		local fav = serverlist[fav_idx]

		if fav_idx and fav_idx <= #serverlist and
				fav.address == fields.te_address and
				fav.port    == fields.te_port then

			gamedata.servername        = fav.name
			gamedata.serverdescription = fav.description

			if menudata.favorites_is_public and
					not is_server_protocol_compat_or_error(
						fav.proto_min, fav.proto_max) then
				return true
			end
		else
			gamedata.servername        = ""
			gamedata.serverdescription = ""
		end

--		core.settings:set("address",     fields.te_address)
--		core.settings:set("remote_port", fields.te_port)
		core.settings:set("address",     "")
		core.settings:set("remote_port", "")

		core.start()
		return true
	end
	return false
end

local function on_change(type, old_tab, new_tab)
	if type == "LEAVE" then return end
	asyncOnlineFavourites()
end

--------------------------------------------------------------------------------
return {
	name = "online",
	caption = fgettext("Join Game"),
	cbf_formspec = get_formspec,
	cbf_button_handler = main_button_handler,
	on_change = on_change
}
