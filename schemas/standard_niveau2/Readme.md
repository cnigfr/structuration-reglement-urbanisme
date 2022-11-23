# Proposition d'un modèle de règles pour le standard 2

L'objectif de ce document est de présenter comment les règles du standard de niveau 2 s'implémente dans le modèle. Le modèle s'appuie sur les classe du standard de niveau 1  et enrichit celui-ci au niveau de la classe contenu.

# Règle structurée

## Principe de base

Le contenu d'un article se décompose en règles structurées. C'est à dire que pour l'ensemble du texte d'un contenu d'articles, des règles structurées seront associées.

Si l'on prend le réglement d'un PLU, nous aurons les éléments suivants codés dans les niveaux 1 et 2 : 

- Plan Local d'Urbanisme de Strabourg => classe ReglementPLU (standard niveau 1)

Cela se traduit en JSON par  {id = uri, nom= Règlement PLU de Strasbourg, lien=url}

- Article 6 – **Implantation des constructions par rapport aux voies et emprises publiques ou privées** classe titre (standard niveau 1)

Cela se traduit en JSON par  {id=uri, intitule=implantation des constructions par rapport aux voies et emprises publiques ou privées, niveau=1, numero=6, href=id})

- "Dans  la  zone CEN UB 44,  en bordure  de la  rue Georges Wodli  et du  boulevard du  Président Wilson, la  hauteur maximum  mesurée à l’égout principal  des  toitures  sera de  20 mètres sur une profondeur  de  30 mètres  à compter de  l’alignement  de ces  voies. " classe Contenu (standard niveau 1)

Cela se traduit en JSON par  {id = URI, href=URI] et est lié à un objet de la classe règle structurée classe RegleStructure (standard niveau 2). 

La règle textuelle contient deux parties, une partie avec une **condtion** ("Dans  la  zone CEN UB 44,  en bordure  de la  rue Georges Wodli  et du  boulevard du  Président Wilson") qui doit être vérifiée pour que la **contrainte**  ("la  hauteur maximum  mesurée à l’égout principal  des  toitures  sera de  20 mètres sur une profondeur  de  30 mètres  à compter de  l’alignement  de ces  voies"). s'applique  

Le standard niveau 2 introduit ici la possibilité de modéliser ces conditions et ces contraintes.

Étant donné le lien entre les classes, les règles structurées se retrouvent associées à une zone du PLU et à un numéro d'article.

## Chaînage

Comme plusieurs conditions et contraintes  sont possibles, le chaînage permet d'associer plusieurs conditions et contraintes unitaires par un opérateur pour former des règles sous cette forme par exemple :
condition1 ET condition2 OU condition 3 implique contrainte1 ET contrainte2 OU contrainte3

# Classe ConditionUnitaire

La classe condition définit une condition unitaire qui doit être vérifiée pour que le contrainte s'applique. La classe **ConditionUnitaire** est abstraite, différentes classes peuvent l'instancier et prendre la forme de différentes conditions :

- **ConcerneParPrescription** : cette classe indique qu'une règle s'applique lorsqu'un bâtiment se trouve dans une parcelle ou une surface concernée  par une prescription. Cette classe fait le lien avec la classe PrescriptionGraphique du GPU ;
- **RouteBordante** :  la parcelle est bordée par une route qui peut avoir des  ***types*** (route départementale, par exemple), par des voies désignées par des **noms** (Rue de la Paix, Boulevard Charles de Gaulle) ou par une certaine **largeur** (largeur de route entre 6 m et 15 m) ;
- **TypeBatiment** : le bâtiment a une vocation (désigné par les destination du Code de l'Urbanisme) [Question : Des types autres à intégrer comme les logements sociaux ?]
- **BandeConstructibilite** : la contrainte s'applique sur une bande de constructibilité Principale ou Secondaire définie par une profondeur par rapport aux bordures donnant sur la voirie.
- **SurfaceTerrain** : la contrainte s'applique si la superficie du terrain est comprise en aireMin et aireMax
 
[Commentaire : on pourra associer dans une version plus avancée les conditions et les contraintes à des schémas pour permettre une documentation : comme ce qui a été fait ici : https://simplu3d.github.io/plu-formel/registry/ ]


# Classe ContrainteUnitaire

La classe ContrainteUnitaire définit une contrainte à appliquer sur une parcelle. Les contraintes unitaires ont quelques métadonnées associées comme un **nom** qui peut reprendre une partie du texte et un **type** qui spécifie le type de contrainte concerné (par exemple, basé sur le nom de classe). Il s'agit d'une classe abstraite qui peut avoir différentes implémentations :

- **CoefficientBiotope** : qui caractérise le coefficient Biotope [Formalisme provenant des règles de Buildrz]
- **Hauteur** : caractérise une hauteur maximale qu'un bâtiment doit respecter à partir :
	- De **PointsBas** : point le plus bas du terrain, point le plus haut du terrain,  point de la rue ou de l’emprise publique jouxtant l’unité foncière, point le plus bas du bâtiment 
	- De **PointHaut** : faitage, égout, plancher le plus élevé
- **Autorisation/Interdiction** : associé à certaines conditions (par exemple, sur le type de bâtiment) vise à interdire ou autoriser la construction
- **RatioEmpriseSol** : surface d'emprise au sol bâti maximum
- **RetraitAlignement** : le retrait alignement se calcule par rapport à une référence {fond, limiteLateral,  emprisePublique, batiment}. Elle peut prendre plusieurs formes :
	- **Retrait** : un retrait par rapport à la référence qui peut autoriser ou non les alignements. Le retrait peut être minimal ou maximal
	- **RetraitFacadeHauteur** qui s'appliquent sur toutes les façades, celles avec ou sans vue. Ce retrait se fait suivant un prospect défini par une pente et un recul minimal

# Implémentation dans un formalisme

L'implémentation pourrait s'appuyer sur la propose faite ici : https://simplu3d.github.io/plu-formel/ 
Il s'agit de lier les éléments de contraintes et de conditions unitaires à des codes et des listes de paramètres associées. L'avantage de ce formalisme est qu'il rend possible et accessible la définition d'éléments unitaires personnalisés.


