<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">

<xsl:import href="xslhtml/dita2htmlImpl.xsl"></xsl:import>
<xsl:import href="xslhtml/taskdisplay.xsl"></xsl:import>
<xsl:import href="xslhtml/refdisplay.xsl"></xsl:import>
<xsl:import href="xslhtml/ut-d.xsl"></xsl:import>
<xsl:import href="xslhtml/sw-d.xsl"></xsl:import>
<xsl:import href="xslhtml/pr-d.xsl"></xsl:import>
<xsl:import href="xslhtml/ui-d.xsl"></xsl:import>
<xsl:import href="xslhtml/hi-d.xsl"></xsl:import>

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"></xsl:output>
<xsl:strip-space elements="*"/>

<xsl:param name="DITAEXT" select="'.xml'"/>

<!-- Filter parameter for defining the heading hierarchical elements.  Note each element must be surrounded on both sides by pipes (|) -->
<xsl:param name="headingElements" select="'|daPhase|daSubPhase|daOtherSubPhase|daSubstantiveSubPhase|daOtherProcedureGroup|daSubstantiveProcedureGroup|daOtherProcedure|daSubstantiveProcedure|daTailoringQuestionGroup|daTailoringQuestion|daPolicyGroup|daPolicy|daGuidance|daGenericFindingCategory|daControlDeviationFinding|daControlDeficiencyFinding|daSignificantDeficiencyFinding|daMaterialWeaknessFinding|daDisclosureDeficiencyFinding|daMisstatementFinding|daSigDocumentationMatterFinding|daEngmtSignificantRiskPervasive|daEngmtSignificantRiskSpecific|daEngmtSignificantRiskIT|daSignificantRisk|daConclusion|daSystemProcess|daPhaseList|daSystemProcessList|daLinkToTool|daTrialBalance|daTemplate|daReportTemplate|daReportTemplateWithSections|daReportSection|'" />
<xsl:param name="sectionElements" select="'|daPhase|daSubPhase|daOtherSubPhase|daSubstantiveSubPhase|daOtherProcedureGroup|daSubstantiveProcedureGroup|daOtherProcedure|daSubstantiveProcedure|daTailoringQuestionGroup|daTailoringQuestion|daPolicyGroup|daPolicy|daGuidance|daGenericFindingCategory|daControlDeviationFinding|daControlDeficiencyFinding|daSignificantDeficiencyFinding|daMaterialWeaknessFinding|daDisclosureDeficiencyFinding|daMisstatementFinding|daSigDocumentationMatterFinding|daEngmtSignificantRiskPervasive|daEngmtSignificantRiskSpecific|daEngmtSignificantRiskIT|daSignificantRisk|daConclusion|daSystemProcess|daPhaseList|daSystemProcessList|daLinkToTool|daTrialBalance|daTemplate|daReportTemplate|daReportTemplateWithSections|daReportSection|'" />

<!-- 
  * Template: match: daRendering
  * Purpose:  Handle the root element of the rendering XML document.
  *           Writes out the html header and styles and applies the
  *           child elements.
-->
<xsl:template match="daRendering">
<html>
<head>
<title>Rendition</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<style type="text/css">
h1 { font-size:16pt; color: Blue; }
h2 { font-size:16pt; color: Red; }
h3 { font-size:16pt; color: Gray; }
h4 { font-size:16pt; color: DarkMagenta; }
h5 { font-size:16pt; color: Green; }
h6 { font-size:16pt; color: Sienna; }

p.title {font-size:16pt; color: Black; font-weight: normal; margin-top:14pt; margin-bottom:0pt; padding:0pt 0pt 0pt 0pt; }
hr.title {height:1px; color:CornflowerBlue; margin:0pt 0pt 14pt 0pt; padding:0pt 0pt 0pt 0pt; }
p.sectionHeading {font-size:14pt; font-weight:bold; color: Black; padding-top:0pt; padding-bottom:0pt; margin-top:12pt; margin-bottom:0pt; }

