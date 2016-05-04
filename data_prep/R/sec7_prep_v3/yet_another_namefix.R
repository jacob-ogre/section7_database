# More name-fixing...
# Copyright (c) 2016 Defenders of Wildlife, jmalcom@defenders.org

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
# 


load("FWS_S7_clean_03May2016_0-3.RData")

z <- unlist(unlist(full$spp_ev_ls))
q <- sort(z)
w <- unique(q)

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Panther, Florida (Puma (=Felis) concolor coryi)",
                         replacement = "Panther, Florida (Puma concolor couguar)",
                         fixed = TRUE)

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Panther, Florida (Puma concolor coryi)",
                         replacement = "Panther, Florida (Puma concolor couguar)",
                         fixed = TRUE)
                    
full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "(=rattlesnake), eastern massasauga",
                         replacement = "Massasauga (=Rattlesnake), eastern",
                         fixed = TRUE)

grep("coryi", full$spp_ev_ls)
grep("=rattlesnake", full$spp_ev_ls)
                    
full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "bewicks|bewick\'s",
                         replacement = "Bewick's")

# Start here
full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "[Cc]ooks",
                         replacement = "Cook's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "clantons|clanton\'s",
                         replacement = "Clanton's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "florida",
                         replacement = "Florida")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Northern",
                         replacement = "northern")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "rafinesques|rafinesque\'s",
                         replacement = "Rafinesque's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Corynorhinus \\(=Plecotus\\) townsendii virginianus|Corynorhinus townsendii ingens",
                         replacement = "Corynorhinus townsendii virginianus")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Beargrass, Brittons \\(Nolina brittonia\\)",
                         replacement = "Beargrass, Brittons \\(Nolina brittoniana\\)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "america",
                         replacement = "America")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "american",
                         replacement = "American")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "gammons|gammon\'s",
                         replacement = "Gammon's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Cicindelidia",
                         replacement = "Cicindela")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "shorts|Shorts",
                         replacement = "Short's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "andersons|anderson\'s",
                         replacement = "Anderson's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "andersons|anderson\'s",
                         replacement = "Anderson's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Brunneus, urocitellus \\(Northern idaho ground squirrel\\)|Squirrel, northern idaho ground \\(Spermophilus brunneus brunneus\\)|Squirrel, northern idaho ground \\(Urocitellus brunneus\\)",
                         replacement = "Ground squirrel, northern Idaho (Urocitellus brunneus)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Buttercup, autumn \\(Ranunculus aestivalis \\(=acriformis\\)\\)|Buttercup, autumn \\(Ranunculus aestivalis\\(=acriformis\\)",
                         replacement = "Buttercup, autumn (Ranunculus aestivalis (=acriformis)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Butterfly, bay checkerspot \\(Euphydryas editha bayensis\\)|Butterfly, bay checkerspot \\(Euphydryas editha quino\\)",
                         replacement = "Butterfly, bay checkerspot (Euphydryas editha editha)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "barbaras|barbara\'s",
                         replacement = "Barbara's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "acuna",
                         replacement = "Acuna")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Cactus, Siler pincushion \\(Pediocactus sileri \\(=utahia\\)\\)",
                         replacement = "Cactus, Siler pincushion (Pediocactus sileri)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Caurina, strix occidentalis \\(Northern spotted owl\\)",
                         replacement = "Owl, northern spotted (Strix occidentalis caurina)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Chub, Virgin River \\(Gila seminuda\\(=robusta\\)",
                         replacement = "Chub, Virgin River (Gila seminuda (=robusta))")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Cliff-rose, Arizona \\(Purshia \\(=Cowania\\) subintegra\\)|Cliff-rose, Arizona \\(Purshia subintegra\\)",
                         replacement = "Cliff-rose, Arizona (Purshia X subintegra)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "septimas|septima\'s",
                         replacement = "Septima's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "brevidens florentina|brevidens perobliqua|brevidens rangiana|brevidens torulosa|brevidens walkeri \\(=E. walkeri\\)",
                         replacement = "brevidens")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Cookii, lomatium \\(Cook's lomatium\\)",
                         replacement = "Lomatium, Cook's (Lomatium cookii)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "oregon",
                         replacement = "Oregon")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "sierra nevada",
                         replacement = "Sierra Nevada")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "mexican",
                         replacement = "Mexican")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "texas",
                         replacement = "Texas")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Fleshy-fruit",
                         replacement = "fleshy-fruit")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "san diego",
                         replacement = "San Diego")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Grandiflora, limnanthes floccosa ssp. \\(Large-flowered woolly meadowfoam\\)",
                         replacement = "Meadowfoam, large-flowered woolly (Limanthes floccosa ssp. grandiflora")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "hirst brothers\'|hirst brothers",
                         replacement = "Hirst Brothers'")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Grindella fraxino-pratensis",
                         replacement = "Grindella fraxinipratensis")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "swainsons",
                         replacement = "Swainson's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Horribilis, ursus arctos \\(Grizzly bear\\)",
                         replacement = "Bear, grizzly (Ursus arctos horribilis)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "webber",
                         replacement = "Webber")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "stephensi\\(incl.\\)",
                         replacement = "stephensi")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Kincaidii, lupinus sulphureus ssp. \\(Kincaid's lupine\\)|Lupine, Kincaids \\(Lupinus oreganus var. kincaidii\\)",
                         replacement = "Lupine, Kincaid's (Lupinus sulphureus ssp. kincaidii)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Leucurus, odocoileus virginianus \\(Columbian white-tailed deer\\)",
                         replacement = "Deer, Columbian white-tailed (Odocoileus virginianus leucurus")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Levisecta, castilleja \\(Golden paintbrush\\)",
                         replacement = "Paintbrush, golden (Castilleja levisecta)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "sharps|sharp\'s",
                         replacement = "Sharp's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Cooks",
                         replacement = "Cook's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "N\\. trautmani",
                         replacement = "Noturus trautmani")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "N\\. flavipinnis",
                         replacement = "Noturus flavipinnis")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "N\\. crypticus",
                         replacement = "Noturus crypticus")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "N\\. placidus",
                         replacement = "Noturus placidus")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "N\\. stanauli",
                         replacement = "Noturus stanauli")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "torreys|torrey's",
                         replacement = "Torrey's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "torreys|torrey's",
                         replacement = "Torrey's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Mucket, Neosho - Neosho mucket|Mucket, neosho",
                         replacement = "Neosho")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Name, no common|No common name",
                         replacement = "No Common Name")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "no species defined|None",
                         replacement = "No species listed")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Occidentale, lilium \\(Western lily\\)",
                         replacement = "Lily, western (Lilium occidentale)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Owl, western burrowing \\(Athene cunicularia ssp. hypugaea\\)",
                         replacement = "Owl, western burrowing (Athene cunicularia hypugaea)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "spragues|sprague\'s",
                         replacement = "Sprague's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "rubra alabamensis",
                         replacement = "rubra ssp. alabamensis")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "cains|cain\'s",
                         replacement = "Cain's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "alexanders|alexander\'s",
                         replacement = "Alexander's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "jemez mountains",
                         replacement = "Jemez Mountains")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "salado",
                         replacement = "Salado")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "tennessee",
                         replacement = "Tennessee")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "pecos",
                         replacement = "Pecos")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "topeka \\(=tristis\\)|topeka \\(=tristis\\)\\)|topeka\\(=tristis\\)",
                         replacement = "topeka")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "dakota",
                         replacement = "Dakota")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "poweshiek",
                         replacement = "Poweshiek")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "bachmans|bachman\'s",
                         replacement = "Bachman's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "beldings|belding\'s",
                         replacement = "Belding's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Spectabilis, thelypodium howellii \\(Howell\'s spectacular thelypody\\)",
                         replacement = "Thelypody, Howell's spectacular (Thelypodium howellii spectabilis")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "tooth cave",
                         replacement = "Tooth Cave")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "idaho",
                         replacement = "Idaho")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = " 252\\.",
                         replacement = "")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "zuni",
                         replacement = "Zuni")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "eggerts|eggert\'s",
                         replacement = "Eggert's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "wrights|wright\'s",
                         replacement = "Wright's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "wrights|wright\'s",
                         replacement = "Wright's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "lecontes|leconte\'s",
                         replacement = "Leconte's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "yosemite",
                         replacement = "Yosemite")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "chus clarki selen",
                         replacement = "chus clarkii selen")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Pseudotryonia (=Tryonia)",
                         replacement = "Tryonia")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "cuthberts|cuthbert\'s",
                         replacement = "Cuthbert's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Kirtlands - Entire|Kirtlands",
                         replacement = "Kirtland's")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Warnerensis, catostomus \\(Warner sucker\\)",
                         replacement = "Sucker, Warner (Catostomus warnerensis)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "Whale, sperm \\(Physeter catodon \\(=macrocephalus\\)$",
                         replacement = "Whale, sperm (Physeter catodon (=macrocephalus))")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "congdonii\\)\\)",
                         replacement = "congdonii)")

full$spp_ev_ls <- lapply(full$spp_ev_ls,
                         FUN = gsub,
                         pattern = "radford\'s st\\. john\'s|radfords st\\. johns",
                         replacement = "Radford's St. John's")

z <- unlist(unlist(full$spp_ev_ls))
q <- sort(z)
w <- unique(q)
write.table(w, file="spp_names_fixed_maybe.tsv", sep="\t", quote=FALSE, row.names=FALSE)


save(full, file="FWS_S7_clean_03May2016_0-4.RData")

















