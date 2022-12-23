# Modélisation des règles d'urbanisme dans le standard CNIG SRU niveau 2

L'objectif de ce document est de présenter comment les règles du standard SRU de niveau 2 s'implémentent dans le modèle.

Le modèle s'appuie sur les classes du [standard CNIG SRU de niveau 1](https://github.com/cnigfr/structuration-reglement-urbanisme/tree/master/standard) (les deux premières "colonnes" dans le schéma UML) en l'enrichissant au niveau de la classe `Contenu`.

# Règle structurée

## Principe de base

Le contenu d'un article de règlement d'urbanisme se décompose en règles structurées. C'est à dire que pour l'ensemble du texte d'un contenu d'article de règlement d'urbanisme, des règles structurées seront associées.

Si l'on prend le réglement d'un PLU en exemple, nous aurons les éléments suivants codés dans les niveaux 1 et 2 : 

- Plan Local d'Urbanisme de Strabourg => classe `ReglementPLU` (cf. [standard CNIG SRU de niveau 1](https://github.com/cnigfr/structuration-reglement-urbanisme/tree/master/standard))

Cela se traduit en JSON par :
`{id="246700488_reglement_20210625",nom="Règlement du PLUi de l'Eurométropole de STRASBOURG",typeDoc="PLUI",lien=https://www.geoportail-urbanisme.gouv.fr/document/by-id/bbe0a6f433efa7e20b2753e39b40cad4, idUrba="246700488_PLUI_20210625"}`

- Article 6 – **Implantation des constructions par rapport aux voies et emprises publiques ou privées** classe `Titre`

Cela se traduit en JSON par `{id=uri, intitule=Implantation des constructions par rapport aux voies et emprises publiques ou privées, niveau=1, numero=6, href=id}`  (cf. [standard CNIG SRU de niveau 1](https://github.com/cnigfr/structuration-reglement-urbanisme/tree/master/standard))

- "Dans  la  zone CEN UB 44, en bordure  de la  rue Georges Wodli  et du  boulevard du  Président Wilson, la  hauteur maximum  mesurée à l’égout principal  des  toitures  sera de 20 mètres sur une profondeur de 30 mètres à compter de l’alignement de ces voies." classe `Contenu` ([standard CNIG SRU de niveau 1](https://github.com/cnigfr/structuration-reglement-urbanisme/tree/master/standard))

Cela se traduit en JSON par `{id=URI, href=URI}` et est lié à un objet de la classe `RegleStructure` (standard CNIG SRU niveau 2). 

La règle littérale contient deux parties, une partie avec une **condition** ("Dans la  zone CEN UB 44, en bordure de la rue Georges Wodli et du boulevard du  Président Wilson") qui doit être vérifiée pour que la **contrainte**  ("la  hauteur maximum  mesurée à l’égout principal des toitures sera de 20 mètres sur une profondeur de 30 mètres à compter de l’alignement de ces voies") s'applique.

Le standard CNIG SRU niveau 2 permet de modéliser ces conditions et ces contraintes.

Étant donné le lien entre les classes, les règles structurées sont associées à un numéro d'article, lui même associé soit à une zone d'urbanisme, soit aux disposiotions générales concernant toutes les zones d'urbanisme.

## Chaînage

Comme plusieurs conditions et contraintes sont possibles, le chaînage permet d'associer plusieurs conditions et contraintes unitaires par un opérateur logique (ET, OU) pour former des règles, par exemple sous cette forme :
condition1 ET condition2 OU condition 3 implique contrainte1 ET contrainte2 OU contrainte3

# Classe ConditionUnitaire

La classe `ConditionUnitaire` définit une condition unitaire devant être vérifiée pour que la contrainte s'applique. La classe `ConditionUnitaire` est abstraite, différentes classes peuvent l'instancier et prendre la forme de différentes conditions :

- `ConcerneParPrescription` : cette classe indique qu'une règle s'applique lorsqu'un bâtiment se trouve dans une parcelle ou une surface concernée par une prescription. Cette classe fait le lien avec la classe `Prescription` du Standard CNIG PLU ;
- `RouteBordante` :  la parcelle est bordée par une route qui peut avoir des  ***types*** (route départementale, par exemple), par des voies désignées par des **noms** (Rue de la Paix, Boulevard Charles de Gaulle) ou par une certaine **largeur** (largeur de route entre 6 m et 15 m) ;
- `TypeBatiment` : le bâtiment a une vocation (désigné par les destinations du Code de l'Urbanisme) [Question : Des types autres à intégrer comme les logements sociaux ?]
- `BandeConstructibilite` : la contrainte s'applique sur une bande de constructibilité principale ou secondaire définie par une profondeur par rapport aux bordures donnant sur la voirie.
- `SurfaceTerrain` : la contrainte s'applique si la superficie du terrain est comprise entre aireMin et aireMax
 
[Commentaire : on pourra associer dans une version plus avancée les conditions et les contraintes à des schémas pour permettre une documentation : comme ce qui a été fait dans le [registre de règles SimPLU](https://simplu3d.github.io/plu-formel/registry/)]


# Classe ContrainteUnitaire

La classe `ContrainteUnitaire` définit une contrainte à appliquer sur une parcelle. Les contraintes unitaires ont quelques attributs associés comme un **nom** qui peut reprendre une partie du texte et un **type** qui spécifie le type de contrainte concerné (par exemple, basé sur le nom de classe). Il s'agit d'une classe abstraite qui peut avoir différentes implémentations :

- `CoefficientBiotope` : qui caractérise le coefficient Biotope [Formalisme provenant des règles de Buildrz]
- `Hauteur` : caractérise une hauteur maximale qu'un bâtiment doit respecter à partir :
	- de **PointsBas** : point le plus bas du terrain, point le plus haut du terrain,  point de la rue ou de l’emprise publique jouxtant l’unité foncière, point le plus bas du bâtiment 
	- de **PointHaut** : faitage, égout, plancher le plus élevé
- `Autorisation/Interdiction` : associé à certaines conditions (par exemple, sur le type de bâtiment) vise à interdire ou autoriser la construction
- `RatioEmpriseSol` : surface d'emprise au sol bâti maximum
- `RetraitAlignement` : le retrait alignement se calcule par rapport à une référence {fond, limiteLateral, emprisePublique, batiment}. Elle peut prendre plusieurs formes :
	- **Retrait** : un retrait par rapport à la référence qui peut autoriser ou non les alignements. Le retrait peut être minimal ou maximal
	- **RetraitFacadeHauteur** qui s'appliquent sur toutes les façades, celles avec ou sans vue. Ce retrait se fait suivant un prospect défini par une pente et un recul minimal.

# Implémentation dans un formalisme

L'implémentation pourrait s'appuyer sur la proposition faite dans le [Registre de règles SimPLU3D](https://simplu3d.github.io/plu-formel/). Il s'agit de lier les éléments de contraintes et de conditions unitaires à des codes et des listes de paramètres associées. L'avantage de ce formalisme est de rendre possible et accessible la définition d'éléments unitaires personnalisés.

# Modélisation graphique

https://github.com/cnigfr/structuration-reglement-urbanisme/blob/master/schemas/standard_niveau2/221223_MCD_SRU_niv2.png

