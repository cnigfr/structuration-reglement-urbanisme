<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes"/>
	  <xsl:variable name="stylesheetVersion" select="'0.1'"/>

<xsl:param name="idZone"/>
<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="*[@libelleZone !=$idZone and @libelleZone !='porteeGenerale']//*"/>
</xsl:stylesheet>
