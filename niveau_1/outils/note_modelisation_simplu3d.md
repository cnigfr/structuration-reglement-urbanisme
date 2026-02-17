# Synthèse de la modélisation des réglements dans SimPLU3D (version étendue)

## Principe de base

L'idée de base est de proposer une modélisation des concepts (objets, relations, propriétés, mesures) qui apparaissent dans les réglements du PLU via un modèle UML. Et à partir des éléments de ce modèle, de proposer de coder les règles avec le langage [Object Constraint Language (OCL)](https://www.omg.org/spec/OCL/2.4/About-OCL/) qui est un langagé normé et conçu pour formaliser des règles à partir de modèles UML.

L'idée est que si l'on prend une règle comme la suivante :

"La distance comptée horizontalement de tout point du bâtiment à la limite séparative latérale la plus proche doit
Modélisation du règlement bâtiment à la limite séparative latérale la plus proche doit
être au moins égale à 6 m."

Les concepts de distance, de bâtiment, de limite séparative latérale et de plus proche doivent pouvoir être présents dans le modèle pour les représenter. Il est ainsi possible avec le langage OCL de traduire cette règle de la manière suivante :

context CadastralParcel inv:

self.getBoundary().select(type==’LAT’).geom
-> forAll(g |
38self.getBoundary().select(type==’LAT’).geom
-> forAll(g |
self.getBuildings().footprint.distance(g) > 6)

[Pour en savoir plus sur le principe général : slide 14 - 38 de la présentation de thèse](https://mbrasebin.github.io/presentations/2014-These.pdf)

## Organisation du modèle

Le modèle globalement s'organise comme ci-dessous avec un bloc concernant la modélisation des bâtiments, un autre la logique de la réglementation, un troisième le parcellaire et un dernier concernant l'espace public.

![A test image](https://simplu3d.github.io/simplu3D-tutorial/envgeo/img/generaldiagramAnnoted.png)

Basiquement la réglementation est défini via des zones urbaines qui peuvent sous découper des parcelles en sous-parcelles (= partie d'une parcelle associée à un unique réglement). Le module réglementation s'appuie sur les concepts de la norme CNIG sur la modélisation des documents d'urbanisme que ça soit au niveau des zones que des prescriptions graphiques.

Les limites des parcelles sont des objets à part entière car les contraintes qui s'y appliquent peuvent varier en fonction de leur statut (limite latérale, de fond ou donnant sur la voirie) et en fonction des objets limitrophes (espace public ou autre parcelle).

Le schéma suivant illustre cette logique :

![A test image](https://www.mdpi.com/ijgi/ijgi-05-00014/article_deploy/html/images/ijgi-05-00014-g006.png)

## Les concepts du modèles

Le but de cette partie est de lister les concepts clés du modèle, ils peuvent être soit support de conditions soit de contraintes pour l'application des règles.

Limites séparatives :
- Type : latéral, fond, front (donnant sur la voirie) => Il s'agit d'un concept théorique des PLU dont la mise en oeuvre dépend d'une définition locale

Sous-parcelle :
- Surface de plancher
- Surface

Route/Espace public :
- Nom
- Type
- Largeur
- Limite opposée

Ligne d'alignement/recul :
- Géométrie
- Type de contrainte (alignement/recul)
- Référence (objet associé à l'alignement)
- Bande de recul (différenciant l'application des règles)

Bâtiment/Partie de bâtiment :
- Nombre d'étages
- Destination
- Surface de plancher
- Surface

Face du bâtiment :
- Façade aveugle
- Matériau
- type : l'orientation différenciée peut impliquer des contraintes différentes
- Hauteur
- Longueur

Toit :
- AngleMin/AngleMax
- Nombre de pans
- Gouttière
- Pignon
- Faitage

Mesures :
- distance
- prospect(hauteurInitial, pente, objet support)
- hauteur :
 - Point haut :  faitage, égout, plancher le plus élevé
 - Point bas : point le plus bas du terrain, point le plus haut du terrain, point de la rue ou l'emprise jouxtant l'unité foncière, point le plus bas

## Mécanismes d'extension

La modélisation proposée permet d'étendre les règles qu'il est possible de formaliser. En étendant le modèle UML, il est possible de réutiliser les concepts pour former de nouvelles règles (exemple ici avec le concept de Baufenster allemand).

![](https://www.mdpi.com/ijgi/ijgi-05-00014/article_deploy/html/images/ijgi-05-00014-g012.png)

## Pour en savoir plus

- [L'article scientifique](https://www.mdpi.com/2220-9964/5/2/14)
- [La thèse](https://mbrasebin.github.io/publications/2014-these.pdf)
