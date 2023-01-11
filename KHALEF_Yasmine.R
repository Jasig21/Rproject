###MAILS 
timothee.giraud@cnrs.fr
hugues.pecout@cnrs.fr

library('sf')
library('mapsf')
#install.packages('maptiles')
library(maptiles)

##getwd()
##setwd("/Users/geographie/Documents/R/geomatique_cartographie/Rproject")

################################################################################
# Importer les couches d’information et les cartographier (4 points)
################################################################################ 

#Vérification du contenu du geopackage
st_layers("data/dvf.gpkg")

com <- st_read("data/dvf.gpkg", layer="com")
route <- st_read("data/dvf.gpkg", layer="route")
rail <- st_read("data/dvf.gpkg", layer="rail")
parc <- st_read("data/dvf.gpkg", layer="parc")
dvf <- st_read("data/dvf.gpkg", layer="dvf")


head(com)
head(route)
head(rail)
head(parc)
head(dvf)

#Le modèle cartographique sera composé des couches com, route, rail et parc
#L'information statistique est présente dans la couche dvf qui représente les 
#demandes de valeurs foncières géolocalisées

#Fond de carte
custom <- list(
  name = "custom",
  bg = "black",
  fg = "#b6bf0a",
  mar = c(2, 2, 2, 2),
  tab = TRUE,
  pos = "center",
  inner = TRUE,
  line = 2,
  cex = 1.5,
  font = 3
)
mf_theme(custom)

mf_init(x = com, expandBB = c(0,0,0,0))

plot(st_geometry(route), col="#616161", lwd=0.5, border = "red", add = TRUE)
plot(st_geometry(rail), col="#616161", lwd=2, add = TRUE)
plot(st_geometry(parc), col="#3482125e", lwd=1, add = TRUE)
plot(st_geometry(com), col=NA, lwd=2, border = "white", add = TRUE)

mf_map(
	x = dvf, 
  	var = "prix",
	col = "#ec5b4b",
	cex = 0.1,
	add = TRUE
)



# Titre
mf_title(
  	txt = "Les ventes d'appartements à Vincennes et Montrueil (2016 - 2021)", 
  	pos = "right", 
  	tab = TRUE, 
  	bg = "grey", 
  	fg = "black", 
  	cex = 1, 
  	line = 1.2, 
  	font = 1, 
  	inner = TRUE
)


#Flèche du Nord
mf_arrow(pos = "topleft", col = "grey")

#Echelle
mf_scale(
	size = 500,
	pos = "bottomright", 
	lwd = 1.5, 
	cex = 0.6, 
	col = "grey", 
	unit = "m"
)

#Credits
mf_credits(
  txt = "Auteur : KHALEF Yasmine, 2023\nBD CARTO, IGN, 2021\n© les contributeurs d'OpenStreetMap, 2021\nDemandes de valeurs foncières géolocalisées, Etalab, 2021",
  col = "grey",
)


###TODO
##style du tutre
##Etiquettes commune
##export
##couleur des routes


################################################################################
# Carte des prix de l’immobilier (4 points)
################################################################################ 





# Justification de la discrétisation (statistiques, boxplot, histogramme, 
# beeswarm...)





################################################################################ 
# Prix de l’immobilier dans le voisinnage de la Mairie de Montreuil (4 points)
################################################################################ 






cat(paste0("Le prix de l'immobilier dans un voisinnage de 500 mètres ",
           "autour de la mairie de Montreuil est de ", 
           round(value, 0), 
           " euros par m²"))





################################################################################ 
# Utilisation d’un maillage régulier (4 points)
################################################################################ 

# Créer une grille régulière avec st_make_grid()

# Transformer la grille en objet sf avec st_sf()

# Ajouter un identifiant unique, voir chapitre 3.7.6
# dans https://rcarto.github.io/geomatique_avec_r/

# Compter le nombre de transaction dans chaque carreau, voir chapitre 3.7.7 
# dans https://rcarto.github.io/geomatique_avec_r/

# Calculez le prix median par carreau, voir chapitre 3.7.8
# dans https://rcarto.github.io/geomatique_avec_r/
# st_intersection(), aggregate(), merge()

# Selectionner les carreaux ayant plus de 10 transactions, voir chapitre 3.5
# dans https://rcarto.github.io/geomatique_avec_r/


# Justification de la discrétisation (statistiques, boxplot, histogramme, 
# beeswarm...)









