/*
 * This file is part of RemoteGS, which is a GameScript for OpenTTD
 * Original ServerGS Copyright (C) 2012-2013  Leif Linse
 * Forked RemoteGS Copyright (C) 2020-2024 Ian Earle
 *
 * RemoteGS is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * RemoteGS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with RemoteGS; If not, see <http://www.gnu.org/licenses/> or
 * write to the Free Software Foundation, Inc., 51 Franklin Street, 
 * Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

require("version.nut");

class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Ian Earle"; }
	function GetName()			{ return "RemoteGS"; }
	function GetDescription() 	{ return "This GS gives admin port clients access to the GS API"; }
	function GetVersion()		{ return SELF_VERSION; }
	function GetDate()			{ return SELF_PUBLISH_DATE; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "ReGS"; }
	function GetAPIVersion()	{ return "1.3"; }
	function GetURL()			{ return "https://github.com/BasicBeluga/RemoteGS"; }

	function GetSettings() {
		AddSetting({name = "show_error_dialogs",
				description = "Show API errors in a GUI dialog displayed for all companies (but not spectators)",
				easy_value = 0,
				medium_value = 0,
				hard_value = 0,
				custom_value = 0,
				flags = CONFIG_INGAME | CONFIG_BOOLEAN});

		AddSetting({name = "log_level", 
				description = "Debug: Log level (higher = print more)", 
				easy_value = 3,
				medium_value = 3,
				hard_value = 3,
				custom_value = 3,
				flags = CONFIG_INGAME, min_value = 1, max_value = 3});
		AddLabels("log_level", {_1 = "1: Info", _2 = "2: Verbose", _3 = "3: Debug" } );
	}
}

RegisterGS(FMainClass());
