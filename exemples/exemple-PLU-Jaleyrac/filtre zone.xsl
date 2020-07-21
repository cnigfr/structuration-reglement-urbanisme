<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:plu="https://cnig.gouv.fr/reglementDU">
	<xsl:output method="xml" indent="yes"/>
	  <xsl:variable name="stylesheetVersion" select="'0.1'"/>

<xsl:param name="idZone"/>
<xsl:variable name="token" select="concat(',',$idZone,',')"/>

<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="plu:Titre[not(descendant-or-self::plu:Titre[
contains(concat(',',@libelleZone,','),$token) or 
contains(concat(',',@libelleZone,','),concat(',',substring($idZone, 1, string-length($idZone) - 1),',')) or
contains(concat(',',@libelleZone,','),concat(',',$idZone,'a,')) or 
contains(concat(',',@libelleZone,','),concat(',',$idZone,'b,')) or 
contains(@libelleZone,'porteeGenerale')])]">
</xsl:template>

</xsl:stylesheet>
