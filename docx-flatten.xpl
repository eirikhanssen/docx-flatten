<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    name="flatten" exclude-inline-prefixes="c">

    <p:input port="source">
        <p:inline>
            <pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas"
                xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex"
                xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex"
                xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex"
                xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex"
                xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex"
                xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex"
                xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex"
                xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex"
                xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex"
                xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink"
                xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:rp="http://schemas.openxmlformats.org/package/2006/relationships"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
                xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml"
                xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid"
                xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex"
                xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"
                xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
                xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"/>
        </p:inline>
    </p:input>

    <p:input port="parameters" kind="parameter" sequence="true"></p:input>

    <p:output port="result">
        <p:pipe port="result" step="final"></p:pipe>
    </p:output>
    <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>

    <p:xslt name="xslt1" version="2.0">
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
                    <xsl:import href="docx-flatten-functions.xsl"/>
                    <xsl:param name="folder" select="folder"/>

                    <xsl:template match="/pkg:package">
                        <xsl:copy>
                            <xsl:copy-of select="node() | @*"/>
                            <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="'/_rels/.rels'"/></xsl:call-template>
                            <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="'/word/_rels/document.xml.rels'"/></xsl:call-template>
                        </xsl:copy>
                    </xsl:template>
                    
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:input port="parameters">
            <p:pipe port="parameters" step="flatten"/>
        </p:input>
    </p:xslt>

    <p:xslt name="xslt2" version="2.0">
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
                    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                    xmlns:rp="http://schemas.openxmlformats.org/package/2006/relationships">
                    <xsl:import href="docx-flatten-functions.xsl"/>
                    <xsl:param name="folder" select="folder"/>
                    <xsl:variable name="test"><xsl:sequence select="//pkg:part[@pkg_name='/_rels/.rels']//rp:Relationship/string(@Target)"/></xsl:variable>
                    <!--<xsl:variable name="rels"><xsl:sequence select="string(pkg:part[@pkg_name='/_rels/.rels']//@*)"></xsl:sequence></xsl:variable>-->
                    <xsl:template match="/pkg:package">
                        <xsl:copy>
                            <xsl:copy-of select="node() | @*"/>
                            <!-- 
                            <xsl:for-each select="$rels/@pkg_name">
                                    <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="."/></xsl:call-template>    
                            </xsl:for-each>
                             -->
                            <xsl:for-each select="//pkg:part[@pkg_name='/_rels/.rels']//rp:Relationship/string(@Target)">
                                <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="."/></xsl:call-template>
                            </xsl:for-each>
                            
                            <xsl:for-each select="//pkg:part[@pkg_name='/word/_rels/document.xml.rels']//rp:Relationship[@Type != 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image']/string(@Target)">
                                <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="concat('word/',.)"/></xsl:call-template>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:template>
                    
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:input port="parameters">
            <p:pipe port="parameters" step="flatten"/>
        </p:input>
    </p:xslt>
    
    <p:filter name="body" select="//w:document"></p:filter>
    <p:delete name="remove-bookmarks" match="//w:bookmarkEnd | //w:bookmarkStart"></p:delete>
   
   <!--
    <p:insert name="test" match="w:rPr[w:b]" position="last-child">
        <p:input port="insertion"><p:inline exclude-inline-prefixes="#all"><w:i/></p:inline></p:input>
    </p:insert>-->
    
    <p:xslt name="xslt3" version="2.0">
        <p:input port="source"/>
            
        
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:f="https://eirikhanssen.com/ns/functions" version="2.0">
                    <xsl:import href="docx-flatten-functions.xsl"/>
                    
                    <!-- translate paragraph elements depending on style name -->
                    
                    <xsl:template match="w:p">
                        <xsl:call-template name="elementFromStyle">
                            <xsl:with-param name="source-element" select="."/>
                        </xsl:call-template>
                    </xsl:template>
                    
                    <!--
                    <xsl:template match="w:t">
                        <xsl:choose>
                            <xsl:when test="ancestor::w:r[1][w:rPr[w:i][w:b]]">
                                <bold><italic><xsl:apply-templates/></italic></bold>
                            </xsl:when>
                            <xsl:when test="ancestor::w:r[1][Pr[w:i]]">
                                <italic><xsl:apply-templates/></italic>
                            </xsl:when>
                            <xsl:when test="ancestor::w:r[1][w:rPr[w:b]]">
                                <bold><xsl:apply-templates/></bold>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:template>-->
                    
                    <xsl:template match="w:r">
                        <xsl:choose>
                            <xsl:when test=".[w:rPr[w:i][w:b]]">
                                <bold><italic><xsl:apply-templates/></italic></bold>
                            </xsl:when>
                            <xsl:when test=".[Pr[w:i]]">
                                <italic><xsl:apply-templates/></italic>
                            </xsl:when>
                            <xsl:when test=".[w:rPr[w:b]]">
                                <bold><xsl:apply-templates/></bold>
                            </xsl:when>
                            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:template>
                                        
                    <xsl:template match="w:t"><xsl:apply-templates/></xsl:template>
                    
                    
                    
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:input port="parameters">
            <p:pipe port="parameters" step="flatten"/>
        </p:input>
    </p:xslt>

    <p:rename match="w:tc[p/@style='TabellKolonneoverskrift']|w:tc[p/@style='TabellRadoverskrift']" new-name="th"></p:rename>
    <p:rename match="w:tc" new-name="td"></p:rename>
    
    <p:rename match="w:tr" new-name="tr"></p:rename>
    <p:rename match="w:tbl" new-name="table"></p:rename>
    <p:delete match="w:rPr|w:lastRenderedPageBreak|w:tcPr|tr/@*|w:tblGrid|w:tblPr"></p:delete>
    <!-- w:tblPr kanskje noen attributter her som trengs for å finne ut hva slags type tabell -->
    
    
    
    

    

    <!--
    <p:sink>
        <p:input port="source">
            <p:pipe port="result" step="xslt3"></p:pipe>
        </p:input>
    </p:sink>-->

    <p:identity name="final"/>

</p:declare-step>