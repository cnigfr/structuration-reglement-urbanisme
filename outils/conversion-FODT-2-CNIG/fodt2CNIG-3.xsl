<?xml version="1.0" encoding="UTF-8"?>
<!--...................................-->
<!-- Transformation FODT > format CNIG -->
<!--          Date: 2020-11-08         -->
<!--            Version : 0.1          -->
<!--     Author: Stéphane Garcia       -->
<!--...................................-->
<!-- 3e étape :                        -->
<!-- Mise au format CNIG               -->
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
	<!-- template principal -->
	<xsl:template match="plu:ReglementDU">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>type="text/css" href="style.css"</xsl:text>
		</xsl:processing-instruction>
		<plu:ReglementDU xsi:schemaLocation="https://cnig.gouv.fr/reglementDU reglementDU.xsd" id="{@id}" nom="{@nom}" typeDoc="{@typeDoc}" lien="{@lien}" idUrba="{@idUrba}">
			<xsl:sequence select="plu:hierarchiser(*, 1)"/>
		</plu:ReglementDU>
	</xsl:template>
	<!-- ====================== functions ======================== -->
	<!-- fonction pemettant de hiérarchiser les titres -->
	<xsl:function name="plu:hierarchiser" as="element()*">
		<xsl:param name="elements" as="element()*"/>
		<xsl:param name="level" as="xs:integer"/>
		<xsl:for-each-group select="$elements" group-starting-with="plu:Titre[@niveau = $level]">
			<xsl:choose>
				<xsl:when test="not(self::plu:Titre[@niveau = $level])">
					<xsl:where-populated>
						<xsl:apply-templates select="current-group()"/>
					</xsl:where-populated>
				</xsl:when>
				<xsl:otherwise>
					<plu:Titre id="{generate-id(.)}" intitule="{@intitule}" libelleZone="{@zone}" libellePrescription="{if (@prescription = '') then 'nonConcerne' else @prescription}" inseeCommune="15079" niveau="{@niveau}">
						<xsl:sequence select="plu:hierarchiser(current-group() except ., ($level + 1))"/>
					</plu:Titre>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:function>
</xsl:stylesheet>
