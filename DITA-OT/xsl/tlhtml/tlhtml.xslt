<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
exclude-result-prefixes="msxsl">

  <xsl:import href="default.xslt"/>

  <xsl:output method="html" version="1.0" indent="yes" />

  <!--***********************Root Nodes******************************************************-->
  <xsl:template match="/">
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="style/dtl-base.css" />
    <link rel="stylesheet" type="text/css" href="style/dtl-table.css" />
    <link rel="stylesheet" type="text/css" href="style/dtl-topic.css" />
  </head>
  <body>

  <xsl:call-template name="defaultRoot" />

  </body>
</html>
  </xsl:template>

  <!--***********************Root Nodes******************************************************-->
  <!-- This template is a copy of the root matcher from default.xslt.  The above root matcher-->
  <!-- overrides the root matcher from default.xslt.  This template performs the same        -->
  <!-- processing as the original root matcher, after the above adds HTML header.            -->
  <!-- Be sure to update this template if default.xslt root matcher changes.                 -->
  <xsl:template name="defaultRoot">
    <span class="transformedContent">
      <!--For TOC scrolling add the anchor-->
      <a id="{@id}" href="#{@id}"/>

      <!--Rest of the content-->
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />

      <!--Foot notes must be copied at the end of topic-->
      <xsl:call-template name="copyFootNotes"/>
    </span>
    <xsl:call-template name="footer">
      <xsl:with-param name="collectionID" select="$footerCollectionID" />
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>
