<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:f="https://eirikhanssen.com/ns/functions"
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
    
    <xsl:function name="f:nameFromStyle" as="text()">
        <xsl:param name="node" as="node()"></xsl:param>
        
        <xsl:variable name="pStyle" select="string($node/w:pPr/w:pStyle/@w:val)"/>
        
        <xsl:variable name="styleMapping">
            <stylemapping>
                <rename to="title">
                    <style>Heading1</style>
                </rename>
                <rename to="h2">
                    <style>Heading2</style>
                </rename>
                <rename to="keywords">
                    <style>Keywords</style>
                </rename>
                <rename to="authors">
                    <style>Forfattere</style>
                    <style>Authors</style>
                </rename>
                <rename to="abstract">
                    <style>Abstrakt</style>
                    <style>Abstract</style>
                </rename>
                <rename to="li">
                    <style>ListParagraph</style>
                </rename>
            </stylemapping>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$pStyle = $styleMapping//style">
                <xsl:value-of select="$styleMapping/stylemapping/rename[$pStyle=style]/@to"/>
            </xsl:when>
            <xsl:otherwise>unknown-style</xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>

    <xsl:template name="elementFromStyle" as="node()">
        <xsl:param name="source-element" as="node()"></xsl:param>
        
        <xsl:variable name="pStyle" select="string($source-element/w:pPr/w:pStyle/@w:val)"/>
        
        <xsl:variable name="new-name" select="f:nameFromStyle($source-element)"/>
        
        <xsl:variable name="has-known-style" select="$new-name ne 'unknown-style'"/>
        
        <xsl:choose>
            <xsl:when test="$has-known-style">
                <xsl:element name="{$new-name}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$pStyle = ''"><p><xsl:apply-templates/></p></xsl:when>
            <xsl:otherwise>
                  <p style="{$pStyle}">
                      <xsl:apply-templates/>
                  </p>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <!-- default identity transform: copy node as is -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>    
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>