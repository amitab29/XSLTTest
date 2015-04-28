<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">

  <xsl:import href="common.xsl"/>
  <xsl:output method="html" encoding="UTF-8" indent="yes"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
  <xsl:strip-space elements="*"/>

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

  <xsl:variable name="renditionType">
    <xsl:value-of select="/daRendering/processing-instruction('renditionType')"/>
  </xsl:variable>

  <xsl:template name="writeHeading">
    <xsl:param name="hitPrefix"/>
    <xsl:param name="headingPrefix"/>
    <xsl:param name="internalName" select=".//daControlAttributes/internalName"/>
    <!--<xsl:param name="internalName" select="''"/>-->
    <xsl:param name="instanceName" select="''"/>

    <!--   <xsl:variable name="renditionType">
      <xsl:value-of select="/daRendering/processing-instruction('renditionType')"/>
    </xsl:variable>
    -->
    <!-- Construct the heading string -->
    <xsl:variable name="headingValue">
      <xsl:value-of select="$headingPrefix"/>
      <xsl:value-of select="$internalName"/>
      <xsl:if test="$instanceName != ''"> - <xsl:value-of select="$instanceName"/></xsl:if>
    </xsl:variable>
    <!-- Get the depth for the heading -->
    <xsl:variable name="headingDepth">
      <xsl:apply-templates select="current()" mode="getHeadingLevel"/>
    </xsl:variable>
    <xsl:choose>
      <!-- Check to see if this is the title and display accordingly -->
      <xsl:when test="name(parent::*[1]) = 'daRendering' and $renditionType='SubPhase'">
        <!--<p class="title"><xsl:value-of select="$headingValue"/></p>-->
        <p class="title">
          <xsl:if test="$hitPrefix='yes' and $renditionType='SubPhase'">
            <FONT color="black" style="BACKGROUND-COLOR: green">*HIT-</FONT>
          </xsl:if>
          <xsl:value-of select=".//daControlAttributes/internalName"/>
          <xsl:if test="$instanceName != ''"> - <xsl:value-of select="$instanceName"/></xsl:if>
        </p>
        <!-- Commenting out the <hr> tag below for release 2.7.1 -->
        <!--<hr class="title"/>-->
      </xsl:when>

      <!-- Check if this is a valid heading object and output the heading accordingly -->
      <xsl:when
        test="$headingDepth != '0' or (name(parent::*[1]) = 'daRendering' and $renditionType!='SubPhase')">
        <xsl:variable name="headingLevel">
          <xsl:choose>
            <xsl:when test="$headingDepth > 7">h6</xsl:when>
            <xsl:when test="$headingDepth = 0">h1</xsl:when>
            <xsl:otherwise>h<xsl:value-of select="$headingDepth"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="bullet">
          <xsl:apply-templates select="current()" mode="buildBullet"/>
        </xsl:variable>
        <xsl:element name="{$headingLevel}">
          <xsl:value-of select="$bullet"/>
          <xsl:text disable-output-escaping="yes">&#160;&#x09;</xsl:text>
          <xsl:if test="$hitPrefix='yes' and $renditionType='SubPhase'">
            <FONT color="black" style="BACKGROUND-COLOR: green">*HIT-</FONT>
          </xsl:if>
          <xsl:value-of select="$headingValue"/>
        </xsl:element>
      </xsl:when>
      <!-- Otherwise this is just a section label, so output the prefix -->
      <xsl:otherwise>
        <p class="sectionHeading">
          <xsl:value-of select="$headingPrefix"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:if test="$headingDepth = 0">
      <xsl:if test="($renditionType = 'SubPhase' or $renditionType = 'Manual') and parent::daRendering">
        <hr class="title" />
      </xsl:if>
    </xsl:if>
    
  </xsl:template>

  <!-- start rule for daPhase content item -->
  <xsl:template match="daPhase">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Phase: '"/>
      <xsl:with-param name="internalName" select=".//daControlAttributes/internalName"/>
      <xsl:with-param name="instanceName" select=".//phaseInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daParentList'])>0">
              <xsl:apply-templates select=".//subPhaseAttributes/subPhaseInstanceName"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//subPhaseBody/subPhaseText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="phase"/>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//phaseAttributes/phaseInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//phaseBody/phaseText"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select=".//phaseAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daPhase content item -->

  <!-- start rule for daSubPhase content item -->
  <xsl:template match="daSubPhase">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'SubPhase: '"/>
      <xsl:with-param name="internalName" select=".//daControlAttributes/internalName"/>
      <xsl:with-param name="instanceName" select=".//subPhaseInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daParentList'])>0">
              <xsl:apply-templates select=".//subPhaseAttributes/subPhaseInstanceName"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//subPhaseBody/subPhaseText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="subphase"/>
              <xsl:apply-templates select=".//subPhaseAttributes/subPhaseInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//subPhaseAssoc/daAccount" mode="accountProcessing"/>
              <xsl:apply-templates select=".//subPhaseBody/subPhaseText"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./subPhaseAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daSubPhase content item -->

  <!-- start rule for daOtherSubPhase content item -->
  <xsl:template match="daOtherSubPhase">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Other SubPhase: '"/>
      <xsl:with-param name="instanceName" select=".//subPhaseInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		  <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              	<xsl:call-template name="subphase"/>	
				<xsl:apply-templates select=".//subPhaseAttributes/subPhaseInstanceName"/>
	        </xsl:when>
		  </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//subPhaseBody/subPhaseText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="subphase"/>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//subPhaseAttributes/subPhaseInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <!-- <xsl:choose>
                <xsl:when test="count(child::*[name()='daChildList'])>0">
                <xsl:apply-templates select="daChildList/otherSubPhaseAssoc/daNARD" mode="nardProcessing"/>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates select="otherSubPhaseAssoc/daNARD" mode="nardProcessing"/>
                </xsl:otherwise>
                </xsl:choose>-->
              <xsl:apply-templates select=".//otherSubPhaseAssoc/daNARD" mode="nardProcessing"/>
              <xsl:apply-templates select=".//subPhaseBody/subPhaseText"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./otherSubPhaseAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daOtherSubPhase content item -->

  <!-- start rule for daSubstantiveSubPhase content item -->
  <xsl:template match="daSubstantiveSubPhase">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Substantive SubPhase: '"/>
      <xsl:with-param name="instanceName" select=".//subPhaseInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		  <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              	<xsl:call-template name="subphase"/>	
				<xsl:apply-templates select=".//subPhaseAttributes/subPhaseInstanceName"/>
			</xsl:when>
			</xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//subPhaseBody/subPhaseText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="subphase"/>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//subPhaseAttributes/subPhaseInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <table class="NVtable">
          <xsl:apply-templates select=".//substantiveSubPhaseAssoc/daAccount"
            mode="accountProcessing"/>
          <xsl:apply-templates select=".//substantiveSubPhaseAssoc/daNARD" mode="nardProcessing"/>
          <xsl:apply-templates select=".//subPhaseBody/subPhaseText"/>
        </table>
        <xsl:apply-templates select="./substantiveSubPhaseAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daSubstantiveSubPhase content item -->

  <!-- start rule for daOtherProcedureGroup content item -->
  <xsl:template match="daOtherProcedureGroup">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Other Procedure Group: '"/>
      <xsl:with-param name="instanceName" select=".//procedureGroupInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		 <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">	
				<xsl:apply-templates select=".//procedureGroupAttributes/procedureGroupInstanceName"/>
		    </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//procedureGroupBody/procedureGroupText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//procedureGroupAttributes/procedureGroupInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//procedureGroupBody/procedureGroupText"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./otherProcedureGroupAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daOtherProcedureGroup content item -->

  <!-- start rule for daSubstantiveProcedureGroup content item -->
  <xsl:template match="daSubstantiveProcedureGroup">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Substantive Procedure Group: '"/>
      <xsl:with-param name="instanceName" select=".//procedureGroupInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		  <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">	
				<xsl:apply-templates select=".//procedureGroupAttributes/procedureGroupInstanceName"/>
	        </xsl:when>
		  </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//procedureGroupBody/procedureGroupText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//procedureGroupAttributes/procedureGroupInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//substantiveProcedureGroupAssoc/daAccount"
                mode="accountProcessing"/>
              <xsl:apply-templates select=".//procedureGroupBody/procedureGroupText"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./substantiveProcedureGroupAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daSubstantiveProcedureGroup content item -->

  <!-- start rule for daOtherProcedure content item -->
  <xsl:template match="daOtherProcedure">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Other Procedure: '"/>
      <xsl:with-param name="instanceName" select=".//procedureInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		  <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">	
				<xsl:apply-templates select=".//otherProcedureAttributes/procedureInstanceName"/>
	        </xsl:when>
		  </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
			  <xsl:apply-templates select=".//procedureBody/procedureText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
              <xsl:apply-templates select="./otherProcedureAttributes"/>
            </xsl:when>
          </xsl:choose>		  
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <!--<table class="NVtable">-->
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//otherProcedureAttributes/procedureInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:apply-templates select="./otherProcedureAttributes"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//otherProcedureAssoc/daNARD" mode="nardProcessing"/>
              <xsl:apply-templates select=".//procedureBody/procedureText"/>
            </table>
            <xsl:apply-templates select="./procedurePreconditions/daPrecondition"/>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./otherProcedureAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daOtherProcedure content item -->

  <!-- start rule for daSubstantiveProcedure content item -->
  <xsl:template match="daSubstantiveProcedure">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Substantive Procedure: '"/>
      <xsl:with-param name="instanceName" select=".//procedureInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		  <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">	
				<xsl:apply-templates select=".//substantiveProcAttributes/procedureInstanceName"/>
	        </xsl:when>
		  </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
			  <xsl:apply-templates select=".//procedureBody/procedureText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
			  <xsl:apply-templates select=".//substantiveProcAttributes"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <!--<table class="NVtable">-->
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//substantiveProcAttributes/procedureInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:apply-templates select=".//substantiveProcAttributes"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <!--</table>-->
              <xsl:apply-templates select=".//substantiveProcedureAssoc/daAccount"
                mode="accountProcessing"/>
              <xsl:apply-templates select=".//procedureBody/procedureText"/>
            </table>
            <xsl:apply-templates select="./procedurePreconditions/daPrecondition"/>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./substantiveProcedureAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daSubstantiveProcedure content item -->

  <!-- start rule for daTailoringQuestionGroup content item -->
  <xsl:template match="daTailoringQuestionGroup">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Tailoring Question Group: '"/>
      <xsl:with-param name="instanceName" select=".//tailoringQuestionGroupInstanceName"/>
    </xsl:call-template>
    <table class="NVtable">
	   <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">	
				<xsl:apply-templates
            select=".//tailoringQuestionGroupAttributes/tailoringQuestionGroupInstanceName"/>
	        </xsl:when>
	  </xsl:choose>
      <xsl:choose>
        <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
          <xsl:apply-templates select=".//tailoringQuestionGroupBody/tailoringQuestionGroupText"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when
          test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
          <xsl:call-template name="parentchildcontroldata"/>
          <xsl:call-template name="publishdate"/>
        </xsl:when>
      </xsl:choose>
    </table>
    <xsl:choose>
      <xsl:when
        test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
        <table class="NVtable">
          <xsl:call-template name="intnanme"/>
          <xsl:apply-templates
            select=".//tailoringQuestionGroupAttributes/tailoringQuestionGroupInstanceName"/>
          <xsl:call-template name="controldata"/>
          <xsl:call-template name="reuse"/>
          <xsl:call-template name="cui"/>
          <xsl:call-template name="authorNotes"/>
          <xsl:apply-templates select=".//tailoringQuestionGroupBody/tailoringQuestionGroupText"/>
        </table>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="./tailoringQuestionGroupAssociations/child::node()"/>
    <xsl:apply-templates select="./daChildList"/>
    <xsl:apply-templates select="./daParentList"/>

  </xsl:template>
  <!-- end rule for daTailoringQuestionGroup content item -->

  <!-- start rule for daTailoringQuestion content item -->
  <xsl:template match="daTailoringQuestion">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Tailoring Question: '"/>
      <xsl:with-param name="instanceName" select=".//tailoringQuestionInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
			<xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">	
				<xsl:apply-templates
                select=".//tailoringQuestionAttributes/tailoringQuestionInstanceName"/>
	        </xsl:when>
		  </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//tailoringQuestionBody/tailoringQuestionText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
              <xsl:apply-templates select="./tailoringQuestionAttributes"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates
                select=".//tailoringQuestionAttributes/tailoringQuestionInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:apply-templates select="./tailoringQuestionAttributes"/>
			  
              <xsl:if test="./tailoringQuestionAttributes/tailoringQuestionSummaryView = 1">
                <tr>
                  <td class="label">Tailoring Question Summary View</td>
                  <td class="colon">:</td>
                  <td class="value">Yes</td>
                </tr>
              </xsl:if>
              
              <xsl:if test="./tailoringQuestionAttributes/tailoringQuestionSummaryView = 0">
                <tr>
                  <td class="label">Tailoring Question Summary View</td>
                  <td class="colon">:</td>
                  <td class="value">No</td>
                </tr>
              </xsl:if>
              
              <xsl:if test="./tailoringQuestionAttributes/tailoringQuestionDashboardView = 1">
                <tr>
                  <td class="label">Tailoring Question Dashboard View</td>
                  <td class="colon">:</td>
                  <td class="value">Yes</td>
                </tr>
              </xsl:if>
              
              <xsl:if test="./tailoringQuestionAttributes/tailoringQuestionDashboardView = 0">
                <tr>
                  <td class="label">Tailoring Question Dashboard View</td>
                  <td class="colon">:</td>
                  <td class="value">No</td>
                </tr>
              </xsl:if>
              
              <tr>
                <td class="label">TQ Type</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:apply-templates
                    select="./tailoringQuestionAttributes/tailoringQuestionDisplayType"/>
                </td>
              </tr>
              <!--<xsl:call-template name="reuse"/>-->
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
            <table class="NVtable">
              <xsl:apply-templates select=".//tailoringQuestionBody/tailoringQuestionText"/>
            </table>
            <xsl:apply-templates select="./tailoringQuestionResponses"/>
            <!--</table>-->
            <xsl:apply-templates select="./tailoringQuestionPreconditions/daPrecondition"/>
          </xsl:when>
        </xsl:choose>
        <!--</table>-->
        <xsl:apply-templates select="./tailoringQuestionAssociations/child::node()"/>
        <!--</table>-->
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
        <!-- </table>-->
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daTailoringQuestion content item -->

  <!-- start rule for daGenericFindingCategory content item -->
  <xsl:template match="daGenericFindingCategory">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Generic Finding Category: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when
        test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
        <table class="NVtable">
          <xsl:call-template name="parentchildcontroldata"/>
          <xsl:call-template name="publishdate"/>
        </table>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when
        test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
        <table class="NVtable">
          <xsl:call-template name="gfcname"/>
          <xsl:call-template name="intnanme"/>
          <xsl:call-template name="controldata"/>
          <xsl:call-template name="cui"/>
          <xsl:call-template name="authorNotes"/>
        </table>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="./genericFindingCategoryAssociations/child::node()"/>
    <xsl:apply-templates select="./daChildList"/>
    <xsl:apply-templates select="./daParentList"/>

  </xsl:template>
  <!-- end rule for daGenericFindingCategory content item -->

  <!-- start rule for daControlDeviationFinding content item -->
  <xsl:template match="daControlDeviationFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Control Deviation Finding: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./findingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
        <!-- </table>-->
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daControlDeviationFinding content item -->

  <!-- start rule for daControlDeficiencyFinding content item -->
  <xsl:template match="daControlDeficiencyFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Control Deficiency Finding: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./findingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daControlDeficiencyFinding content item -->

  <!-- start rule for daSignificantDeficiencyFinding content item -->
  <xsl:template match="daSignificantDeficiencyFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Significant Deficiency Finding: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./findingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daSignificantDeficiencyFinding content item -->

  <!-- start rule for daMaterialWeaknessFinding content item -->
  <xsl:template match="daMaterialWeaknessFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Material Weakness Finding: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./findingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daMaterialWeaknessFinding content item -->

  <!-- start rule for daDisclosureDeficiencyFinding content item -->
  <xsl:template match="daDisclosureDeficiencyFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Disclosure Deficiency Finding: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./findingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daDisclosureDeficiencyFinding content item -->

  <!-- start rule for daMisstatementFinding content item -->
  <xsl:template match="daMisstatementFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Misstatement Finding: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./findingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daMisstatementFinding content item -->

  <!-- start rule for daSigDocumentationMatterFinding content item -->
  <xsl:template match="daSigDocumentationMatterFinding">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Sig Documentation Matter Finding: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./findingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>

  </xsl:template>
  <!-- end rule for daSigDocumentationMatterFinding content item -->

  <!-- start rule for daEngmtSignificantRiskPervasive  content item -->
  <xsl:template match="daEngmtSignificantRiskPervasive">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Engmt Significant Risk Pervasive: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
            <xsl:apply-templates select="./riskFindingAssociations/child::node()"/>
            <xsl:apply-templates select="./daChildList"/>
            <xsl:apply-templates select="./daParentList"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daEngmtSignificantRiskPervasive  content item -->

  <!-- start rule for daEngmtSignificantRiskSpecific  content item -->
  <xsl:template match="daEngmtSignificantRiskSpecific">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Engmt Significant Risk Specific: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./riskFindingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daEngmtSignificantRiskSpecific  content item -->

  <!-- start rule for daEngmtSignificantRiskIT  content item -->
  <xsl:template match="daEngmtSignificantRiskIT">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Engmt Significant Risk IT: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./riskFindingAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daEngmtSignificantRiskIT  content item -->

  <!-- start rule for daSignificantRisk  content item -->
  <xsl:template match="daSignificantRisk">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Significant Risk: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
             <!-- 
			  <tr>
                <td class="label">Significant Risk Title</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of
                    select=".//significantRiskBody/significantRiskTitle/daPlainTextTranslation"/>
                </td>
              </tr>
              <tr>
                <td class="label">Significant Risk Description</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of
                    select=".//significantRiskBody/significantRiskDescription/daPlainTextTranslation"
                  />
                </td>
              </tr>
               -->
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <tr>
                <td class="label">Significant Risk Title</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of
                    select=".//significantRiskBody/significantRiskTitle/daPlainTextTranslation"/>
                </td>
              </tr>
              <tr>
                <td class="label">Significant Risk Description</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of
                    select=".//significantRiskBody/significantRiskDescription/daPlainTextTranslation"
                  />
                </td>
              </tr>
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="./riskFindingAssociations/child::node()"/>
    <xsl:apply-templates select="./daChildList"/>
    <xsl:apply-templates select="./daParentList"/>
  </xsl:template>
  <!-- end rule for daSignificantRisk  content item -->

  <!-- start rule for daConclusion  content item -->
  <xsl:template match="daConclusion">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Conclusion: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="concluname"/>
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
            <xsl:apply-templates select="./daChildList"/>
            <xsl:apply-templates select="./daParentList"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daConclusion  content item -->

  <!-- start rule for daSystemProcess  content item -->
  <xsl:template match="daSystemProcess">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'System Process: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
			 <!-- 
			 <tr>
                <td class="label">System Process Name</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of
                    select=".//systemProcessBody/systemProcessName/daPlainTextTranslation"/>
                </td>
              </tr>
               -->
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <tr>
                <td class="label">System Process Name</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of
                    select=".//systemProcessBody/systemProcessName/daPlainTextTranslation"/>
                </td>
              </tr>
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./systemProcessAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daSystemProcess  content item -->

  <!-- start rule for daPhaseList  content item -->
  <xsl:template match="daPhaseList">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Phase List: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <tr>
                <td class="label">Phase List Name</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of select=".//phaseListBody/phaseListName/daPlainTextTranslation"/>
                </td>
              </tr>
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./phaseListAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>

      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daPhaseList  content item -->

  <!-- start rule for daSystemProcessList  content item -->
  <xsl:template match="daSystemProcessList">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'System Process List: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <tr>
                <td class="label">System Process List Name</td>
                <td class="colon">:</td>
                <td class="value">
                  <xsl:value-of
                    select=".//systemProcessListBody/systemProcessListName/daPlainTextTranslation"/>
                </td>
              </tr>
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./systemProcListAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daSystemProcessList  content item -->

  <!-- start rule for daLinkToTool content item -->
  <xsl:template match="daLinkToTool">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Link To Tool: '"/>
      <xsl:with-param name="instanceName" select=".//linkToToolInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//linkToToolAttributes/linkToToolInstanceName"/>
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:apply-templates select=".//linkToToolAssociations/linkToToolPath" mode="inline"/>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//linkToToolAttributes/linkToToolInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:call-template name="cui"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./linkToToolAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
        <!--</table>-->
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daLinkToTool content item -->

  <!-- start rule for daTrialBalance content item -->
  <xsl:template match="daTrialBalance">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Trial Balance: '"/>
      <xsl:with-param name="instanceName" select=".//trialBalanceInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
               <xsl:apply-templates select=".//trialBalanceAttributes/trialBalanceInstanceName"/>
           	   <xsl:apply-templates select=".//trialBalanceBody/trialBalanceNumber"/>
               <xsl:call-template name="parentchildcontroldata"/>
               <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:apply-templates select=".//trialBalanceAssociations/trialBalancePath"
                mode="pathprocessing"/>
              <xsl:apply-templates select=".//trialBalanceBody/trialBalanceNumber"/>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//trialBalanceAttributes/trialBalanceInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:call-template name="cui"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./trialBalanceAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daTrialBalance content item -->

  <!-- start rule for daTemplate content item -->
  <xsl:template match="daTemplate">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Template: '"/>
      <xsl:with-param name="instanceName" select=".//templateInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when test="count(ancestor::*[name()='daChildList'])>0 or count(ancestor::*[name()='daParentList'])>0">
            <table class="NVtable">
              <xsl:apply-templates select=".//templateAttributes/templateInstanceName"/>
              <xsl:apply-templates select=".//templateBody/templateNumber"/>
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:apply-templates select=".//templateBody/templateNumber"/>
              <xsl:apply-templates select=".//templateAssociations/templatePath"
                mode="pathprocessing"/>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//templateAttributes/templateInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:call-template name="cui"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./templateAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daTemplate content item -->

  <!-- start rule for daReportTemplate content item -->
  <xsl:template match="daReportTemplate">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Report Template: '"/>
      <xsl:with-param name="instanceName" select=".//reportTemplateInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
           <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0">
              <xsl:apply-templates select=".//reportTemplateAttributes/reportTemplateInstanceName"/>
              <!-- <xsl:apply-templates select=".//reportTemplateBody/reportTemplateName"/> -->
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
              <xsl:apply-templates select=".//reportTemplateBody/reportTemplateName"/>
              <xsl:apply-templates select=".//reportTemplateAssociations/reportTemplatePath"
                mode="pathprocessing"/>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//reportTemplateAttributes/reportTemplateInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:call-template name="cui"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:apply-templates select="./reportTemplateAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daReportTemplate content item -->

  <!-- start rule for daReportTemplateWithSections content item -->
  <xsl:template match="daReportTemplateWithSections">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Report Template With Sections: '"/>
      <xsl:with-param name="instanceName" select=".//reportTemplateInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0">
              <xsl:apply-templates select=".//reportTemplateAttributes/reportTemplateInstanceName"/>
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
      <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <tr>
                <td class="label">Report Template with Section Name</td>
                <td class="colon">:</td>
                <td>
                  <xsl:value-of select=".//reportTemplateBody/reportTemplateName"/>
                </td>
              </tr>
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//reportTemplateAttributes/reportTemplateInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:call-template name="cui"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./reportTemplateSectionAssoc/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daReportTemplateWithSections content item -->

  <!-- start rule for daReportSection content item -->
  <xsl:template match="daReportSection">
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Report Section: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <xsl:choose>
          <xsl:when
            test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
            <table class="NVtable">
			  <!-- <xsl:apply-templates select=".//reportSectionBody/reportSectionName"/>  -->
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </table>
          </xsl:when>
        </xsl:choose>
		
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:apply-templates select=".//reportSectionAssociations/reportSectionPath" mode="pathprocessing"/>
			  <xsl:apply-templates select=".//reportSectionBody/reportSectionName"/>
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:call-template name="cui"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./reportSectionAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daReportSection content item -->

  <!-- start rule for daPolicyGroup content item -->
  <xsl:template match="daPolicyGroup">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Policy Group: '"/>
      <xsl:with-param name="instanceName" select=".//policyGroupInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		  <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//policyGroupAttributes/policyGroupInstanceName"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//policyGroupBody/policyGroupText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//policyGroupAttributes/policyGroupInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//policyGroupBody/policyGroupText"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./policyGroupAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daPolicyGroup content item -->

  <!-- start rule for daPolicy content item -->
  <xsl:template match="daPolicy">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Policy: '"/>
      <xsl:with-param name="instanceName" select=".//policyInstanceName"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
		<xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//policyAttributes/policyInstanceName"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
			  <xsl:apply-templates select=".//policyBody/policyText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:apply-templates select=".//policyAttributes/policyInstanceName"/>
              <xsl:call-template name="controldata"/>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//policyBody/policyText"/>
            </table>
            <!-- precondition details -->
            <xsl:apply-templates select="./policyPreconditions/daPrecondition"/>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./policyAssociations/child::node()"/>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daPolicy content item -->

  <!-- start rule for daGuidance content item -->
  <xsl:template match="daGuidance">
    <xsl:call-template name="addHorizontalRule"/>
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="hitPrefix" select="processing-instruction('textMatch')"/>
      <xsl:with-param name="headingPrefix" select="'Guidance: '"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="count(./processing-instruction('showOnlyHeader')) &lt; 1">
        <table class="NVtable">
          <xsl:choose>
            <xsl:when test="count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:apply-templates select=".//guidanceBody/guidanceText"/>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when
              test="count(ancestor::*[name()='daParentList'])>0 or count(ancestor::*[name()='daChildList'])>0 ">
              <xsl:call-template name="parentchildcontroldata"/>
              <xsl:call-template name="publishdate"/>
            </xsl:when>
          </xsl:choose>
        </table>
        <xsl:choose>
          <xsl:when
            test="(not(count(ancestor::*[name()='daParentList'])>0) and not(count(ancestor::*[name()='daChildList'])>0 ))">
            <table class="NVtable">
              <xsl:call-template name="intnanme"/>
              <xsl:call-template name="controldata"/>
              <xsl:if test="./guidanceAttributes/extendedGuidance = 1">
                <tr>
                  <td class="label">Extended guidance</td>
                  <td class="colon">:</td>
                  <td class="value">Yes</td>
                </tr>
              </xsl:if>
              <xsl:call-template name="reuse"/>
              <xsl:call-template name="cui"/>
              <xsl:call-template name="authorNotes"/>
              <xsl:apply-templates select=".//guidanceBody/guidanceText"/>
            </table>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="./daChildList"/>
        <xsl:apply-templates select="./daParentList"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- end rule for daGuidance -->

  <!-- start phase reference number -->
  <xsl:template name="phase">
    <tr>
      <td class="label">Reference Number</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./phaseAttributes/phaseReferenceNum"/>
      </td>
    </tr>
  </xsl:template>
  <!-- end subphase reference number -->

  <!-- start subphase reference number -->
  <xsl:template name="subphase">
    <tr>
      <td class="label">Subphase Reference Number</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:call-template name="writeSubphaseReferenceNum" />
      </td>
    </tr>
  </xsl:template>
  <!-- end subphase reference number -->

  <!-- start rule for controldata content item -->
  <xsl:template name="intnanme">
    <tr>
      <td class="label">Internal Name</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./daControlAttributes/internalName"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="parentchildcontroldata">
    <tr>
      <td class="label">CMS ID</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./@id"/>
      </td>
    </tr>
    <tr>
      <td class="label">Version Number</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./daControlAttributes/sourceVersionNum"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="controldata">
    <!-- CMS 2.7 - removed internal reference number
      <tr>
      <td class="label">Internal Reference Number</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./daControlAttributes/internalRefNum" /></td>
      </tr>
    -->
    <!--    <tr>
      <td class="label">Internal Name</td>
      <td class="colon">:</td>
      <td class="value"><xsl:value-of select="./daControlAttributes/internalName" /></td>
      </tr>-->
    <tr>
      <td class="label">Source Content Domain</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./daControlAttributes/sourceContentDomain"/>
      </td>
    </tr>
    <tr>
      <td class="label">CMS ID</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./@id"/>
      </td>
    </tr>
    <tr>
      <td class="label">Version Number</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./daControlAttributes/sourceVersionNum"/>
      </td>
    </tr>
    <tr>
      <td class="label">Effective In</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./daControlAttributes/effectiveIn"/>
      </td>
    </tr>
    <tr>
      <td class="label">Recall From</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./daControlAttributes/recalledFrom"/>
      </td>
    </tr>
	
	<!--  CMS_HIDDEN Removed as part of 3.1       
    <tr>
      <td class="label">Content Hidden</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:variable name="hiddenFlag" select="./daControlAttributes/contentHidden/text()"/>
        <xsl:choose>
          <xsl:when test="$hiddenFlag='1'">True</xsl:when>
          <xsl:otherwise>False</xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
	END   -->
	
	<!--added CMS_HIDDEN_FOR attribute display as part of 3.1 START-->
	<tr>
      <td class="label">Hidden For</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:choose>
          <xsl:when test="count(./processing-instruction('CountryHiddenFor')) > 0">
            <xsl:value-of select="./processing-instruction('CountryHiddenFor')"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </td>
    </tr>
	
	<tr>
      <td class="label">Content Source</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:choose>
          <xsl:when test="count(./processing-instruction('ContentSource')) > 0">
            <xsl:value-of select="./processing-instruction('ContentSource')"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </td>
    </tr>
	<!--added CMS_HIDDEN_FOR attribute display as part of 3.1  END-->
	
	
	
    <tr>
      <td class="label" style="padding-bottom:10px;">Reason Code</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value" style="padding-bottom:10px;">
        <xsl:apply-templates select="./daControlAttributes/controlData/reasonCode"/>
      </td>
    </tr>
    <tr>
      <td class="label" style="padding-bottom:10px;">Industry</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value" style="padding-bottom:10px;">
        <xsl:apply-templates select="./daControlAttributes/controlData/industry"/>
      </td>
    </tr>
    <tr>
      <td class="label" style="padding-bottom:10px;">Engagement Type</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value" style="padding-bottom:10px;">
        <xsl:apply-templates select="./daControlAttributes/controlData/engagementType"/>
      </td>
    </tr>
    <!-- <tr>
      <td class="label" style="padding-bottom:10px;">Content Update Indicator</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value"><xsl:variable name="cuiFlag" select="./daControlAttributes/libraryContentUpdate/text()"/>
      <xsl:choose>
      <xsl:when test="cuiFlag='1'">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
      </xsl:choose>      
      </td>
      </tr>-->
    <!--   <tr>
      <td class="label" style="padding-bottom:10px;">Author Notes</td>
      <td class="colon" style="padding-bottom:10px;">:</td>
      <td class="value" style="padding-bottom:10px;"><xsl:apply-templates select="./daControlAttributes/authorNotes"/></td>
      </tr> -->
  </xsl:template>

  <xsl:template match="tailoringQuestionAttributes">
    <tr>
      <td class="label">Scalability</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:apply-templates select="./tailoringQuestionScalability"/>
      </td>
    </tr>
    <!--  <tr>
      <td class="label">TQ Display Type</td>
      <td class="colon">:</td>
      <td class="value"><xsl:apply-templates select="./tailoringQuestionDisplayType" /></td>
      </tr>      -->
  </xsl:template>

  <xsl:template match="otherProcedureAttributes">
    <tr>
      <td class="label">Scalability</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:apply-templates select="./procedureScalability"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="substantiveProcAttributes">
    <tr>
      <td class="label">Scalability</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:apply-templates select="./procedureScalability"/>
      </td>
    </tr>
    <tr>
      <td class="label">Assertion</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:apply-templates select="./procedureAssertion"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template
    match="tailoringQuestionDisplayType | tailoringQuestionScalability | procedureScalability | procedureAssertion">
    <xsl:value-of select="."/>
    <xsl:if test="position()!=last()">; </xsl:if>
  </xsl:template>

  <xsl:template match="reasonCode|industry|engagementType">
    <xsl:value-of select="."/>
    <xsl:if test="position()!=last()">; </xsl:if>
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
      <!--<h4>Preconditions</h4>-->
      <h4>Activated By</h4>
    </xsl:if>
    <table class="NVtable">
      <tr>
        <td class="label">CMS ID</td>
        <td class="colon">:</td>
        <td class="value">
          <xsl:value-of select="./@tqId"/>
        </td>
      </tr>
      <tr>
        <td class="label">Internal Name</td>
        <td class="colon">:</td>
        <td class="value">
          <xsl:value-of select="./@internalName"/>
        </td>
      </tr>
      <tr>
        <td class="label">Instance Name</td>
        <td class="colon">:</td>
        <td class="value">
          <xsl:value-of select="./@instanceName"/>
        </td>
      </tr>
      <!--    <tr>
        <td class="label">TQ Text Name</td>
        <td class="colon">:</td>
        <td class="value"><xsl:value-of  select="substring-before($precondition1,'{?}')" />
        </td>
      </tr>  -->
      <tr>
        <td class="label">Response Text</td>
        <td class="colon">:</td>
        <td class="value">
          <xsl:value-of select="./@responseText"/>
        </td>
      </tr>
    </table>
    <br/>
  </xsl:template>


  <xsl:template match="ref">
    <p>
      <FONT style="BACKGROUND-COLOR: #d3d3d3">
        <xsl:value-of select="."/>
      </FONT>
    </p>
  </xsl:template>

  <xsl:template match="sourceContentDomain | sourceVersionNum">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="daRenditionFilters">
    <!-- CMS 2.7 - Filtering Options removed from renditions -->
    <xsl:if test="$renditionType='SubPhase' or $renditionType='Manual'">
      <table class="NVtable">
        <xsl:apply-templates/>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="daRenditionFilter">
    <tr>
      <td class="label">
        <xsl:value-of select="@filterName"/>
      </td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="@filterValue"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template
    match="phaseText | phaseInstanceName | subPhaseText | subPhaseInstanceName |
    procedureGroupText | procedureGroupInstanceName | procedureInstanceName |
    policyGroupText | policyGroupInstanceName | policyInstanceName |
    tailoringQuestionGroupText | tailoringQuestionGroupInstanceName |tailoringQuestionInstanceName |
    templateInstanceName | reportTemplateInstanceName | trialBalanceInstanceName | linkToToolInstanceName |
    trialBalanceNumber | templateNumber | reportTemplateName |reportSectionName">
    <tr>
      <td class="label">
        <xsl:choose>
          <xsl:when test="name()='phaseText'">Text</xsl:when>
          <xsl:when test="name()='phaseInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='subPhaseText'">Text</xsl:when>
          <xsl:when test="name()='subPhaseInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='procedureGroupText'">Text</xsl:when>
          <xsl:when test="name()='procedureGroupInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='procedureInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='policyGroupText'">Text</xsl:when>
          <xsl:when test="name()='policyGroupInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='policyInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='tailoringQuestionGroupText'">Text</xsl:when>
          <xsl:when test="name()='tailoringQuestionGroupInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='tailoringQuestionInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='templateInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='reportTemplateInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='trialBalanceInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='linkToToolInstanceName'">Instance Name</xsl:when>
          <xsl:when test="name()='trialBalanceNumber'">Trial Balance Number</xsl:when>
          <xsl:when test="name()='templateNumber'">Template Number</xsl:when>
          <xsl:when test="name()='reportTemplateName'">Report Template Name</xsl:when>
          <xsl:when test="name()='reportSectionName'">Report Section Name</xsl:when>
          <!--  <xsl:when test="contains(name(),'Text')">Text</xsl:when>
            <xsl:when test="contains(name(),'Instance')">Instance Name</xsl:when>-->
          <xsl:otherwise>Text</xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="colon">:</td>
      <td class="value">
        <!--<xsl:copy-of select="./daPlainTextTranslation/child::node()"/>-->
        <xsl:for-each select="./daPlainTextTranslation">
          <xsl:value-of select="."/>
          <xsl:text>&#xA0;</xsl:text>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="procedureText | tailoringQuestionText">
    <tr>
      <td class="label">
        <xsl:choose>
          <xsl:when test="name()='procedureText'">Text</xsl:when>
          <xsl:when test="name()='tailoringQuestionText'">Text</xsl:when>
          <xsl:otherwise>Text</xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:copy-of select="./daRichTextTranslation/child::node()"/>
      </td>
      <!--      <td class="value"><xsl:value-of select="."/></td>-->
    </tr>
  </xsl:template>

  <xsl:template match="guidanceText | policyText">
    <tr>
      <td class="label">
        <xsl:choose>
          <xsl:when test="name()='guidanceText'">Text</xsl:when>
          <xsl:when test="name()='policyText'">Text</xsl:when>
          <xsl:otherwise>Text</xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:apply-templates select="./daEnhancedRichTextTranslation/child::node()"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="reuse">
    <tr>
      <td class="label">Reused</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:choose>
          <xsl:when test="count(./processing-instruction('renditionsReusedBy')) > 0">Yes
              (<xsl:value-of select="./processing-instruction('renditionsReusedBy')"/>)</xsl:when>
          <xsl:when
            test="count(./guidanceBody/guidanceText/processing-instruction('renditionsReusedBy')) > 0"
            >Yes (<xsl:value-of
              select="./guidanceBody/guidanceText/processing-instruction('renditionsReusedBy')"
            />)</xsl:when>
          <xsl:when
            test="count(./policyBody/policyText/processing-instruction('renditionsReusedBy')) > 0"
            >Yes (<xsl:value-of
              select="./policyBody/policyText/processing-instruction('renditionsReusedBy')"
            />)</xsl:when>
          <xsl:when
            test="count(./procedureBody/procedureText/processing-instruction('renditionsReusedBy')) > 0"
            >Yes (<xsl:value-of
              select="./procedureBody/procedureText/processing-instruction('renditionsReusedBy')"
            />)</xsl:when>
          <xsl:when
            test="count(./tailoringQuestionBody/tailoringQuestionText/processing-instruction('renditionsReusedBy')) > 0"
            >Yes (<xsl:value-of
              select="./tailoringQuestionBody/tailoringQuestionText/processing-instruction('renditionsReusedBy')"
            />)</xsl:when>
          <xsl:when
            test="count(./subPhaseBody/subPhaseText/processing-instruction('renditionsReusedBy')) > 0"
            >Yes (<xsl:value-of
              select="./subPhaseBody/subPhaseText/processing-instruction('renditionsReusedBy')"
            />)</xsl:when>
          <xsl:otherwise>No</xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="cui">
    <tr>
      <td class="label">Content Update Indicator</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:choose>
          <xsl:when test="./daControlAttributes/libraryContentUpdate > 0">Yes</xsl:when>
          <xsl:otherwise>No</xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="authorNotes">
    <tr>
      <td class="label">Author Notes</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:value-of select="./daControlAttributes/authorNotes"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="guidanceText/daEnhancedRichTextTranslation/px/xref">
    <u>
      <xsl:value-of select="."/>
    </u>
  </xsl:template>

  <xsl:template match="tailoringQuestionResponses">
    <!-- <table class="NVtable">-->
    <xsl:call-template name="writeHeading">
      <xsl:with-param name="headingPrefix" select="'Responses: '"/>
    </xsl:call-template>

    <!--<table class="NVtable">-->
    <!--  <tr>
      <td class="label">Responses</td>
      <td class="colon">:</td>
      </tr> -->
    <xsl:apply-templates/>
    <!--</table>-->
  </xsl:template>

  <xsl:template match="tailoringQuestionResponse">
    <table class="NVtable">
      <tr>
        <td class="label">Response Text</td>
        <td class="colon">:</td>
        <td class="value">
          <!--<xsl:copy-of select="./tailoringQuestionResponseText/daPlainTextTranslation/child::node()"
          />-->
          <xsl:for-each select="./tailoringQuestionResponseText/daPlainTextTranslation">
            <xsl:value-of select="."/>
            <xsl:text>&#xA0;</xsl:text>
          </xsl:for-each>
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
          <!--<xsl:if test="normalize-space(./tailoringQuestionResponseActivation/child::node()) != ''">-->
            <xsl:apply-templates select="./tailoringQuestionResponseActivation/child::node()"/>
          <!--</xsl:if>-->
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="daActivation">
    <!-- Write the values to the generated html -->
    <table class="daActivation-fixedTable">
      <tr>
        <td class="daActivation-fitToContent">Content Type</td>
        <td class="daActivation-fitToContent">:</td>
        <td class="daActivation-cellWrap">
          <xsl:value-of select="./@contentType"/>
        </td>
      </tr>
      <tr>
        <td class="daActivation-fitToContent">CMS ID</td>
        <td class="daActivation-fitToContent">:</td>
        <td class="daActivation-cellWrap">
          <xsl:value-of select="./@activatesId"/>
        </td>
      </tr>
      <tr>
        <td class="daActivation-fitToContent">Internal Name</td>
        <td class="daActivation-fitToContent">:</td>
        <td class="daActivation-cellWrap">
          <xsl:value-of select="./@internalName"/>
        </td>
      </tr>
      <tr>
        <td class="daActivation-fitToContent">Instance Name</td>
        <td class="daActivation-fitToContent">:</td>
        <td class="daActivation-cellWrap">
          <xsl:value-of select="./@instanceName"/>
        </td>
      </tr>
    </table>

    <!-- Test if the current node has a sibling which is also a daActivation node -->
    <xsl:if test="following-sibling::daActivation">
      <br/>
      <!-- Insert a <br> tag for adding a line break only if there is another daActivation node -->
    </xsl:if>
  </xsl:template>

  <xsl:template name="publishdate">
    <tr>
      <td class="label">EMS Publish Date</td>
      <td class="colon">:</td>
      <td class="value">
        <xsl:choose>
          <xsl:when test="count(./processing-instruction('cmsPublishDate')) > 0">
            <xsl:value-of select="./processing-instruction('cmsPublishDate')"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
