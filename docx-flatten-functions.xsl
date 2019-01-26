<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template name="part">
        <xsl:param name="epath"/><!-- path to unzipped docx-archive (external path) -->
        <xsl:param name="ipath"/><!-- path to resource within docx-archive (internal path) -->
        <pkg:part pkg_name="{$ipath}">
            <pkg:xmlData>
                <xsl:sequence select="doc(concat($epath,$ipath))"></xsl:sequence>
            </pkg:xmlData>
        </pkg:part>
    </xsl:template>
    
    <!-- default identity transform: copy node as is -->
    <xsl:template match="node() | @*">
        <xsl:apply-templates select="node() | @*"/>
    </xsl:template>
    
</xsl:stylesheet>