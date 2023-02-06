################################################################################
# Librairies requises
################################################################################ 
setwd("C:/Users/geographie/Documents/R/geomatique_cartographie/Rproject")

library('sf')
library('mapsf')


################################################################################
# Importer les couches d’information et les cartographier (4 points)
################################################################################ 

#Vérification du contenu du geopackage
st_layers("data/dvf.gpkg")

#Import des couches
com <- st_read("data/dvf.gpkg", layer="com")
route <- st_read("data/dvf.gpkg", layer="route")
rail <- st_read("data/dvf.gpkg", layer="rail")
parc <- st_read("data/dvf.gpkg", layer="parc")
dvf <- st_read("data/dvf.gpkg", layer="dvf")

#Le modèle cartographique sera composé des couches com, route, rail et parc
#L'information statistique est présente dans la couche dvf qui représente les 
#demandes de valeurs foncières géolocalisées


##### Préparation de l'export ##############

mf_export(x = com, 
          filename = "carte1.png", 
          theme = "darkula",
          width = 800, 
          expandBB = c(0,0,.01,0))

mf_map(parc, col = "#157D3666", border = "#157D3666", add = TRUE)
mf_map(route, lwd = .2, col = "#000005", add = TRUE)
mf_map(rail, lwd = .2, col = "#000005", lty = 2, add = TRUE)
mf_map(dvf, col = "#c20000", pch = 20, cex = .1, add = TRUE)
mf_map(com, col = NA, border = "white", add = T, lwd = 1.2)

mf_label(com, var = 'NOM', halo = TRUE)
mf_title("Les ventes d'appartements à Vincennes et à Montreuil (2016 - 2021)")
mf_scale(500, unit = "m")
mf_arrow()

credits <- paste0(
  "Auteur : KHALEF Yasmine\n",
  "BD CARTO®, IGN, 2021\n",
  "© les contributeurs d’OpenStreetMap, 2021\n", 
  "Demandes de valeurs foncières géolocalisées, Etalab, 2021"
)
mf_credits(credits)
dev.off()


################################################################################
# Carte des prix de l’immobilier (4 points)
################################################################################ 

# Justification de la discrétisation (statistiques, boxplot, histogramme, 
# beeswarm...)

prix <- dvf$prix
summary(prix) #la moyenne et la médianne sont proches
hist(prix) #la distribution est sous forme de courbe de Gauss 
boxplot(prix) #Il n'y a pas de valeurs abérrantes

##La distribution étant normale, on opte pour une discrétisation à effectifs 
#égaux afin d'avoir la possibilité de choisir facilement le nombre de classes 
#qu'on souhaite représenter  

breaks <- mf_get_breaks(dvf$prix, breaks = "msd", central = FALSE)

mypal <- mf_get_pal(n = c(2,4), palette = c("Teal", "SunsetDark"), rev = c(FALSE, FALSE))

#Export de la carte
mf_export(x = com, 
          filename = "carte2.png", 
          theme = "darkula", 
          width = 800,
          expandBB = c(0,0,.01,0))
mf_map(parc, col = "#157D3666", border = "#157D3666", add = TRUE)
mf_map(route, lwd = .2, col = "#000005", add = TRUE)
mf_map(rail, lwd = .2, col = "#000005", lty = 2, add = TRUE)

# carte choroplethe
mf_map(x = dvf, 
       var = "prix", 
       type = "choro", 
       breaks = breaks, 
       pal = mypal, 
       cex = .6, 
       pch = 20,
       leg_title = "Prix au mètre carré (€)",
       leg_pos = "bottomright2", 
       leg_frame = TRUE,
       leg_val_rnd = -2,
       add = TRUE)
mf_map(com, col = NA, border = "white", add = TRUE)

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
mf_credits(credits)
dev.off()


################################################################################ 
# Prix de l’immobilier dans le voisinnage de la Mairie de Montreuil (4 points)
################################################################################ 

# creation d'une couche sf pour la mairie de Montreuil
montreuil <- st_as_sf(data.frame(x =2.4410, y = 48.8624), 
			    coords = c("x", "y"), 
                      crs = 4326)

#Reprojection 
montreuil <- st_transform(montreuil, st_crs(dvf))

#Buffer de 500m
montreuil_b <- st_buffer(x = montreuil, dist = 5000)

#Intersection entre les appartements et le buffer
inter <- st_intersection(dvf, montreuil_b)

#Médiane des prix des appartements
value <- median(inter$prix)

#Résultat
cat(paste0("Le prix de l'immobilier dans un voisinnage de 500 mètres ",
           "autour de la mairie de Montreuil est de ", 
           round(value, 0), 
           " euros par m²"))


################################################################################ 
# Utilisation d’un maillage régulier (4 points)
################################################################################ 

# Créer une grille régulière avec st_make_grid()
grid <- st_make_grid(com, cellsize = 250, square = TRUE)

# Transformer la grille en objet sf avec st_sf()
grid <- st_sf(geometry = grid)

# Ajouter un identifiant unique
grid$id_grid <- 1:nrow(grid)

# Compter le nombre de transaction dans chaque carreau
inter_grid_dvf <- st_intersects(grid, dvf, sparse = TRUE)
grid$n_dvf <- sapply(inter_grid_dvf, length)

# Calculez le prix median par carreau
dvf_grid <- st_intersection(dvf, grid)

dvf_agg <- aggregate(x = list(prixMed = dvf_grid$prix),
                     by = list(id_grid = dvf_grid$id_grid), 
                     FUN = median)

# Joindre le résultat à la grille
grid <- merge(x = grid, y = dvf_agg, by = "id_grid", all.x = TRUE)

# Selectionner les carreaux ayant plus de 10 transactions
grid <- grid[grid$n_dvf>10, ]

# Découpage de la grille en fonction des communes (optionel)
grid <- st_intersection(grid, st_union(com))

# Justification de la discrétisation 
hist(grid$prixMed)
boxplot(grid$prixMed)
summary(grid$prixMed)

#La distribution est normale. On va donc employer une discrétisation 
#basée sur la moyenne et l'écart-type

#Export de la carte
mf_export(x = com, 
          filename = "carte3.png",
          theme = "darkula", 
          width = 800, 
          expandBB = c(0,0,.01,0))

mf_map(x = grid, 
       var = "prixMed", 
       type = "choro",
       border = NA,
       leg_pos = NA,
       breaks = "msd", 
       pal = "Burg", 
       add = TRUE)

mf_map(parc, col = "#157D3666", border = "#157D3666", add = TRUE)
mf_map(route, lwd = .2, col = "#000005", add = TRUE)
mf_map(rail, lwd = .2, col = "#000005", lty = 2, add = TRUE)
mf_map(com, col = NA, border = "white", add = T, lwd = 1.2)

mf_legend(type = "choro", 
          pos = c(660920, 6861859 ), 
          val = breaks,
          title = "Prix au mètre carré médian (€)\npar carreaux de 250 mètres",
          pal = "Burg", 
          val_rnd = -2, 
          frame = TRUE)

text(x = 660918.1, y = 6860750, 
     labels = paste0("Ne sont représentés que les carreaux", "\n", 
                     "contenant plus de 10 transactions."), 
     col = "#A9B7C6", cex = .6, adj = c(0,1), font = 2)

mf_title("Prix des appartements à Vincennes et à Montreuil (2016-2021)")
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
mf_credits(credits)

dev.off()