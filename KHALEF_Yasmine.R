library('sf')
library('mapsf')

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









