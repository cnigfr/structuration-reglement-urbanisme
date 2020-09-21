<?xml version="1.0" encoding="UTF-8"?>
<!--...................................-->
<!-- Transformation FODT > format CNIG -->
<!--          Date: 2020-11-08         -->
<!--            Version : béta 1       -->
<!--     Author: Stéphane Garcia       -->
<!--...................................-->
<!-- 2e étape :                        -->
<!-- Ajoute les blocs "plu:Contenu"    -->
<!--...................................-->
<xsl:stylesheet version="3.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:plu="https://cnig.gouv.fr/reglementDU">
	<!-- supprime les blancs-->
	<xsl:strip-space elements="*"/>
	<!-- indente le XML résultat-->
	<xsl:output indent="yes" method="xml"/>
	<!--=============== Templates ===============-->
	<!-- template fourre-tout -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<!-- structuration du document -->
	<xsl:template match="plu:ReglementDU">
		<plu:ReglementDU id="{@id}" nom="{@nom}" typeDoc="{@typeDoc}" lien="{@lien}" idUrba="{@idUrba}">
			<xsl:for-each-group select="*" group-starting-with="plu:Titre">
				<xsl:variable name="titreZone" select="if(@zone='') then preceding::plu:Titre[@zone!=''and @niveau &lt; current()/@niveau][1]/@zone else @zone"/>
				<xsl:variable name="titrePresc" select="if(@presc='') then preceding::plu:Titre[@presc!=''and @niveau &lt; current()/@niveau][1]/@presc else @presc"/>
				<plu:Titre id="{@id}" zone="{$titreZone}" prescription="{$titrePresc}" niveau="{@niveau}" intitule="{@intitule}"/>
				<xsl:for-each-group select="current-group() except ." group-starting-with="plu:Bloc">
				<xsl:variable name="contenuZone" select="if(.[@type='start']/@zone) then @zone else $titreZone"/>
				<xsl:variable name="contenuPresc" select="if(.[@type='start']/@presc) then @presc else $titrePresc"/>
					<xsl:where-populated>
						<plu:Contenu id="{generate-id(.)}" libelleZone="{$contenuZone}" libellePrescription="{if ($contenuPresc) then $contenuPresc else 'nonConcerne'}">
							<xsl:for-each select="current-group()">
								<xsl:choose>
									<xsl:when test="self::plu:Bloc"/>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</plu:Contenu>
					</xsl:where-populated>
				</xsl:for-each-group>
			</xsl:for-each-group>
		</plu:ReglementDU>
	</xsl:template>
</xsl:stylesheet>
