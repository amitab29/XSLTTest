<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" >
	<xsl:import href="DITA-OT/xsl/xslhtml/dita2htmlImpl.xsl"></xsl:import>
	<xsl:import href="DITA-OT/xsl/xslhtml/taskdisplay.xsl"></xsl:import>
	<xsl:import href="DITA-OT/xsl/xslhtml/refdisplay.xsl"></xsl:import>
	<xsl:import href="DITA-OT/xsl/xslhtml/ut-d.xsl"></xsl:import>
	<xsl:import href="DITA-OT/xsl/xslhtml/sw-d.xsl"></xsl:import>
	<xsl:import href="DITA-OT/xsl/xslhtml/pr-d.xsl"></xsl:import>
	<xsl:import href="DITA-OT/xsl/xslhtml/ui-d.xsl"></xsl:import>
	<xsl:import href="DITA-OT/xsl/xslhtml/hi-d.xsl"></xsl:import>
	
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
					h7 { font-size:32pt; color: Black; }
					
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
					
					.daActivation-fixedTable {
					table-layout:fixed;
					}
					.daActivation-fitToContent {
					white-space: nowrap;
					}
					.daActivation-cellWrap {
					word-wrap:break-word;
					}
				</style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="gfcname">
		<tr>
			<td class="label">Generic Finding Category Name</td>
			<td class="colon">:</td>
			<td class="value"><xsl:value-of select="./genericFindingCategoryBody/genericFindingCategoryName/daPlainTextTranslation"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template name="concluname">
		<tr>
			<td class="label">Conclusion Name</td>
			<td class="colon">:</td>
			<td class="value"><xsl:value-of select="*//conclusionValue/daPlainTextTranslation"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="containerAssociations"><xsl:apply-templates/></xsl:template>   
	<xsl:template match="findingAssociations"><xsl:apply-templates/> </xsl:template>                
	<xsl:template match="riskFindingAssociations"><xsl:apply-templates/> </xsl:template>                  
	<xsl:template match="genericFindingCategoryAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="findingCategoryAssociations"><xsl:apply-templates/> </xsl:template>           
	<xsl:template match="linkToToolAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="phaseAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="phaseListAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="policyAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="policyGroupAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="substantiveProcedureAssoc"><xsl:apply-templates/> </xsl:template>       
	<xsl:template match="otherProcedureAssoc"><xsl:apply-templates/> </xsl:template>       
	<xsl:template match="substantiveProcedureGroupAssoc"><xsl:apply-templates/> </xsl:template>       
	<xsl:template match="otherProcedureGroupAssoc"><xsl:apply-templates/> </xsl:template>       
	<xsl:template match="reportSectionAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="reportTemplateAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="reportTemplateSectionAssoc"><xsl:apply-templates/> </xsl:template>            
	<xsl:template match="subPhaseAssoc"><xsl:apply-templates/> </xsl:template>       
	<xsl:template match="substantiveSubPhaseAssoc"><xsl:apply-templates/> </xsl:template>       
	<xsl:template match="otherSubPhaseAssoc"><xsl:apply-templates/> </xsl:template>       
	<xsl:template match="systemProcessAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="systemProcListAssociations"><xsl:apply-templates/> </xsl:template>   
	<xsl:template match="tailoringQuestionAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="tailoringQuestionGroupAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="templateAssociations"><xsl:apply-templates/> </xsl:template>
	<xsl:template match="trialBalanceAssociations"><xsl:apply-templates/> </xsl:template> 
	
	
	<xsl:template match="daParentList">
		<!--<table class="NVtable">-->
		<h2 style="font-size:16pt; color: Black;">Located In:<xsl:if test="count(child::*)=0">None</xsl:if></h2>
		<!--<hr class="title"/>--> <!-- Commenting out as part of release 2.7.1 -->
		<xsl:if test="count(child::*)>0"><xsl:apply-templates/></xsl:if>
		<!--</table>-->
	</xsl:template>
	
	<xsl:template match="daChildList">
		<!--<table class="NVtable">-->
		<h2 style="font-size:16pt; color: Black;">Supporting Content:<xsl:if test="count(child::*)=0">None</xsl:if></h2>
		<!--<hr class="title"/>--> <!-- Commenting out as part of release 2.7.1 -->
		<xsl:if test="count(child::*)>0">
			<!--<xsl:apply-templates select="./policyAssociations"/>-->
			<xsl:apply-templates/>
		</xsl:if>
		
		<!--</table>-->
	</xsl:template>
	<xsl:template match="linkToToolPath" /> 
	
	<xsl:template match="linkToToolPath" mode="inline"> 
		
		<tr>
			<td class="label">Link to Tool Path</td>
			<td class="colon">:</td>
			<td class="value"><xsl:value-of select="." /></td>
		</tr>
		
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
		<xsl:variable name="renditionType">
			<xsl:value-of select="/daRendering/processing-instruction('renditionType')"/>
		</xsl:variable>
		<!-- First traverse to the parent element -->
		<xsl:variable name="bulletStr">
			<xsl:choose>
				<xsl:when test="$renditionType='SubPhase' and not(../../parent::*)"></xsl:when>
				<xsl:when test="not(parent::*[1]!='daRendering')"></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="buildBullet" select="parent::node()" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!--  If the current node is a valid heading element calculate its index and append to the bullet string -->
			<xsl:when test="name(current())!='daParentList' and contains($headingElements,concat('|',name(current()),'|'))">
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
		<xsl:param name="level" select="0"/>
		<xsl:variable name="renditionType">
			<xsl:value-of select="/daRendering/processing-instruction('renditionType')"/>
		</xsl:variable>
		<xsl:variable name="newLevel">
			<xsl:choose>
				<!-- If the current node is a heading element and not the title element increment the level. -->
				<xsl:when test="contains($headingElements,concat('|',name(current()),'|')) and $renditionType!='SubPhase'">
					<xsl:value-of select="format-number($level,0) + 1"/>
				</xsl:when>
				<xsl:when test="contains($headingElements,concat('|',name(current()),'|')) and name(parent::*[1]) != 'daRendering' and $renditionType='SubPhase'">
					<xsl:value-of select="format-number($level,0)+ 1"/>
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
	
	<!-- <!-\- 
		* Template: name: writeHeading
		* Purpose:  Write out the html section heading.  This routine determines if the
		*           current node is the title, a heading, or just a section.  If it is the 
		*           title it constructs the title based on rules for object type: object internal
		*           name - object instance name.  If it is a heading the heading level and bullet
		*           are determined and used along with the rules for object type: object internal
		*           name - object instance name to create the heading.  If the object is just a 
		*           section label then only the heading prefix is used for the value.
		-\->
		<xsl:template name="writeHeading">
		<xsl:param name="hitPrefix" />
		<xsl:param name="headingPrefix" />
		<xsl:param name="fullorreduced" />
		<!-\-<xsl:param name="internalName" select=".//daControlAttributes/internalName"/>-\->
		<xsl:param name="internalName" select="''"/>
		<xsl:param name="instanceName" select="''"/>
		
		<xsl:variable name="renditionType">
		<xsl:value-of select="/daRendering/processing-instruction('renditionType')"/>
		</xsl:variable>
		
		<!-\- Construct the heading string -\->
		<xsl:variable name="headingValue">
		<xsl:value-of select="$headingPrefix"/><xsl:value-of select="$internalName"/>
		<xsl:if test="$instanceName != '' and $fullorreduced='reduced'"> <xsl:value-of select="$instanceName"/></xsl:if>
		</xsl:variable>
		<!-\- Get the depth for the heading -\->
		<xsl:variable name="headingDepth"><xsl:apply-templates select="current()" mode="getHeadingLevel"/></xsl:variable>
		<xsl:choose>
		<!-\- Check to see if this is the title and display accordingly -\->
		<xsl:when test="name(parent::*[1]) = 'daRendering' and $renditionType='SubPhase'">
		<!-\-<p class="title"><xsl:value-of select="$headingValue"/></p>-\->
		<p class="title"><xsl:value-of select=".//daControlAttributes/internalName"/>
		<xsl:if test="$instanceName != ''"> - <xsl:value-of select="$instanceName"/></xsl:if></p>
		<hr class="title"/>
		</xsl:when>
		
		<!-\- Check if this is a valid heading object and output the heading accordingly -\->
		<xsl:when test="$headingDepth != '0' or (name(parent::*[1]) = 'daRendering' and $renditionType!='SubPhase')">
		<xsl:variable name="headingLevel">
		<xsl:choose>
		<xsl:when test="$headingDepth > 7">h6</xsl:when>
		<xsl:when test="$headingDepth = 0">h1</xsl:when>
		<xsl:otherwise>h<xsl:value-of select="$headingDepth"/></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<xsl:variable name="bullet"><xsl:apply-templates select="current()" mode="buildBullet"></xsl:apply-templates></xsl:variable>
		<xsl:element name="{$headingLevel}"><xsl:value-of select="$bullet"/><xsl:text disable-output-escaping="yes">&#160;&#x09;</xsl:text>    
		<xsl:if test="$hitPrefix='yes'">
		<FONT color="black"
		style="BACKGROUND-COLOR: green">*HIT-</FONT></xsl:if><xsl:value-of select="$headingValue"/></xsl:element>
		</xsl:when>
		<!-\- Otherwise this is just a section label, so output the prefix -\->
		<xsl:otherwise>
		<p class="sectionHeading"><xsl:value-of select="$headingPrefix"/></p>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:template>
	-->
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
	<!--    <xsl:template match="px">
		<xsl:value-of select="."></xsl:value-of>
		</xsl:template>
	-->
	<xsl:template match="daNARD"/>
	
	<xsl:template match="daNARD" mode="nardProcessing">
		<tr>
			<td class="label">NARD</td>
			<td class="colon">:</td>
			<td class="value"><xsl:value-of select="./nardBody/nardName/daPlainTextTranslation" /></td>
		</tr>
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
	
	<xsl:template match="templatePath |trialBalancePath  | reportTemplatePath | reportSectionPath" mode="pathprocessing">
		<tr>
			<td class="label">
				<xsl:choose>
					<xsl:when test="name()='trialBalancePath'">Trial Balance File Path</xsl:when>
					<xsl:when test="name()='reportTemplatePath'">Report Template Path</xsl:when>
					<xsl:when test="name()='reportSectionPath'">Report Section Path</xsl:when>
					<xsl:when test="name()='templatePath'">Template Path</xsl:when>
					
					<xsl:otherwise>File Path</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="colon">:</td>
			<td class="value"><xsl:value-of select="./@href"  /></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="templatePath | trialBalancePath  | reportTemplatePath | reportSectionPath"/>
	
	<!--   <xsl:template match="templatePath" mode="inline">
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
		<td class="value"><xsl:value-of select="./@href"  /></td>
		</tr>
		</xsl:template>-->
	
	<!--
		** Checks if the current node has a preceding sibling AND has a parent tag named "daRendering" AND
		** preceding sibling node is not daRenditionFilters tag. If all three conditions are met then an HTML
		** tag <hr> is added to act as a horizontal separator between two items in the generated rendition
	-->
	<xsl:template name="addHorizontalRule">
		<xsl:if test="preceding-sibling::* and parent::daRendering and not(preceding-sibling::daRenditionFilters)" >
			<hr class="title" />
		</xsl:if>
	</xsl:template>
	
	<!--
		** Writes the subphaseReferenceNumber node value to the html output. If Language is "All", first instance
		** of the reference number is written to the output. If a specific language is mentioned in the <?language .. ?> 
		** processing instruction, then the translation of the subphase reference number in that language is writte
		** to the output. If a language is specified in the processing instruction but no translation of the subphase
		** reference number is available in the specified language is available then nothing is written to the html output
	-->
	<xsl:template name="writeSubphaseReferenceNum">
		<!-- Retrieve and store the language specified in the language processing 
			instruction i.e. All or Some other specific language -->
		<xsl:variable name="languageVal">
			<xsl:value-of select="//processing-instruction('language')" />
		</xsl:variable>

		<xsl:choose>
			<!-- If the item is neither a parent nor a child -->
			<xsl:when
				test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
				<xsl:choose>
					<!-- If specified language is "All" -->
					<xsl:when test="$languageVal = 'All'">
						<xsl:value-of
							select="./subPhaseAttributes/subPhaseReferenceNum/daPlainTextTranslation" />
					</xsl:when>
					<xsl:otherwise>
						<!-- Retrieve & write the instance name in the language specified in 
							the daRenditionFilter tag -->
						<xsl:value-of
							select="./subPhaseAttributes/subPhaseReferenceNum/daPlainTextTranslation[@language=$languageVal]" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
							select="./subPhaseAttributes/subPhaseReferenceNum/daPlainTextTranslation" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
</xsl:stylesheet>