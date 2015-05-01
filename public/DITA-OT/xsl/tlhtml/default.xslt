<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:data="urn:schemas-microsoft-com:xml-data">
  <xsl:import href="footer.xslt"/>
  <xsl:output method="html" version="1.0" encoding="US-ASCII" indent="yes" />
  <!--Global variable to compare empty nodes-->
  <xsl:variable name="empty_string"/>
  <xsl:variable name="apos" select='"&apos;"'/>
  <xsl:variable name="and" select="'&amp;'"/>
  <xsl:param name="footerCollectionID"/>
  <xsl:param name="currentDocumentID"/>
  <xsl:param name="serverUrl" select="/.."/>
  <xsl:param name="default.table.width" select="'100%'"/>

  <!--***********************Root Nodes******************************************************-->
  <xsl:template match="/">
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

  <!--***********************To simply add a parent wrapper with class***********************-->
  <xsl:template match="*">
    <!--image is the only one that can be empty text and still be displayed-->
    <xsl:if test="normalize-space(.)!=$empty_string or (descendant::*[name()='image'])">
      <xsl:choose>
        <xsl:when test="@displayStyle='block'">
          <div class="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
          </div>
        </xsl:when>
        <xsl:when test="@displayStyle='none'">
          <!--No display-->
        </xsl:when>
        <xsl:otherwise>
          <span class="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!--***********************To write the text in the current node***************************-->
  <xsl:template match="title|qa-title|qa-id|pnum">
    <xsl:if test="normalize-space(.)!=$empty_string">
      <div>
        <!--Class attribute-->
        <xsl:copy-of select="@*"/>

        <xsl:if test="name()='title'">
          <!--For title add anchor for TOC scrolling-->
          <xsl:attribute name="id">
            <xsl:value-of select="@tnum"/>
          </xsl:attribute>
          <!--If there is subsection in the heirarchy and parent is pgroup then add '>'-->
          <xsl:if test="ancestor::*[name()='subsection'] and parent::*[name()='pgroup']">
            <xsl:for-each select="ancestor::*[name()='pgroup']">
              <xsl:value-of select="'> '"/>
            </xsl:for-each>
          </xsl:if>
        </xsl:if>

        <xsl:if test="name()='qa-id'">
          <xsl:value-of select="'Pre-Codification Reference - '"/>
        </xsl:if>

        <!--write the content-->
        <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />

        <!--Insert space after subsection pnum and normal pnum-->
        <!--Conversation with Debbie, Eng on July 29, insert 3 spaces after pnum-->
        <xsl:if test="name()='pnum'">
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </xsl:if>
      </div>

      <!--Related Links must be right after the first heading for all content except for qa-->
      <xsl:if test="name()='title' and contains(@class,'heading1') and not(//qa) and not(ancestor::dtl-general)">
        <xsl:call-template name="dtl-related-links"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="pgroup|paras|p-norm|pgq-group|glossentry|guidance|policy|para|section|qa">
    <a id="{@id}" href="#{@id}"/>
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="AttributesAndContent"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="AttributesAndContent"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--***********************HTML types such as p, b, i etc**********************************-->
  <xsl:template match="text|b|i">
    <xsl:param name="isFootNotes"/>
    <xsl:if test="normalize-space(.) != $empty_string and not(name(..)='fn' and $isFootNotes!=1)">
      <xsl:choose>
        <xsl:when test="@displayStyle='block'">
          <div>
            <xsl:call-template name="NormalText"/>
          </div>
        </xsl:when>
        <xsl:when test="@displayStyle='none'"/>
        <xsl:otherwise>
          <span>
            <xsl:call-template name="NormalText"/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="NormalText">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="p">
    <xsl:param name="isFootNotes"/>
    <xsl:if test="not(name(..)='fn' and $isFootNotes!=1)">
      <xsl:choose>
        <xsl:when test="@displayStyle='block'">
          <div>
            <xsl:call-template name="p"/>
          </div>
        </xsl:when>
        <xsl:when test="@displayStyle='none'"/>
        <xsl:otherwise>
          <span>
            <xsl:call-template name="p"/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="p">
    <!--Copy all attributes-->
    <xsl:copy-of select="@*[local-name()!='class']"/>

    <!--TODO:Remove when preprocess is updated-->
    <!--Since the p is no longer an html recognized tag, add the extra class here-->
    <xsl:attribute name="class">
      <xsl:value-of select="concat('paragraph ', @class)"/>
      <!-- **************************************************-->
      <!--This is a hack. This should be happening in the preprocess.-->
      <xsl:if test="name(preceding-sibling::*[1])='pnum' and not(contains(@class,'pnum_adjacent_p'))">
        <xsl:value-of select="' pnum_adjacent_p'"/>
      </xsl:if>
      <xsl:if test="name(preceding-sibling::*[1])='letter-report' and not(contains(@class,'letter-report_adjacent_p'))">
        <xsl:value-of select="' letter-report_adjacent_p'"/>
      </xsl:if>

      <xsl:if test="name(..)='lq' and not(contains(@class,'lq_p'))">
        <xsl:value-of select="' lq_p'"/>
      </xsl:if>
      <!-- **************************************************-->
    </xsl:attribute>

    <!--For certain elements, an anchor tag must be added for TOC scrolling-->
    <xsl:variable name="idValue">
      <xsl:choose>
        <xsl:when test="@id and normalize-space(@id) != $empty_string">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@pnum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <a id="{$idValue}" href="#{$idValue}"/>

    <xsl:apply-templates select="guidance-text|*|comment()|processing-instruction()|text()" />
  </xsl:template>

  <!--***********************Link types *****************************************************-->
  <xsl:template match="xref-DTL|xref-3rdParty|xref-fn|xref|glossref|xref-PDF|link|primary-link|secondary-link|xref-codUpdate">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="xref"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="xref"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="xref">
    <xsl:variable name="idValue">
      <xsl:call-template name="stringReplace">
        <xsl:with-param name="source">
          <xsl:choose>
            <xsl:when test="@anchor">
              <xsl:value-of select="concat(@href,'#',@anchor)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@href"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="match" select="'\\'"/>
        <xsl:with-param name="replace" select="'\'"/>
      </xsl:call-template>
    </xsl:variable>

    <!--If the link is empty then dont render it-->
    <xsl:choose>
      <xsl:when test="normalize-space($idValue) != $empty_string">
        <a class="{@class}">
          <xsl:attribute name="href">
            <xsl:choose>
              <xsl:when test="normalize-space($serverUrl) != $empty_string">
                <xsl:value-of select="concat($serverUrl,'?view=content',$and,'id=',$idValue)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="string('javascript:;')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:choose>
              <xsl:when test="@format='ditamap'">
                <!-- This is for the TOC links; Jeff (email dated 4/24), format = ditamap is the way to recognize a TOC link-->
                <xsl:value-of select="concat('getTocItem(',$apos,$idValue,$apos,');')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('getDocument(',$apos,$idValue,$apos,');')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

          <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <!--If the href is empty, then simply print the text with no link-->
        <span>
          <xsl:attribute name="class">
            <xsl:value-of select="'xref_no_link'"/>
            <xsl:if test="ancestor::dtl-related-links">
              <xsl:value-of select="' link'"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xref-document">
    <a>
      <xsl:variable name="docidValue">
        <xsl:choose>
          <xsl:when test="contains(@href,'.')">
            <xsl:value-of select="substring-before(@href,'.')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@href"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!--Copy all attributes except src-->
      <xsl:copy-of select="@*[local-name()!='src' and local-name()!='id' and local-name()!='href']"/>
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="contains(@href,'.pdf') or contains(@href,'.htm')">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('#',$docidValue)"/>
          </xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:value-of select="concat('getDocument(',$apos,$docidValue,$apos,'); return false;')"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('/contentgateway.axd?docid=',$docidValue)"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </a>
  </xsl:template>

  <xsl:template name="stringReplace">
    <xsl:param name ="source"/>
    <xsl:param name ="match"/>
    <xsl:param name ="replace"/>
    <xsl:choose>
      <xsl:when test="contains($source,$match)">
        <xsl:value-of select="concat(substring-before($source,$match),$replace)"/>
        <xsl:call-template name="stringReplace">
          <xsl:with-param name="source" select="substring-after($source,$match)"/>
          <xsl:with-param name="match" select="$match"/>
          <xsl:with-param name="replace" select="$replace"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$source"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="xref-external">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="xref-external"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="xref-external"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="xref-external">
    <a>
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="contains(@href,'http://')">
            <xsl:value-of select="@href"/>
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:value-of select="concat('http://',@href)"/>-->
            <!--Ruth, email dated Thursday, June 25, 2009 9:24 AM, no need to add the http:// since it will be in the incoming data-->
            <xsl:value-of select="@href"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="target">
        <xsl:value-of select="'_blank'"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </a>
  </xsl:template>

  <xsl:template match="fn">
    <xsl:param name="isFootNotes"/>
    <xsl:choose>
      <xsl:when test="$isFootNotes=1">
        <span>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="name()='fn' and normalize-space(@callout)!=$empty_string">
              <xsl:value-of select="@callout"/>
            </xsl:when>
            <xsl:when test="name()='xref-fn' and normalize-space(.)!=$empty_string">
              <xsl:value-of select="."/>
            </xsl:when>
          </xsl:choose>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <sup>
          <span>
            <xsl:attribute name="class">
              <xsl:value-of select="'footnote_link'"/>
            </xsl:attribute>
            <xsl:call-template name="footnote">
              <xsl:with-param name="text" select="'link'"/>
              <xsl:with-param name="link" select="'text'"/>
              <xsl:with-param name="class" select="'xref footnote_link'"/>
            </xsl:call-template>
          </span>
        </sup>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="footnotesContent">
    <span>
      <!--If there are any footnotes, add the class name and insert a separator line at the beginning-->
      <xsl:if test="//fn">
        <xsl:attribute name="class">
          <xsl:value-of select="footnotes"/>
        </xsl:attribute>
        <xsl:text>________________________________________________</xsl:text>
        <br/>
      </xsl:if>
      <xsl:for-each select="//fn">
        <xsl:choose>
          <xsl:when test="@displayStyle='block'">
            <div>
              <xsl:call-template name="footnoteContent"/>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <span>
              <xsl:call-template name="footnoteContent"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
        <br/>
      </xsl:for-each>
    </span>
  </xsl:template>

  <xsl:template name="copyFootNotes">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="footnotesContent"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="footnotesContent"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="footnoteContent">
    <xsl:copy-of select="@*"/>
    <xsl:call-template name="footnote">
      <xsl:with-param name="text" select="'text'"/>
      <xsl:with-param name="link" select="'link'"/>
      <xsl:with-param name="class" select="'fn'"/>
    </xsl:call-template>
    <!--insert a space after the footnote identifier-->
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates select="*|comment()|processing-instruction()|text()" >
      <xsl:with-param name="isFootNotes" select="1"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="footnote">
    <xsl:param name="text"/>
    <xsl:param name="link"/>
    <xsl:param name="class"/>
    <!--This is a link within the same document. This still has to go through getDocument-->
    <xsl:variable name="id" select="concat('footnote_',$text,'_',@id)"/>
    <xsl:variable name="href" select="concat($currentDocumentID,'#',$id)"/>
    <a href="{$href}" id="{$id}" class="{$class}">
      <xsl:attribute name="onclick">
        <xsl:variable name="linkValue" select="concat($currentDocumentID,'#footnote_',$link,'_',@id)"/>
        <xsl:value-of select="concat('getDocument(',$apos,$linkValue,$apos,');return false;')"/>
      </xsl:attribute>
      <xsl:value-of select="@name"/>
    </a>
  </xsl:template>

  <xsl:template match="image">
    <!--Adding a div around all images so it doesnt mess up the text display-->
    <div>
      <img>
        <!--Copy all attributes except src-->
        <xsl:copy-of select="@*[local-name()!='src' and local-name()!='id' and local-name()!='href' and local-name()!='align']"/>
        <xsl:attribute name="src">
          <!-- remove contentgateway prefix to allow viewing standalone -->
          <!-- xsl:value-of select="concat('/contentgateway.axd?img=',@href)"/ -->
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </img>
    </div>
  </xsl:template>

  <xsl:template match="linktext">
    <span>
      <xsl:copy-of select="@*"/>
      <xsl:if test="ancestor::dtl-related-links and normalize-space(../@href) = $empty_string">
        <xsl:attribute name="style">
          <xsl:value-of select="'text-decoration:none;'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </span>
  </xsl:template>

  <!--***********************Lists***********************************************************-->
  <xsl:template match="ol|ul">
    <xsl:element name="{name()}">
      <!--Copy all attributes-->
      <xsl:copy-of select="@*"/>
      <xsl:variable name="outputclass" select="@outputclass"/>
      <xsl:for-each select="li">
        <li>
          <xsl:copy-of select="@*"/>
          <!--If there is no text for a list item, the item bullet is not showing CQ3607-->
          <xsl:if test="normalize-space(text())=$empty_string and (name(child::*[1])='ol' or name(child::*[1])='ul')">
            <span class="paragraph li_p">
              <xsl:text>&#160;</xsl:text>
            </span>
          </xsl:if>
          <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
        </li>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="linum">
    <span>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="concat(.,'.')"/>
    </span>
  </xsl:template>

  <xsl:template name="sl">
    <!--Copy all attributes-->
    <xsl:copy-of select="@*"/>
    <xsl:for-each select="sli">
      <xsl:choose>
        <xsl:when test="@displayStyle='block'">
          <div>
            <xsl:call-template name="AttributesAndContent"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <span>
            <xsl:call-template name="AttributesAndContent"/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="sl">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="sl"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="sl"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="AttributesAndContent">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
  </xsl:template>

  <!--***********************Tables**********************************************************-->
  <xsl:template match="table">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tgroup">
    <!--CQ 4981: For tables inside guidance-example, add an extra space/line before the table-->
    <xsl:if test="ancestor::*[name()='guidance-example']">
      <br/>
    </xsl:if>
    <table>
      <!--align is causing the succeeding table to be on the same line as current table-->
      <xsl:copy-of select="@*[local-name()!='class' and local-name()!='align']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="../@class"/>
      </xsl:attribute>

      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="colgroup | thead | tfoot| tbody | tr | td | th | col">
    <xsl:call-template name="NormalText"/>
  </xsl:template>

  <!--***********************GAAP specific***************************************************-->
  <!--sfragment needs to be in [ ]-->
  <xsl:template match="sfragment">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="sfragment"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="sfragment"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sfragment">
    <xsl:copy-of select="@*"/>
    <span class="sfragment_before">
      <xsl:value-of select="'['"/>
    </span>
    <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    <span class="sfragment_after">
      <xsl:value-of select="']'"/>
    </span>
  </xsl:template>

  <xsl:template match="sfragdata">
    <!--
			You need to:
				make the value of <att name="standard_name” display first and add a space
				make the value of <att name="standard_number" display second
				add a comma (,) after item 2 and add a space
				add the word “paragraph” and add a space
				make the value of <att name="para_number" display last-->
    <span>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="att[@name='standard_name']"/>
      <xsl:value-of select="' '"/>
      <xsl:value-of select="att[@name='standard_number']"/>
      <xsl:value-of select="', paragraph '"/>
      <xsl:value-of select="att[@name='para_number']"/>
    </span>
  </xsl:template>

  <xsl:template match="pgq-critdates|critdates">
    <!--These dates do not have any content to display but still need to be in the result HTML
    as they are used during the search-->
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="AttributesAndContent"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="AttributesAndContent"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dtl-related-links">
    <xsl:if test="//dtl-related-links and normalize-space(//dtl-related-links/.)!=$empty_string">
      <span class="related-links related_links_linklist">
        <xsl:apply-templates select="//dtl-related-links/*"/>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dtl-related-links">
    <xsl:if test="normalize-space(.)!=$empty_string">
      <span>
        <!--For QA, allow the Related Links to be at the bottom-->
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="//qa or (name(..)='pgroup' and ancestor::dtl-general)">
              <xsl:value-of select="'related-links related_links_linklist'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'related-links-bottom'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <xsl:choose>
          <xsl:when test="//qa">
            <xsl:apply-templates select="//dtl-related-links/*"/>
          </xsl:when>
          <xsl:when test="name(..)='pgroup' and ancestor::dtl-general">
            <xsl:apply-templates/>
          </xsl:when>
        </xsl:choose>
      </span>
    </xsl:if>
  </xsl:template>

  <!--***********************qa specific*****************************************************-->
  <xsl:template match="processing-instruction('xm-deletion_mark')
                |processing-instruction('xm-insertion_mark_start')
                |processing-instruction('xm-insertion_mark_end')">
    <!--Per my conversation with Kevin Hannon, these need to be in the Html, so write 
    them as processing instructions-->
    <xsl:processing-instruction name="{name()}">
      <!--since the processing instruction does not have real "attributes" copy the string-->
      <xsl:value-of select="."/>

      <!--TODO:This is a hack; the </xsl:processing-instruction> tag should close the
      html properly but is not. Investigate and remove later-->
      <xsl:text>?</xsl:text>
      <!--TODO END-->

    </xsl:processing-instruction>
  </xsl:template>

  <!--***********************Ignore Elements*************************************************-->
  <xsl:template match="content-domain|content-type|content-provider|titlealts|navtitle|published-date|language
				  |exclude-from-index|include-in-toc|open-from-toc|recall">
    <!--These elements should be ignored for text display
        So keep the attributes, add the text as attribute-->
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="text">
        <!-- commented for Word-Match functionality 
				<xsl:value-of select="."/> -->
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!--***********************Add Content*****************************************************-->
  <xsl:template match="issued">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="issued"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="issued"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="issued">
    <xsl:attribute name="class">
      <xsl:value-of select="'issued'"/>
    </xsl:attribute>
    <xsl:if test="@date">
      <xsl:value-of select="concat('[Issue Date: ',@date,']')"/>
    </xsl:if>
    <xsl:if test="@golive">
      <xsl:value-of select="concat('[Effective Date: ',@golive,']')"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="linkref">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="linkref"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="linkref"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="linkref">
    <xsl:if test="normalize-space(.) != $empty_string">
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="name(..)='primary-link'">
          <xsl:value-of select="concat('Primary Reference: ',.)"/>
        </xsl:when>
        <xsl:when test="name(..)='secondary-link' and name(../preceding-sibling::*)!='secondary-link' and
						  name(../preceding-sibling::secondary-link) != 'secondary-link'">
          <xsl:choose>
            <xsl:when test="name(../following-sibling::*)='secondary-link'">
              <xsl:value-of select="concat('Secondary References: ',.)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('Secondary Reference: ',.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="name(..)='secondary-link'">
            <xsl:value-of select="concat(', ',.)"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="created">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div>
          <xsl:call-template name="created"/>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="created"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="created">
    <xsl:attribute name="class">
      <xsl:value-of select="'created created_after'"/>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="normalize-space(.) != $empty_string">
        <xsl:value-of select="concat('Created: ',.)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('Created: ', @date)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="revised">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div class="revised_after">
          <xsl:if test="normalize-space(.) != $empty_string">
            <xsl:value-of select="concat('Revised: ',.)"/>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span class="revised_after">
          <xsl:if test="normalize-space(.) != $empty_string">
            <xsl:value-of select="concat('Revised: ',.)"/>
          </xsl:if>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="reserved|reserved-date">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div class="reserved">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Reserved: ',@date,']')"/>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span class="reserved">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Reserved: ',@date,']')"/>
          </xsl:if>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="renumbered|renumbered-date">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div class="renumbered">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Renumbered: ',@date,']')"/>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span class="renumbered">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Renumbered: ',@date,']')"/>
          </xsl:if>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="amended|amended-date">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div class="amended">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Amended: ',@date,']')"/>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span class="amended">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Amended: ',@date,']')"/>
          </xsl:if>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="deleted|deleted-date">
    <xsl:choose>
      <xsl:when test="@displayStyle='block'">
        <div class="deleted">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Deleted: ',@date,']')"/>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:when test="@displayStyle='none'"/>
      <xsl:otherwise>
        <span class="deleted">
          <xsl:if test="@date">
            <xsl:value-of select="concat('[Deleted: ',@date,']')"/>
          </xsl:if>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="q">
    <xsl:value-of select="$apos"/>
    <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    <xsl:value-of select="$apos"/>
  </xsl:template>

  <xsl:template match="pending-text">
    <span class="pending-text">
      <span class="pending-text_before">
        <xsl:value-of select="'Pending Content'"/>
      </span>
      <span class="pending_text_dates">
        <xsl:apply-templates select="date-effective | transition-guidance-ref"/>
      </span>
      <xsl:apply-templates select="*[name()!='date-effective' and name()!='transition-guidance-ref']|comment()|processing-instruction()|text()"/>
    </span>
  </xsl:template>

  <xsl:template match="date-effective">
    <span class="date-effective">
      <span class="date-effective_before">
        <xsl:value-of select="'Transition Date: '"/>
      </span>
      <xsl:apply-templates/>
      <span class="date-effective_after">
        <xsl:value-of select="' | '"/>
      </span>
    </span>
  </xsl:template>

  <xsl:template match="transition-guidance-ref">
    <span class="transition-guidance-ref_before">
      <xsl:value-of select="'Transition Guidance: '"/>
    </span>
    <span class="transition-guidance-ref">
      <xsl:call-template name="xref"/>
      <br/>
    </span>
  </xsl:template>
	<xsl:template match="//*[@outputclass='dgl']">

		<div class="green_box_border">
			<span class="{name()}">
				<xsl:copy-of select="@*"/>
				<!--<xsl:if test="name()!='subsection'">-->
					<div class="green_header_background" >

						<span class="green_header_text">
							<xsl:text>Deloitte Guidance and Links</xsl:text>
						</span>
					</div>
				<!--</xsl:if>-->

				<xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
			</span>
		</div>
	</xsl:template>
	<xsl:template match="//*[@outputclass='box-emphasis']">
		<div class="green_box_border">
			<span class="{name()}">
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
			</span>
		</div>
	</xsl:template>

	<xsl:template match="//*[@outputclass='inline-emphasis']">

		<span class="green_header_text">
			<xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
		</span>

	</xsl:template>

  <xsl:template match="xbrlElement">
    <li class="elementli">
      <div class="elementLabel">
        <xsl:value-of select="elementLabel"/>
      </div>
      <div class="xbrlElementCamelCaseName">
        <B>Element Name: </B>
        <I>
          <xsl:value-of select="elementName"/>
        </I>
        <xsl:if test="xbrl-prolog/xbrlRevisionDate">
          <span>
            (RevisionDate:
          </span>
          <span>
            <xsl:value-of select="xbrl-prolog/xbrlRevisionDate"/>
          </span>
          <span>)</span>
          
        </xsl:if>
      </div>
      <ul class="thissubtopiclist">
        <xsl:apply-templates select="references/link" />
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="references/link">

    <li class="xbrlLink" >
      <span>
        <xsl:variable name="sq">
          <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:variable name="xbrlhref" select="concat('getDocument(',$sq,@href,$sq,');')"/>

        <a href="javascript:;" >
          <xsl:attribute name="onclick">
            <xsl:value-of select="$xbrlhref"/>
          </xsl:attribute>

          <xsl:value-of select="desc"/>
        </a>
      </span>
    </li>
  </xsl:template>
  
</xsl:stylesheet>
