###MAILS 
timothee.giraud@cnrs.fr
hugues.pecout@cnrs.fr

library('sf')
library('mapsf')
#install.packages('maptiles')
library(maptiles)

setwd("/Users/geographie/Documents/R/geomatique_cartographie/Rproject")

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

#Préparation de l'export
mf_export(com, "carte1.png", 
          width = 800,
	    height = 900,
	    expandBB = rep(0, 0)
)


#Theme personnalisé
custom <- list(
  name = "custom",
  bg = "black",
  fg = "white",
  tab = TRUE,
  pos = "center",
  inner = TRUE,
  line = 2,
  cex = 1.5,
  font = 3
)
mf_theme(custom)

mf_init(x = com, expandBB = c(0,0,0,0))

plot(st_geometry(route), col="#454545", lwd=0.5, border = "red", add = TRUE)
plot(st_geometry(rail), col="#454545", lwd=2, add = TRUE)
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
  	txt = "Les ventes d'appartements à Vincennes et Montreuil (2016 - 2021)", 
  	pos = "right", 
  	tab = TRUE, 
  	bg = "#b8c3d9", 
  	fg = "black", 
  	cex = 1, 
  	line = 1.2, 
  	font = 4, 
  	inner = TRUE
)

#Flèche du Nord
mf_arrow(pos = "topleft", col = "#b8c3d9")

#Echelle
mf_scale(
	size = 500,
	pos = "bottomright", 
	lwd = 1.5, 
	cex = 0.6, 
	col = "#b8c3d9", 
	unit = "m"
)

#Credits
mf_credits(
  txt = "Auteur : KHALEF Yasmine, 2023\nBD CARTO, IGN, 2021\n© les contributeurs d'OpenStreetMap, 2021\nDemandes de valeurs foncières géolocalisées, Etalab, 2021",
  col = "#b8c3d9",
)

#Labels
mf_label(
  x = com,
  var = "NOM",
  col= "white",
  halo = TRUE,
  overlap = FALSE, 
  lines = FALSE
)

dev.off()

###TODO
##export


################################################################################
# Carte des prix de l’immobilier (4 points)
################################################################################ 

# Justification de la discrétisation (statistiques, boxplot, histogramme, 
# beeswarm...)

prix <- dvf$prix
summary(prix) #la moyenne et la médianne sont proches
hist(prix) #la distribution est sous forme de courbe de Gauss 
boxplot(prix) #Il n'y a pas de valeurs abérrantes

##La distribution étant normale, on opte pour une discrétisation à amplitude
#égale afin d'avoir la possibilité de choisir facilement le nombre de classes 
#qu'on souhaite représenter  

mf_init(x = com, expandBB = c(0.1,0,0.1,0))
mf_theme(custom)

plot(st_geometry(route), col="#454545", lwd=0.5, border = "red", add = TRUE)
plot(st_geometry(rail), col="#454545", lwd=2, add = TRUE)
plot(st_geometry(com), col=NA, lwd=2, border = "white", add = TRUE)

d <- mf_get_breaks(dvf$prix, breaks = "msd", central = FALSE)

mypal <- mf_get_pal(n = c(2,4), palette = c("Teal", "SunsetDark"), rev = c(FALSE, FALSE))

mf_map(
  x = dvf,
  var = "prix",
  type = "choro",
  breaks = d,
  pal = mypal,
  cex = 0.2,
  lwd = 0,
  leg_pos = "bottomright",
  leg_title = "Prix au mètre carré (€)", 
  add = TRUE
)

# Titre
mf_title(
  	txt = "Prix des appartements à Vincennes et à Montreuil (2016 - 2021)", 
  	pos = "right", 
  	tab = TRUE, 
  	bg = "#b8c3d9", 
  	fg = "black", 
  	cex = 1, 
  	line = 1.2, 
  	font = 4, 
  	inner = TRUE
)

#Flèche du Nord
mf_arrow(pos = "topleft", col = "#b8c3d9")

#Echelle
mf_scale(
	size = 500,
	pos = "bottomright", 
	lwd = 1.5, 
	cex = 0.6, 
	col = "#b8c3d9", 
	unit = "m"
)

#Credits
mf_credits(
  txt = "Auteur : KHALEF Yasmine, 2023\nBD CARTO, IGN, 2021\n© les contributeurs d'OpenStreetMap, 2021\nDemandes de valeurs foncières géolocalisées, Etalab, 2021",
  col = "#b8c3d9",
)





################################################################################ 
# Prix de l’immobilier dans le voisinnage de la Mairie de Montreuil (4 points)
################################################################################ 


montreuil <- st_as_sf(data.frame(x =2.4410, y = 48.8624), coords = c("x", "y"), crs = 4326)

mf_init(x = montreuil, expandBB = c(0.1,0,0.1,0))
plot(st_geometry(route), col="#454545", lwd=0.5, border = "red", add = TRUE)
plot(st_geometry(rail), col="#454545", lwd=2, add = TRUE)


montreuil_b <- st_buffer(x = montreuil, dist = 5000)
plot(st_geometry(montreuil_b), col = "lightblue", lwd=2, border = "red", add = TRUE)

plot(montreuil, col="red", lwd=2, cex = 2, add = TRUE)



cat(paste0("Le prix de l'immobilier dans un voisinnage de 500 mètres ",
           "autour de la mairie de Montreuil est de ", 
           round(value, 0), 
           " euros par m²"))





################################################################################ 
# Utilisation d’un maillage régulier (4 points)
################################################################################ 

# Créer une grille régulière avec st_make_grid()
grid <- st_make_grid(x = com, cellsize = 250)

# Transformer la grille en objet sf avec st_sf()
# Ajouter un identifiant unique, voir chapitre 3.7.6
grid <- st_sf(ID = 1:length(grid), geom = grid)

plot(st_geometry(grid), col = "grey", border = "white")
plot(st_geometry(com), border = "grey50", add = TRUE)


# Compter le nombre de transaction dans chaque carreau, voir chapitre 3.7.7 
# dans https://rcarto.github.io/geomatique_avec_r/
inter <- st_intersects(grid, dep_46, sparse = FALSE)
grid <- grid[inter, ]
restaurant <- st_read("data/lot46.gpkg", layer = "restaurant", quiet = TRUE)
plot(st_geometry(grid), col = "grey", border = "white")
plot(st_geometry(restaurant), pch = 20, col = "red", add = TRUE, cex = .2)
inter <- st_intersects(grid, restaurant, sparse = TRUE)
length(inter)

# Calculez le prix median par carreau, voir chapitre 3.7.8
# dans https://rcarto.github.io/geomatique_avec_r/
# st_intersection(), aggregate(), merge()

# Selectionner les carreaux ayant plus de 10 transactions, voir chapitre 3.5
# dans https://rcarto.github.io/geomatique_avec_r/


# Justification de la discrétisation (statistiques, boxplot, histogramme, 
# beeswarm...)









