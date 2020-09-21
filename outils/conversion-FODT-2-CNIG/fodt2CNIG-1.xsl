<?xml version="1.0" encoding="UTF-8"?>
<!--...................................-->
<!-- Transformation FODT > format CNIG -->
<!--          Date: 2020-11-08         -->
<!--            Version : béta 1       -->
<!--     Author: Stéphane Garcia       -->
<!--...................................-->
<!-- 1e étape :                        -->
<!-- Insertion des balises plu         -->
<!-- Conversion FODT HTML              -->
<!--...................................-->
<xsl:stylesheet version="3.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mf="http://example.com/mf" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:plu="https://cnig.gouv.fr/reglementDU" exclude-result-prefixes="xsi xs mf office meta text draw table">
	<!-- supprime les blancs-->
	<xsl:strip-space elements="*"/>
	<!-- indente le XML résultat-->
	<xsl:output indent="yes" method="xml"/>
	<!--=============== Templates ===============-->
	<!-- template fourre-tout -->
		<xsl:template match="*[following::text:sequence-decls]">
			<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="office:text|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<!-- suppression des balises office -->
	<xsl:template match="*[following::text:sequence-decls]"/>
	<!-- template principal -->
	<xsl:template match="office:text">
		<plu:ReglementDU xmlns="http://www.w3.org/1999/xhtml" id="{../../office:meta/meta:user-defined[@meta:name = 'id']}" nom="{../../office:meta/meta:user-defined[@meta:name = 'nom']}" typeDoc="{../../office:meta/meta:user-defined[@meta:name = 'typeDoc']}" lien="{../../office:meta/meta:user-defined[@meta:name = 'lien']}" idUrba="{../../office:meta/meta:user-defined[@meta:name = 'idUrba']}">
			<xsl:apply-templates/>
		</plu:ReglementDU>
	</xsl:template>
	<!-- définition d'une clé unique pour les titres -->
	<xsl:key name="titre" match="text:h" use="text()"/>
	<!-- balises plu -->
	<xsl:template match="text:h">
		<plu:Titre id="{generate-id(.)}" zone="{substring(./text:variable-set[@text:name='libelleZone']/@text:formula,6)}" presc="{substring(./text:variable-set[@text:name='libellePresc']/@text:formula,6)}" niveau="{@text:outline-level}" intitule="{text()}"/>
		<xsl:element name="{concat('h',@text:outline-level)}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='libelleZoneStart']">
		<plu:Bloc type="start" zone="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='libelleZoneEnd']">
		<plu:Bloc type="end" zone="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='libellePrescStart']">
		<plu:Bloc type="start" presc="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<xsl:template match="node()[./text:variable-set and ./text:variable-set/@text:name='libellePrescEnd']">
		<plu:Bloc type="end" presc="{substring(./*[1]/@text:formula,6)}"/>
	</xsl:template>
	<!-- conversion ODT/html -->
	<!-- paragraphes -->
	<xsl:template match="text:p[not(*) and not(./text:variable-set)]">
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
	<xsl:template match="text:p[* and not(./text:variable-set)]">
		<xsl:choose>
			<xsl:when test="@text:style-name='P2'">
				<div style="text-decoration:underline">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- hyperliens -->
		<xsl:template match="text:a">
		<a href="{concat('#',key('titre',substring-after(substring-before(@xlink:href,'|'),'#'))/generate-id())}">
				<xsl:apply-templates/>
		</a>
	</xsl:template>
	<!-- listes -->
	<xsl:template match="text:list">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<xsl:template match="text:list-item">
		<li>
			<xsl:value-of select="."/>
		</li>
	</xsl:template>
	<!-- tableaux -->
	 <xsl:template match="table:table">
		<table rules="all" style="border:solid 1px black;">
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="table:table-row">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
		<xsl:template match="table:table-cell">
		<td>
			<xsl:value-of select="."/>
		</td>
	</xsl:template>
	<!-- gras -->
	<xsl:template match="text:span[@text:style-name='Strong_20_Emphasis']">
		<strong>
			<xsl:value-of select="."/>
		</strong>
	</xsl:template>
		<!-- italique -->
	<xsl:template match="text:span[@text:style-name='T1']">
		<em>
			<xsl:value-of select="."/>
		</em>
	</xsl:template>
	<!-- images -->
	<xsl:template match="draw:frame">
		<p class="center">
			<img src="{concat('ressources/',@draw:name)}" alt="{if(@draw:z-index) then @draw:z-index else generate-id(.)}"/>
		</p>
	</xsl:template>
</xsl:stylesheet>
