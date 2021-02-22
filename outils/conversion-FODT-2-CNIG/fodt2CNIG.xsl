<?xml version="1.0" encoding="UTF-8"?>
<!--...................................-->
<!-- Transformation FODT > format CNIG -->
<!--          Date: 2021-02-22         -->
<!--  Version : 1.0 pour LibreOffice   -->
<!--     Author: Stéphane Garcia       -->
<!--...................................-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mf="http://example.com/mf" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:tmp="temp" xmlns="http://www.w3.org/1999/xhtml" xmlns:plu="https://cnig.gouv.fr/reglementDU" exclude-result-prefixes="xsi xs mf office meta draw table tmp">
	<!-- supprime les blancs-->
	<xsl:strip-space elements="*"/>
	<!-- indente le XML résultat-->
	<xsl:output indent="yes" method="xml"/>
	<!--=============== Templates ===============-->
	<!--================ Global =================-->
	<!-- applique les templates par étapes en    -->
	<!-- utilisant des "modes" successifs et des -->
	<!-- variables. A la fin, exporte le résultat-->
	<!-- ........................................-->
	<xsl:template match="office:text">
		<xsl:variable name="varEtape1">
			<xsl:element name="plu:ReglementDU" namespace="https://cnig.gouv.fr/reglementDU">
				<xsl:attribute name="id" select="../../office:meta/meta:user-defined[@meta:name = 'id']"/>
				<xsl:attribute name="nom" select="../../office:meta/meta:user-defined[@meta:name = 'nom']"/>
				<xsl:attribute name="typeDoc" select="../../office:meta/meta:user-defined[@meta:name = 'typeDoc']"/>
				<xsl:attribute name="lien" select="../../office:meta/meta:user-defined[@meta:name = 'lien']"/>
				<xsl:attribute name="idUrba" select="../../office:meta/meta:user-defined[@meta:name = 'idUrba']"/>
				<xsl:apply-templates mode="etape1" select="node()|@*"/>
			</xsl:element>
		</xsl:variable>
		<xsl:variable name="varEtape2">
			<xsl:apply-templates mode="etape2" select="$varEtape1"/>
		</xsl:variable>
		<xsl:variable name="varEtape3">
			<xsl:apply-templates mode="etape3" select="$varEtape2"/>
		</xsl:variable>
		<!-- Génération du résultat final -->
		<xsl:copy-of select="$varEtape3"/>
	</xsl:template>
	<!--================ Etape 1 ================-->
	<!-- Insertion des balises Titre et Bloc qui -->
	<!-- serviront a créer la balise Contenu     -->
	<!-- Conversion du format FODT vers un format-->
	<!-- HTML                                    -->
	<!--.........................................-->
	<!-- template fourre-tout -->
	<xsl:template match="office:text|@*" mode="etape1">
		<xsl:copy>
			<xsl:apply-templates mode="etape1" select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<!-- suppression des balises office -->
	<xsl:template match="*[following::text:sequence-decls]"/>
	<!-- définition d'une clé unique pour les titres pour gérer les liens hypertexte -->
	<xsl:key name="titre" match="text:h" use="text()"/>
	<!-- création des balises Titre et Bloc (qui sera ensuite transformé en Contenu) -->
	<xsl:template match="text:h" mode="etape1">
		<tmp:Titre tmp:id="{generate-id(.)}" tmp:intitule="{text()}" tmp:niveau="{@text:outline-level}" tmp:zone="{substring(./text:variable-set[@text:name='idZone']/@text:formula,6)}" tmp:presc="{substring(./text:variable-set[@text:name='idPresc']/@text:formula,6)}" tmp:insee="{./text:variable-set[@text:name='inseeCommune']/@office:value}"/>
		<xsl:element name="{concat('h',@text:outline-level)}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='idZoneStart']" mode="etape1">
		<tmp:Bloc tmp:type="start" tmp:zone="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='idZoneEnd']" mode="etape1">
		<tmp:Bloc tmp:type="end" tmp:zone="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='idPrescStart']" mode="etape1">
		<tmp:Bloc tmp:type="start" tmp:presc="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='idPrescEnd']" mode="etape1">
		<tmp:Bloc tmp:type="end" tmp:presc="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<!-- les templates suivants servent à convertir le ODT en html pour la mise en page du texte -->
	<!-- paragraphes -->
	<xsl:template match="text:p[not(*) and not(./text:variable-set)]" mode="etape1">
		<xsl:choose>
			<xsl:when test="@text:style-name='P2'">
				<div style="text-decoration:underline">
					<xsl:value-of select="."/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:value-of select="."/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- souligné -->
	<xsl:template match="text:p[* and not(./text:variable-set)]" mode="etape1">
		<xsl:choose>
			<xsl:when test="@text:style-name='P2'">
				<div style="text-decoration:underline">
					<xsl:apply-templates mode="etape1"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:apply-templates mode="etape1"/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- hyperliens -->
	<xsl:template match="text:a" mode="etape1">
		<xsl:choose>
			<xsl:when test="starts-with(@xlink:href,'http')">
				<a href="{@xlink:href}">
					<xsl:apply-templates mode="etape1"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{concat('#',key('titre',substring-after(substring-before(@xlink:href,'|'),'#'))/generate-id())}">
					<xsl:apply-templates mode="etape1"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- listes -->
	<xsl:template match="text:list" mode="etape1">
		<ul>
			<xsl:apply-templates mode="etape1"/>
		</ul>
	</xsl:template>
	<xsl:template match="text:list-item" mode="etape1">
		<li>
			<xsl:value-of select="."/>
		</li>
	</xsl:template>
	<!-- tableaux -->
	<xsl:template match="table:table" mode="etape1">
		<table rules="all" style="border:solid 1px black;">
			<xsl:apply-templates mode="etape1"/>
		</table>
	</xsl:template>
	<xsl:template match="table:table-row" mode="etape1">
		<tr>
			<xsl:apply-templates mode="etape1"/>
		</tr>
	</xsl:template>
	<xsl:template match="table:table-cell" mode="etape1">
		<td>
			<xsl:value-of select="."/>
		</td>
	</xsl:template>
	<!-- gras -->
	<xsl:template match="text:span[@text:style-name='Strong_20_Emphasis']" mode="etape1">
		<strong>
			<xsl:value-of select="."/>
		</strong>
	</xsl:template>
	<!-- italique -->
	<xsl:template match="text:span[@text:style-name='T1']" mode="etape1">
		<em>
			<xsl:value-of select="."/>
		</em>
	</xsl:template>
	<!-- images -->
	<xsl:template match="draw:frame" mode="etape1">
		<p class="center">
			<img src="{concat('ressources/',@draw:name)}" alt="{if(@draw:z-index) then @draw:z-index else generate-id(.)}"/>
		</p>
	</xsl:template>
	<!--=============== Etape 2 ===============-->
	<!-- Ajoute les blocs "plu:Contenu" à      -->
	<!-- l'interieur des balises Titre         -->
	<!--.......................................-->
	<!-- template fourre-tout -->
	<xsl:template match="node()|@*" mode="etape2">
		<xsl:copy>
			<xsl:apply-templates mode="etape2" select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<!-- transformation des Blocs en Contenu (on crée un élément contenu 
	     en dessous de chaque Titre et un élément Contenu pour chaque balise 
	     Bloc en récupérant ce qui se trouve entre les bloc-start et bloc-end -->
	<xsl:template match="plu:ReglementDU|@*" mode="etape2">
		<plu:ReglementDU id="{@id}" nom="{@nom}" lien="{@lien}" idUrba="{@idUrba}" typeDoc="{@typeDoc}">
			<xsl:for-each-group select="*" group-starting-with="tmp:Titre">
				<xsl:variable name="varTitreZone" select="if(@tmp:zone='') then preceding::tmp:Titre[@tmp:zone!=''and @tmp:niveau &lt; current()/@tmp:niveau][1]/@tmp:zone else @tmp:zone"/>
				<xsl:variable name="varTitrePresc" select="if(@tmp:presc='') then preceding::tmp:Titre[@tmp:presc!=''and @tmp:niveau &lt; current()/@tmp:niveau][1]/@tmp:presc else @tmp:presc"/>
				<xsl:variable name="varTitreInsee" select="if(@tmp:insee='') then preceding::tmp:Titre[@tmp:insee!=''and @tmp:niveau &lt; current()/@tmp:niveau][1]/@tmp:insee else @tmp:insee"/>
				<tmp:Titre tmp:id="{@tmp:id}" tmp:zone="{$varTitreZone}" tmp:prescription="{$varTitrePresc}" tmp:insee="{$varTitreInsee}" tmp:niveau="{@tmp:niveau}" tmp:intitule="{@tmp:intitule}"/>
				<xsl:for-each-group select="current-group() except ." group-starting-with="tmp:Bloc">
					<xsl:variable name="varContenuZone" select="if(.[@tmp:type='start']/@tmp:zone) then @tmp:zone else $varTitreZone"/>
					<xsl:variable name="varContenuPresc" select="if(.[@tmp:type='start']/@tmp:presc) then @tmp:presc else $varTitrePresc"/>
						<xsl:element name="plu:Contenu">
							<xsl:attribute name="id" select="generate-id(.)"/>
							<xsl:attribute name="idZone" select="$varContenuZone"/>
							<xsl:attribute name="idPrescription" select="if ($varContenuPresc) then $varContenuPresc else 'nonConcerne'"/>
							<xsl:for-each select="current-group()">
								<xsl:choose>
									<xsl:when test="self::tmp:Bloc"/>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:element>
				</xsl:for-each-group>
			</xsl:for-each-group>
		</plu:ReglementDU>
	</xsl:template>
	<!--=============== Etape 3 ===============-->
	<!-- Hiérarchisation des titres            -->
	<!-- Complétion pour conformité a au xsd   -->
	<!--.......................................-->
	<!-- clé pour hiérarchiser les titres -->
	<xsl:key name="child-by-parent" match="tmp:Titre" use="preceding-sibling::tmp:Titre[@tmp:niveau = current()/@tmp:niveau - 1][1]/@tmp:id"/>
	<xsl:template match="plu:ReglementDU|@*" mode="etape3">
		<plu:ReglementDU xsi:schemaLocation="{'https://cnig.gouv.fr/reglementDU reglementDU.xsd'}" id="{@id}" nom="{@nom}" lien="{@lien}" idUrba="{@idUrba}" typeDoc="{@typeDoc}">
			<xsl:apply-templates mode="etape3" select="tmp:Titre[@tmp:niveau = 1]"/>
		</plu:ReglementDU>
	</xsl:template>
	<!-- hiérarchisation des titre et remplissage avec les balises Contenu non vides -->
	<xsl:template match="tmp:Titre" mode="etape3">
	<plu:Titre id="{@tmp:id}" intitule="{@tmp:intitule}" niveau="{@tmp:niveau}" idZone="{@tmp:zone}" idPrescription="{@tmp:prescription}" inseeCommune="{@tmp:insee}">
		<!--xsl:element name="plu:Titre">
			<xsl:attribute name="id" select="@tmp:id"/>
			<xsl:attribute name="intitule" select="@tmp:intitule"/>
			<xsl:attribute name="niveau" select="@tmp:niveau"/>
			<xsl:attribute name="idZone" select="@tmp:idZone"/>
			<xsl:attribute name="idPrescription" select="@tmp:idPrescription"/>
			<xsl:attribute name="inseeCommune" select="@tmp:inseeCommune"/-->
			<xsl:choose>
				<xsl:when test="not(following-sibling::tmp:Titre[1])">
					<xsl:copy-of select="following-sibling::plu:Contenu[descendant::*]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="following-sibling::tmp:Titre[1]/preceding-sibling::plu:Contenu[preceding-sibling::tmp:Titre[1]/@tmp:id=current()/@tmp:id and descendant::*]"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="key('child-by-parent', @tmp:id)" mode="etape3"/>
		<!--/xsl:element-->
		</plu:Titre>
	</xsl:template>
</xsl:stylesheet>
