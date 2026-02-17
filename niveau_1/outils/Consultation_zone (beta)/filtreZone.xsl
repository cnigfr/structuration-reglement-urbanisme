<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:plu="https://cnig.gouv.fr/reglementDU">
	<xsl:output method="xml" indent="yes"/>

<xsl:param name="idZone1"/>
<xsl:param name="idZone2"/>
<xsl:param name="idPresc"/>

<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="//plu:Titre[not(contains(concat(',',@libelleZone,','),$idZone1) or @libelleZone='porteeGenerale')]"/>

<xsl:template match="//plu:Contenu[not((contains(concat(',',@libelleZone,','),$idZone1) or contains(concat(',',@libelleZone,','),$idZone2) or @libelleZone='porteeGenerale') and (contains(concat(',',@libellePrescription,','),$idPresc) or @libellePrescription='porteeGenerale' or @libellePrescription='nonConcerne'))]"/>

</xsl:stylesheet>