table.NVtable {
  width:90%;
  border:none;
}
td.label {
  font-size:12pt;
  color:black;
  text-align:left;
  vertical-align:top;
  width:200px;
}
td.colon {
  font-size:12pt;
  color:black;
  text-align:left;
  vertical-align:top;
  padding-left:10px;
  padding-right:10px;
  width:30px;
}
td.value {
  font-size:12pt;
  color:black;
  text-align:left;
  vertical-align:top;
}
</style>
</head>
<body>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

  <!-- 
    * Template: match: *
    *           mode:  getElementIndex
    * Purpose:  Walk the elements sibling list and counting the number of heading elements
    *           from the list of headingElements precede the current element.  This is used
    *           to determine the bullet value for the current level of the object.
  -->
  <xsl:template match="*" mode="getElementIndex">
    <xsl:variable name="siblingCount">
      <xsl:for-each select="preceding-sibling::*">
        <xsl:if test="contains($headingElements,concat('|',name(.),'|'))">1</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!-- The index for the current position is the sibling count plus the current element -->
    <xsl:value-of select="string-length($siblingCount) + 1"/>
  </xsl:template>
  
  <!-- 
    * Template: match: *
    *           mode:  buildBullet
    * Purpose:  Walk the parents of the current element to find the first qualified
    *           heading element, excluding the title element, then determine the 
    *           element index for each of the qualified levels based on whether the
    *           element belongs to the list of heading elements.
  -->
  <xsl:template match="*" mode="buildBullet">
    <!-- First traverse to the parent element -->
    <xsl:variable name="bulletStr">
      <xsl:choose>
        <xsl:when test="not(../../parent::*)"></xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="buildBullet" select="parent::node()" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!--  If the current node is a valid heading element calculate its index and append to the bullet string -->
      <xsl:when test="contains($headingElements,concat('|',name(current()),'|'))">
        <xsl:variable name="indexVal">
          <xsl:apply-templates select="current()" mode="getElementIndex"/>
        </xsl:variable>
        <xsl:if test="$bulletStr != ''"><xsl:value-of select="$bulletStr"/>.</xsl:if>
        <xsl:value-of select="$indexVal"/>
      </xsl:when>
      <!-- Otherwise just return the existing string -->
      <xsl:otherwise><xsl:value-of select="$bulletStr"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
    * Template: match: *
    *           mode:  getHeadingLevel
    * Purpose:  Counts the number of qualified heading ancestors to determine
    *           which heading value to set.
  -->
  <xsl:template match="*" mode="getHeadingLevel">
    <xsl:param name="level" select="'0'"/>
    <xsl:variable name="newLevel">
      <xsl:choose>
        <!-- If the current node is a heading element and not the title element increment the level. -->
        <xsl:when test="contains($headingElements,concat('|',name(current()),'|')) and name(parent::*[1]) != 'daRendering'">
          <xsl:value-of select="format-number($level,0) + 1"/>
        </xsl:when>
        <!-- Otherwise use the current level -->
        <xsl:otherwise><xsl:value-of select="$level"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- If we are not at the top level node recurse to the parent node -->
      <xsl:when test="parent::* and $newLevel != '0'">
        <xsl:apply-templates select="parent::*" mode="getHeadingLevel">
          <xsl:with-param name="level" select="$newLevel" />
        </xsl:apply-templates>
      </xsl:when>
      <!-- Otherwise record the new level -->
      <xsl:otherwise><xsl:value-of select="$newLevel"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
    * Template: name: writeHeading
    * Purpose:  Write out the html section heading.  This routine determines if the
    *           current node is the title, a heading, or just a section.  If it is the 
    *           title it constructs the title based on rules for object type: object internal
    *           name - object instance name.  If it is a heading the heading level and bullet
    *           are determined and used along with the rules for object type: object internal
    *           name - object instance name to create the heading.  If the object is just a 
    *           section label then only the heading prefix is used for the value.
  -->
  <xsl:template name="writeHeading">
    <xsl:param name="headingPrefix" />
    <xsl:param name="internalName" select=".//daControlAttributes/internalName"/>
    <xsl:param name="instanceName" select="''"/>

    <!-- Construct the heading string -->
    <xsl:variable name="headingValue">
      <xsl:value-of select="$headingPrefix"/><xsl:value-of select="$internalName"/>
      <xsl:if test="$instanceName != ''"> - <xsl:value-of select="$instanceName"/></xsl:if>
    </xsl:variable>
    <!-- Get the depth for the heading -->
    <xsl:variable name="headingDepth"><xsl:apply-templates select="current()" mode="getHeadingLevel"/></xsl:variable>
    <xsl:choose>
      <!-- Check to see if this is the title and display accordingly -->
      <xsl:when test="name(parent::*[1]) = 'daRendering'">
        <p class="title"><xsl:value-of select="$headingValue"/></p><hr class="title"/>
      </xsl:when>
      <!-- Check if this is a valid heading object and output the heading accordingly -->
      <xsl:when test="$headingDepth != '0'">
        <xsl:variable name="headingLevel">
          <xsl:choose>
            <xsl:when test="$headingDepth > 7">h6</xsl:when>
            <xsl:otherwise>h<xsl:value-of select="$headingDepth"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="bullet"><xsl:apply-templates select="current()" mode="buildBullet"></xsl:apply-templates></xsl:variable>
        <xsl:element name="{$headingLevel}"><xsl:value-of select="$bullet"/><xsl:text disable-output-escaping="yes">&#160;&#x09;</xsl:text><xsl:value-of select="$headingValue"/></xsl:element>
      </xsl:when>
      <!-- Otherwise this is just a section label, so output the prefix -->
      <xsl:otherwise>
        <p class="sectionHeading"><xsl:value-of select="$headingPrefix"/></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- start rule for daPhase content item -->
  <xsl:template match="daPhase">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Phase: '"/>
      <xsl:with-param name="internalName" select=".//daControlAttributes/internalName"/>
      <xsl:with-param name="instanceName" select=".//phaseInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="phase"/>
    <xsl:apply-templates select="./phaseAttributes/phaseInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./phaseBody/phaseText"/>
    </table>
    <xsl:apply-templates select="./phaseAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daPhase content item -->

  <!-- start rule for daSubPhase content item -->
  <xsl:template match="daSubPhase">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'SubPhase: '"/>
      <xsl:with-param name="internalName" select=".//daControlAttributes/internalName"/>
      <xsl:with-param name="instanceName" select=".//subPhaseInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="subphase"/>
    <xsl:apply-templates select="./subPhaseAttributes/subPhaseInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:apply-templates select="./subPhaseAssoc/daAccount" mode="accountProcessing"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./subPhaseBody/subPhaseText"/>
    </table>
    <xsl:apply-templates select="./subPhaseAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daSubPhase content item -->

  <!-- start rule for daOtherSubPhase content item -->
  <xsl:template match="daOtherSubPhase">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Other SubPhase: '"/>
      <xsl:with-param name="instanceName" select=".//subPhaseInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="subphase"/>
    <xsl:apply-templates select="./subPhaseAttributes/subPhaseInstanceName"/>
    <xsl:call-template name="controldata"/>
      <xsl:apply-templates select="./otherSubPhaseAssoc/daAccount" mode="accountProcessing"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./subPhaseBody/subPhaseText"/>
    </table>
    <xsl:apply-templates select="./otherSubPhaseAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daOtherSubPhase content item -->

  <!-- start rule for daSubstantiveSubPhase content item -->
  <xsl:template match="daSubstantiveSubPhase">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Substantive SubPhase: '"/>
      <xsl:with-param name="instanceName" select=".//subPhaseInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="subphase"/>
    <xsl:apply-templates select="./subPhaseAttributes/subPhaseInstanceName"/>
    <xsl:call-template name="controldata"/>
      <xsl:apply-templates select="./substantiveSubPhaseAssoc/daAccount" mode="accountProcessing"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./subPhaseBody/subPhaseText"/>
    </table>
     <xsl:apply-templates select="./substantiveSubPhaseAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daSubstantiveSubPhase content item -->

  <!-- start rule for daOtherProcedureGroup content item -->
  <xsl:template match="daOtherProcedureGroup">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Other Procedure Group: '"/>
      <xsl:with-param name="instanceName" select=".//procedureGroupInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./procedureGroupAttributes/procedureGroupInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./procedureGroupBody/procedureGroupText" />
    </table>
    <xsl:apply-templates select="./otherProcedureGroupAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daOtherProcedureGroup content item -->


  <!-- start rule for daSubstantiveProcedureGroup content item -->
  <xsl:template match="daSubstantiveProcedureGroup">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Substantive Procedure Group: '"/>
      <xsl:with-param name="instanceName" select=".//procedureGroupInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./procedureGroupAttributes/procedureGroupInstanceName"/>
    <xsl:call-template name="controldata"/>
      <xsl:apply-templates select="substantiveProcedureAssoc/daAccount" mode="accountProcessing"/>
    <xsl:apply-templates select="./procedureGroupBody/procedureGroupText" />
    </table>
    <xsl:apply-templates select="./substantiveProcedureGroupAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daSubstantiveProcedureGroup content item -->


  <!-- start rule for daOtherProcedure content item -->
  <xsl:template match="daOtherProcedure">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Other Procedure: '"/>
      <xsl:with-param name="instanceName" select=".//procedureInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./otherProcedureAttributes/procedureInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:apply-templates select="./otherProcedureAttributes"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./procedureBody/procedureText"/>
    </table>
    <xsl:apply-templates select="./procedurePreconditions/daPrecondition"/>
    <xsl:apply-templates select="./otherProcedureAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daOtherProcedure content item -->

  <!-- start rule for daSubstantiveProcedure content item -->
  <xsl:template match="daSubstantiveProcedure">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Substantive Procedure: '"/>
      <xsl:with-param name="instanceName" select=".//procedureInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./substantiveProcAttributes/procedureInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:apply-templates select="./substantiveProcAttributes"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./procedureBody/procedureText"/>
    </table>
    <xsl:apply-templates select="./procedurePreconditions/daPrecondition"/>
    <xsl:apply-templates select="./substantiveProcedureAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daSubstantiveProcedure content item -->

  
  <!-- start rule for daTailoringQuestionGroup content item -->
  <xsl:template match="daTailoringQuestionGroup">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Tailoring Question Group: '"/>
      <xsl:with-param name="instanceName" select=".//tailoringQuestionGroupInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./tailoringQuestionGroupAttributes/tailoringQuestionGroupInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./tailoringQuestionGroupBody/tailoringQuestionGroupText"/>
    </table>
    <xsl:apply-templates select="./tailoringQuestionGroupAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daTailoringQuestionGroup content item -->

  <!-- start rule for daTailoringQuestion content item -->
  <xsl:template match="daTailoringQuestion">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Tailoring Question: '"/>
      <xsl:with-param name="instanceName" select=".//tailoringQuestionInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./tailoringQuestionAttributes/tailoringQuestionInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:apply-templates select="./tailoringQuestionAttributes"/>
    <xsl:if test="./tailoringQuestionAttributes/tailoringQuestionSummaryView = 1">
      <tr>
        <td class="label">Tailoring Question Summary View</td>
        <td class="colon">:</td>
        <td class="value">Yes</td>
      </tr>
    </xsl:if>
    <xsl:if test="./tailoringQuestionAttributes/tailoringQuestionDashboardView = 1">
      <tr>
        <td class="label">Tailoring Question Dashboard View</td>
        <td class="colon">:</td>
        <td class="value">Yes</td>
      </tr>
    </xsl:if>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./tailoringQuestionBody/tailoringQuestionText" />
    </table>
    <xsl:apply-templates select="./tailoringQuestionPreconditions/daPrecondition"/>
    <xsl:apply-templates select="./tailoringQuestionResponses"/>
    <xsl:apply-templates select="./tailoringQuestionAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daTailoringQuestion content item -->

  <!-- start rule for daGenericFindingCategory content item -->
  <xsl:template match="daGenericFindingCategory">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Generic Finding Category: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:value-of select="./genericFindingCategoryBody/genericFindingCategoryName/daPlainTextTranslation"/>
    <xsl:apply-templates select="./genericFindingCategoryAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daGenericFindingCategory content item -->

  <!-- start rule for daControlDeviationFinding content item -->
  <xsl:template match="daControlDeviationFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Control Deviation Finding: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./findingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daControlDeviationFinding content item -->

  <!-- start rule for daControlDeficiencyFinding content item -->
  <xsl:template match="daControlDeficiencyFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Control Deficiency Finding: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./findingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daControlDeficiencyFinding content item -->

  <!-- start rule for daSignificantDeficiencyFinding content item -->
  <xsl:template match="daSignificantDeficiencyFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Significant Deficiency Finding: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./findingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daSignificantDeficiencyFinding content item -->

  <!-- start rule for daMaterialWeaknessFinding content item -->
  <xsl:template match="daMaterialWeaknessFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Material Weakness Finding: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./findingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daMaterialWeaknessFinding content item -->

  <!-- start rule for daDisclosureDeficiencyFinding content item -->
  <xsl:template match="daDisclosureDeficiencyFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Disclosure Deficiency Finding: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./findingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daDisclosureDeficiencyFinding content item -->

  <!-- start rule for daMisstatementFinding content item -->
  <xsl:template match="daMisstatementFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Misstatement Finding: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./findingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daMisstatementFinding content item -->

  <!-- start rule for daSigDocumentationMatterFinding content item -->
  <xsl:template match="daSigDocumentationMatterFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Sig Documentation Matter Finding: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./findingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daSigDocumentationMatterFinding content item -->

  <!-- start rule for daEngmtSignificantRiskPervasive  content item -->
  <xsl:template match="daEngmtSignificantRiskPervasive">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Engmt Significant Risk Pervasive: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./riskFindingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daEngmtSignificantRiskPervasive  content item -->

  <!-- start rule for daEngmtSignificantRiskSpecific  content item -->
  <xsl:template match="daEngmtSignificantRiskSpecific">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Engmt Significant Risk Specific: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./riskFindingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daEngmtSignificantRiskSpecific  content item -->
  
  <!-- start rule for daEngmtSignificantRiskIT  content item -->
  <xsl:template match="daEngmtSignificantRiskIT">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Engmt Significant Risk IT: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:apply-templates select="./riskFindingAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daEngmtSignificantRiskIT  content item -->

  <!-- start rule for daSignificantRisk  content item -->
  <xsl:template match="daSignificantRisk">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Significant Risk: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:value-of select="./significantRiskBody/significantRiskTitle/daPlainTextTranslation"/>
  </xsl:template>
  <!-- end rule for daSignificantRisk  content item -->


  <!-- start rule for daConclusion  content item -->
  <xsl:template match="daConclusion">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Conclusion: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:value-of select="./conclusionBody/conclusionValue/daPlainTextTranslation"/>
  </xsl:template>
  <!-- end rule for daConclusion  content item -->

  <!-- start rule for daSystemProcess  content item -->
  <xsl:template match="daSystemProcess">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'System Process: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:value-of select="./systemProcessBody/systemProcessName/daPlainTextTranslation"/>
    <xsl:apply-templates select="./systemProcessAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daSystemProcess  content item -->

  <!-- start rule for daPhaseList  content item -->
  <xsl:template match="daPhaseList">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Phase List: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:value-of select="./systemProcessListBody/systemProcessListName/daPlainTextTranslation"/>
    <xsl:apply-templates select="./phaseListAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daPhaseList  content item -->
  
  <!-- start rule for daSystemProcessList  content item -->
  <xsl:template match="daSystemProcessList">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'System Process List: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    </table>
    <xsl:value-of select="./systemProcessListBody/systemProcessListName/daPlainTextTranslation"/>
    <xsl:apply-templates select="./systemProcListAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daSystemProcessList  content item -->

  <!-- start rule for daLinkToTool content item -->
  <xsl:template match="daLinkToTool">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Link To Tool: '"/>
      <xsl:with-param name="instanceName" select=".//linkToToolInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./linkToToolAttributes/linkToToolInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    </table>
    <xsl:apply-templates select="./linkToToolAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daLinkToTool content item -->

  <!-- start rule for daTrialBalance content item -->
  <xsl:template match="daTrialBalance">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Trial Balance: '"/>
      <xsl:with-param name="instanceName" select=".//trialBalanceInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./trialBalanceAttributes/trialBalanceInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./trialBalanceBody/trialBalanceNumber"/>
    </table>
    <xsl:apply-templates select="./trialBalanceAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daTrialBalance content item -->

  <!-- start rule for daTemplate content item -->
  <xsl:template match="daTemplate">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Template: '"/>
      <xsl:with-param name="instanceName" select=".//templateInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./templateAttributes/templateInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./templateBody/templateNumber"/>
    </table>
    <xsl:apply-templates select="./templateAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daTemplate content item -->

  <!-- start rule for daReportTemplate content item -->
  <xsl:template match="daReportTemplate">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Report Template: '"/>
      <xsl:with-param name="instanceName" select=".//reportTemplateInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./reportTemplateAttributes/reportTemplateInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./reportTemplateBody/reportTemplateName"/>
    </table>
    <xsl:apply-templates select="./reportTemplateAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daReportTemplate content item -->

  <!-- start rule for daReportTemplateWithSections content item -->
  <xsl:template match="daReportTemplateWithSections">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Report Template With Sections: '"/>
      <xsl:with-param name="instanceName" select=".//reportTemplateInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./reportTemplateAttributes/reportTemplateInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./reportTemplateBody/reportTemplateName"/>
    </table>
    <xsl:apply-templates select="./reportTemplateSectionAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daReportTemplateWithSections content item -->

  <!-- start rule for daReportSection content item -->
  <xsl:template match="daReportSection">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Report Section: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./reportSectionBody/reportSectionName"/>
    </table>
    <xsl:apply-templates select="./reportTemplateSectionAssoc/child::node()"/>
  </xsl:template>
  <!-- end rule for daReportSection content item -->

  <!-- start rule for daPolicyGroup content item -->
  <xsl:template match="daPolicyGroup">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Policy Group: '"/>
      <xsl:with-param name="instanceName" select=".//policyGroupInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./policyGroupAttributes/policyGroupInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./policyGroupBody/policyGroupText"/>
    </table>
    <xsl:apply-templates select="./policyGroupAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daPolicyGroup content item -->

  <!-- start rule for daPolicy content item -->
  <xsl:template match="daPolicy">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Policy: '"/>
      <xsl:with-param name="instanceName" select=".//policyInstanceName/daPlainTextTranslation[1]"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:apply-templates select="./policyAttributes/policyInstanceName"/>
    <xsl:call-template name="controldata"/>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./policyBody/policyText"/>
    </table>
    
    <!-- precondition details -->
    <xsl:apply-templates select="./policyPreconditions/daPrecondition"/>
    <xsl:apply-templates select="./policyAssociations/child::node()"/>
  </xsl:template>
  <!-- end rule for daPolicy content item -->

  <!-- start rule for daGuidance content item -->
  <xsl:template match="daGuidance">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Guidance: '"/>
    </xsl:call-template>
    <table class="NVtable">
    <xsl:call-template name="controldata"/>
    <xsl:if test="./guidanceAttributes/extendedGuidance = 1">
      <tr>
        <td class="label">Extended guidance</td>
        <td class="colon">:</td>
        <td class="value">Yes</td>
      </tr>
    </xsl:if>
    <xsl:call-template name="reuse"/>
    <xsl:apply-templates select="./guidanceBody/guidanceText"/>
    </table>
  </xsl:template>
  <!-- end rule for daGuidance -->
  
  <!-- start rule for typographic styles -->
  <xsl:template match="b">
    <strong>
      <xsl:value-of select="."></xsl:value-of>
    </strong>
  </xsl:template>
  <xsl:template match="i">
    <em>
      <xsl:value-of select="."></xsl:value-of>
    </em>
  </xsl:template>
  <xsl:template match="u">
    <u>
      <xsl:value-of select="."></xsl:value-of>
    </u>
  </xsl:template>
  <xsl:template match="tt">
    <tt>
      <xsl:value-of select="."></xsl:value-of>
    </tt>
  </xsl:template>
  <xsl:template match="sup">
    <sup>
      <xsl:value-of select="."></xsl:value-of>
    </sup>
  </xsl:template>
  <xsl:template match="sub">
    <sub>
      <xsl:value-of select="."></xsl:value-of>
    </sub>
  </xsl:template>
  <!-- end rule for typographic styles -->
  
  <!-- start phase reference number -->
  <xsl:template name="phase">
    <tr>
      <td class="label">Phase Reference Number</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./phaseAttributes/phaseReferenceNum" /></td>
    </tr>
  </xsl:template>
  <!-- end subphase reference number -->
  
  <!-- start subphase reference number -->
  <xsl:template name="subphase">
    <tr>
      <td class="label">SubPhase Reference Number</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./subPhaseAttributes/subPhaseReferenceNum" /></td>
    </tr>
  </xsl:template>
  <!-- end subphase reference number -->

  <!-- start rule for controldata content item -->
  <xsl:template name="controldata">
    <tr>
      <td class="label">Internal Reference Number</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./daControlAttributes/internalRefNum" /></td>
    </tr>
    <tr>
      <td class="label">Internal Name</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./daControlAttributes/internalName" /></td>
    </tr>
    <tr>
      <td class="label">Source Content Domain</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./daControlAttributes/sourceContentDomain" /></td>
    </tr>
    <tr>
      <td class="label">Version #</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./daControlAttributes/sourceVersionNum" /></td>
    </tr>
    <tr>
      <td class="label">Content Hidden</td>
      <td class="colon">:</td>
      <td class="value"><xsl:variable name="hiddenFlag" select="./daControlAttributes/contentHidden/text()"/>
        <xsl:choose>
          <xsl:when test="$hiddenFlag='1'">True</xsl:when>
          <xsl:otherwise>False</xsl:otherwise>
        </xsl:choose>      
      </td>
    </tr>
    <tr>
      <td class="label" style="padding-bottom:10px;">Reason Code</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value" style="padding-bottom:10px;"><xsl:apply-templates select="./daControlAttributes/controlData/reasonCode" /></td>
    </tr>
    <tr>
      <td class="label" style="padding-bottom:10px;">Industry</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value" style="padding-bottom:10px;"><xsl:apply-templates select="./daControlAttributes/controlData/industry"/></td>
    </tr>
    <tr>
      <td class="label" style="padding-bottom:10px;">Engagement Type</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value" style="padding-bottom:10px;"><xsl:apply-templates select="./daControlAttributes/controlData/engagementType"/></td>
    </tr>
  </xsl:template>

  <xsl:template match="tailoringQuestionAttributes">
    <tr>
      <td class="label">TQ Display Type</td>
      <td class="colon">:</td>
      <td class="value"><xsl:apply-templates select="./tailoringQuestionDisplayType" /></td>
    </tr>      
    <tr>
      <td class="label">Scalability</td>
      <td class="colon">:</td>
      <td class="value"><xsl:apply-templates select="./tailoringQuestionScalability" /></td>
    </tr>
  </xsl:template>

  <xsl:template match="otherProcedureAttributes">
    <tr>
      <td class="label">Scalability</td>
      <td class="colon">:</td>
      <td class="value"><xsl:apply-templates select="./procedureScalability" /></td>
    </tr>
  </xsl:template>  
  
  <xsl:template match="substantiveProcAttributes">
    <tr>
      <td class="label">Scalability</td>
      <td class="colon">:</td>
      <td class="value"><xsl:apply-templates select="./procedureScalability" /></td>
    </tr>
    <tr>
      <td class="label">Assertions</td>
      <td class="colon">:</td>
      <td class="value"><xsl:apply-templates select="./procedureAssertion" /></td>
    </tr>
  </xsl:template>  
  
  <xsl:template match="tailoringQuestionDisplayType | tailoringQuestionScalability | procedureScalability | procedureAssertion">
    <xsl:value-of select="."/>
    <xsl:if test="position()!=last()">;  </xsl:if>
  </xsl:template>

  <xsl:template match="reasonCode|industry|engagementType">
    <xsl:value-of select="."/>
    <xsl:if test="position()!=last()">;  </xsl:if>
  </xsl:template>

  <!-- 
    * Template: match="daAccount"
    *           mode="accountProcessing"
    * Purpose:  Handle output of account information.
    *
  -->
  <xsl:template match="daAccount" mode="accountProcessing">
      <tr>
        <td class="label">Account Name</td>
        <td class="colon">:</td>
        <td class="value"><xsl:value-of select="./accountBody/accountName/daPlainTextTranslation" /></td>
      </tr>
  </xsl:template>
  
  <!-- 
    * Template: match="daAccount"
    * Purpose:  Ignore the daAccount element as it has already been processed elsewhere.
    *
  -->
  <xsl:template match="daAccount">
  </xsl:template>
  
  <xsl:template match="daNARD">
    <tr>
      <td class="label">NARD</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./nardBody/nardName/daPlainTextTranslation" /></td>
    </tr>
  </xsl:template>

  <xsl:template match="daAccountList">
    <xsl:call-template name="controldata"/>
    <xsl:value-of select="./containerBody/containerName/daPlainTextTranslation"/>
    <xsl:apply-templates select="./containerAssociations/child::node()" mode="accountProcessing"/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/image ')]/@href" priority="1">
    <xsl:attribute name="src">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="daPrecondition">
    <xsl:if test="position()=1">
      <h4>Preconditions</h4>
    </xsl:if>

    <xsl:variable name="precondition" select="." />
    <xsl:variable name="precondition1" select="substring-after($precondition,'{?}')" />
    <table class="NVtable">
      <tr>
        <td class="label">Internal Name</td>
        <td class="colon">:</td>
        <td class="colon"><xsl:value-of select="substring-before($precondition,'{?}')" /></td>
      </tr>
      <tr>
        <td class="label">Instance Name</td>
        <td class="colon">:</td>
        <td class="colon"><xsl:value-of  select="substring-before($precondition1,'{?}')" />
          </td>
      </tr>
      <tr>
        <td class="label">Response Text</td>
        <td class="colon">:</td>
        <td class="colon"><xsl:value-of  select="substring-after($precondition1,'{?}')" /></td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="linkToToolPath"> 
        <tr>
          <td class="label">Link to Tool File Path</td>
          <td class="colon">:</td>
          <td class="value"><xsl:value-of select="." /></td>
        </tr>
  </xsl:template>

  <xsl:template match="trialBalancePath | templatePath | reportTemplatePath | reportSectionPath">
      <tr>
        <td class="label">
            <xsl:choose>
              <xsl:when test="name()='trialBalancePath'">Trial Balance File Path</xsl:when>
              <xsl:when test="name()='templatePath'">Template Path</xsl:when>
              <xsl:when test="name()='reportTemplatePath'">Report Template Path</xsl:when>
              <xsl:when test="name()='reportSectionPath'">Report Section Path</xsl:when>
              <xsl:otherwise>File Path</xsl:otherwise>
            </xsl:choose>
        </td>
        <td class="colon">:</td>
        <td class="colon"><xsl:value-of select="./@href"  /></td>
      </tr>
  </xsl:template>

  
  <xsl:template match="ref">
    <p>
     <FONT style="BACKGROUND-COLOR: #d3d3d3">
        <xsl:value-of select="."></xsl:value-of>
      </FONT>  
    </p>    
  </xsl:template>

  <xsl:template match="sourceContentDomain | sourceVersionNum">
    <xsl:value-of select="."/>    
  </xsl:template>
  
  <xsl:template match="daRenditionFilters">
    <table class="NVtable">
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="daRenditionFilter">
    <tr>
      <td class="label"><xsl:value-of select="@filterName" /></td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="@filterValue" /></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="phaseText | phaseInstanceName | subPhaseText | subPhaseInstanceName |
     procedureGroupText | procedureGroupInstanceName | procedureInstanceName |
     policyGroupText | policyGroupInstanceName | policyInstanceName |
     tailoringQuestionGroupText | tailoringQuestionGroupInstanceName |tailoringQuestionInstanceName |
     templateInstanceName | reportTemplateInstanceName | trialBalanceInstanceName | linkToToolInstanceName |
     trialBalanceNumber | templateNumber | reportTemplateName |reportSectionName">
      <tr>
        <td class="label">
          <xsl:choose>
            <xsl:when test="name()='phaseText'">Phase Text</xsl:when>
            <xsl:when test="name()='phaseInstanceName'">Phase Instance Name</xsl:when>
            <xsl:when test="name()='subPhaseText'">Subphase Text</xsl:when>
            <xsl:when test="name()='subPhaseInstanceName'">Subphase Instance Name</xsl:when>
            <xsl:when test="name()='procedureGroupText'">Procedure Group Text</xsl:when>
            <xsl:when test="name()='procedureGroupInstanceName'">Procedure Group Instance Name</xsl:when>
            <xsl:when test="name()='procedureInstanceName'">Procedure Instance Name</xsl:when>
            <xsl:when test="name()='policyGroupText'">Policy Group Text</xsl:when>
            <xsl:when test="name()='policyGroupInstanceName'">Policy Group Instance Name</xsl:when>
            <xsl:when test="name()='policyInstanceName'">Policy Instance Name</xsl:when>
            <xsl:when test="name()='tailoringQuestionGroupText'">Tailoring Question Group Text</xsl:when>
            <xsl:when test="name()='tailoringQuestionGroupInstanceName'">Tailoring Question Group Instance Name</xsl:when>
            <xsl:when test="name()='tailoringQuestionInstanceName'">Tailoring Question Instance Name</xsl:when>
            <xsl:when test="name()='templateInstanceName'">Template Instance Name</xsl:when>
            <xsl:when test="name()='reportTemplateInstanceName'">Report Template Instance Name</xsl:when>
            <xsl:when test="name()='trialBalanceInstanceName'">Trial Balance Instance Name</xsl:when>
            <xsl:when test="name()='linkToToolInstanceName'">Link To Tool Instance Name</xsl:when>
            <xsl:when test="name()='trialBalanceNumber'">Trial Balance Number</xsl:when>
            <xsl:when test="name()='templateNumber'">Template Number</xsl:when>
            <xsl:when test="name()='reportTemplateName'">Report Template Name</xsl:when>
            <xsl:when test="name()='reportSectionName'">Report Section Name</xsl:when>
            <xsl:otherwise>Text</xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="colon">:</td>
        <td class="value"><xsl:copy-of select="./daPlainTextTranslation/child::node()"/></td>
      </tr>
  </xsl:template>
  
  <xsl:template match="procedureText | tailoringQuestionText">
  <tr>
    <td class="label">
      <xsl:choose>
        <xsl:when test="name()='procedureText'">Procedure Text</xsl:when>
        <xsl:when test="name()='tailoringQuestionText'">Tailoring Question Text</xsl:when>
        <xsl:otherwise>Text</xsl:otherwise>
      </xsl:choose>
    </td>
    <td class="colon">:</td>
    <td class="value"><xsl:copy-of select="./daRichTextTranslation/child::node()"/></td>
  </tr>
  </xsl:template>
  
  <xsl:template match="guidanceText | policyText">
    <tr>
      <td class="label">
        <xsl:choose>
          <xsl:when test="name()='guidanceText'">Guidance Text</xsl:when>
          <xsl:when test="name()='policyText'">Policy Text</xsl:when>
          <xsl:otherwise>Text</xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="colon">:</td>
      <td class="value"><xsl:apply-templates select="./daEnhancedRichTextTranslation/child::node()"/></td>
    </tr>
  </xsl:template>

  <xsl:template name="reuse">
    <tr>
      <td class="label">Reused</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:choose>
          <xsl:when test="count(./processing-instruction('renditionsReusedBy')) > 0">Yes (<xsl:value-of select="./processing-instruction('renditionsReusedBy')"/>)</xsl:when>        
          <xsl:when test="count(./guidanceBody/guidanceText/processing-instruction('renditionsReusedBy')) > 0">Yes (<xsl:value-of select="./guidanceBody/guidanceText/processing-instruction('renditionsReusedBy')"/>)</xsl:when>
          <xsl:when test="count(./policyBody/policyText/processing-instruction('renditionsReusedBy')) > 0">Yes (<xsl:value-of select="./policyBody/policyText/processing-instruction('renditionsReusedBy')"/>)</xsl:when>
          <xsl:when test="count(./procedureBody/procedureText/processing-instruction('renditionsReusedBy')) > 0">Yes (<xsl:value-of select="./procedureBody/procedureText/processing-instruction('renditionsReusedBy')"/>)</xsl:when>
          <xsl:when test="count(./tailoringQuestionBody/tailoringQuestionText/processing-instruction('renditionsReusedBy')) > 0">Yes (<xsl:value-of select="./tailoringQuestionBody/tailoringQuestionText/processing-instruction('renditionsReusedBy')"/>)</xsl:when>
          <xsl:when test="count(./subPhaseBody/subPhaseText/processing-instruction('renditionsReusedBy')) > 0">Yes (<xsl:value-of select="./subPhaseBody/subPhaseText/processing-instruction('renditionsReusedBy')"/>)</xsl:when>
          <xsl:otherwise>No</xsl:otherwise>            
        </xsl:choose>                              
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="guidanceText/daEnhancedRichTextTranslation/px/xref">
    <u><xsl:value-of select="."/></u>
  </xsl:template>
  
  
  <xsl:template match="tailoringQuestionResponses">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Responses: '"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>
 
  <xsl:template match="tailoringQuestionResponse">
    <table class="NVtable">
      <tr>
        <td class="label">Response Text</td>
        <td class="colon">:</td>
        <td class="value">
          <xsl:copy-of select="./tailoringQuestionResponseText/daPlainTextTranslation/child::node()"/>
        </td>
      </tr>
    <xsl:if test="@isDefaultResponse='true'">
      <tr>
        <td class="label">Default Response</td>
        <td class="colon">:</td>
        <td class="value">Yes</td>
      </tr>
    </xsl:if>
      <tr>
        <td class="label">Activates</td>
        <td class="colon">:</td>
        <td class="value">
          <table class="NVtable">
            <xsl:apply-templates select="./tailoringQuestionResponseActivation/child::node()"/>        
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="daActivation">
    <tr>
      <td><xsl:value-of select="."/></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
